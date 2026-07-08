import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/transactions/filters.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../../common/domain/worker/worker.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../../utils/_local_date.dart';
import '../../../../ynab_api/_category.dart';
import '../../../../ynab_api/_transaction.dart';
import '../../../date_range/domain/models/date_range.dart';
import '../targets_health_report_chart.dart';

enum TargetsHealthStatus { healthy, needsAttention }

class TargetsHealthReportChartData extends Equatable {
  const TargetsHealthReportChartData({required this.status, required this.categoryTargets});

  final TargetsHealthStatus status;
  final List<CategoryTargetInformation> categoryTargets;

  @override
  List<Object?> get props => [status, categoryTargets];
}

class CategoryTargetInformation extends Equatable {
  const CategoryTargetInformation({
    required this.category,
    required this.monthlyAmountBudgeted,
    required this.monthlyAmountSpent,
    required this.gap,
  });

  /// The category this target is for
  final Category category;

  /// The amount budgeted in order to fund this target per month
  final int monthlyAmountBudgeted;

  /// The amount the user has spent on this category per month on average.
  final int monthlyAmountSpent;

  /// The difference between the period target amount and the period spent
  /// If negative, the user has been overspending their target.
  final int gap;

  @override
  List<Object?> get props => [category, monthlyAmountBudgeted, monthlyAmountSpent, gap];
}

class TargetsHealthReportChartDataCubit extends Cubit<Async<TargetsHealthReportChartData>> {
  TargetsHealthReportChartDataCubit({
    required Settings settings,
    required CategoriesRepository categoriesRepo,
    required TransactionsRepository transactionsRepo,
    required Worker worker,
  }) : _transactionsRepository = transactionsRepo,
       _categoriesRepository = categoriesRepo,
       _worker = worker,
       _settings = settings,
       super(const Loading()) {
    fetch();
  }

  factory TargetsHealthReportChartDataCubit.create() {
    return TargetsHealthReportChartDataCubit(
      settings: inject(),
      categoriesRepo: inject(),
      transactionsRepo: inject(),
      worker: inject(),
    );
  }

  final Settings _settings;
  final CategoriesRepository _categoriesRepository;
  final TransactionsRepository _transactionsRepository;
  final Worker _worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = TargetsHealthReportChart();
    final accountsSetting = _settings.watchChartAccounts(chart);
    // Get each category in the selected view
    const categoryView = ExpensesInSelectedView();

    // 1️⃣ The transactions stream depends on accountsSetting
    final transactions = accountsSetting.switchMap((accounts) {
      return _transactionsRepository.watch(
        TransactionsView(
          dateRange: const AllTime(),
          accounts: accounts.mapOr(AccountsWithIds.new, AccountsInFilter(chart.accountFilter)),
          categories: categoryView,
          filter: const ExpenseFilter(),
          debugId: 'reports.targets_health.transactions',
        ),
      );
    });

    // 2️⃣ categories stream is independent
    final categories = _categoriesRepository.watchCategories(categoryView);

    // 3️⃣ Combine *all* streams reactively
    final sub =
        Rx.combineLatest3(
              categories,
              transactions,
              _settings.watchSelectedDateRange(),
              (cats, txns, range) => (cats, txns, range),
            )
            .switchMap((event) async* {
              final (categories, transactions, dateRange) = event;

              final data = await calculateTargetsHealthInWorker(
                worker: _worker,
                categories: categories,
                transactions: transactions,
                dateRange: dateRange,
              );

              yield Loaded(data);
            })
            .listen(safeEmit);

    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

Future<TargetsHealthReportChartData> calculateTargetsHealthInWorker({
  required Worker worker,
  required List<Category> categories,
  required List<PastTransaction> transactions,
  required DateRange dateRange,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateTargetsHealthSync(
      categories: categories,
      transactions: transactions,
      dateRange: dateRange,
    ),
  );
}

TargetsHealthReportChartData calculateTargetsHealthSync({
  required List<Category> categories,
  required List<PastTransaction> transactions,
  required DateRange dateRange,
}) {
  // For each category, calculate the amount needed for funding this target
  // for the period the user has selected.
  final recurringTargetCategories = categories.where(
    // Since we will be displaying targets adjusted to a monthly amount,
    // ensure the category has a monthly needed amount ()
    (c) => c.hasRecurringTarget && c.monthlyNeededForTarget != null,
  );

  final monthlyNeeded = Map.fromEntries(
    recurringTargetCategories.map((c) {
      final monthlyNeeded = c.monthlyNeededForTarget;
      return MapEntry(c, monthlyNeeded);
    }),
  );

  final monthsInDateRange = dateRange.monthsInRange().length;

  // For each category, calculate the amount the user has spent on average.
  final monthlySpent = Map.fromEntries(
    recurringTargetCategories.map((category) {
      final monthsInTargetCadence = category.monthsInTargetCadence;
      // If the target cadence (in months) is greater than the number of months in the date range,
      // defer to the target cadence when calculating monthly average spent. This allows, for instance, annual targets
      // to be averaged over 12 months, even if the user is looking at a shorter date range.
      final useMonthsInTargetCadence =
          monthsInTargetCadence != null && monthsInTargetCadence > monthsInDateRange;
      // Only consider transactions that happened in the target cadence or in the selected date range.
      final transactionsInRange = useMonthsInTargetCadence
          ? transactions
                .where(
                  (t) => t.localDate.isBetween(
                    dateRange.to.subtractMonths(monthsInTargetCadence),
                    dateRange.to,
                  ),
                )
                .toList()
          : transactions.where((t) => t.localDate.isBetween(dateRange.from, dateRange.to)).toList();
      final spentForCategory = transactionsInRange.sumAmountFilteredSync(
        isExpenseInCategory(category),
      );
      // The denominator for the average spent per month is either the number of months in the target cadence
      // or the number of months in the date range, depending on whether the target cadence is used.
      final spendingMonths = useMonthsInTargetCadence ? monthsInTargetCadence : monthsInDateRange;

      return MapEntry(category, spentForCategory ~/ spendingMonths);
    }),
  );

  // For each category, calculate the difference between the period target
  // amount and the period spent. If negative, the user has been overspending.
  final gap = Map.fromEntries(
    recurringTargetCategories.map((c) {
      final target = monthlyNeeded[c];
      final spent = monthlySpent[c];
      if (target == null || spent == null) return null;
      final gap = target + spent;
      return MapEntry(c, gap);
    }).nonNulls,
  );

  final status = gap.values.any((g) => g.isNegative)
      ? TargetsHealthStatus.needsAttention
      : TargetsHealthStatus.healthy;

  // Return the list of categories with the calculated information
  return TargetsHealthReportChartData(
    status: status,
    categoryTargets:
        recurringTargetCategories
            .map(
              (c) => CategoryTargetInformation(
                category: c,
                monthlyAmountBudgeted: monthlyNeeded[c]!,
                monthlyAmountSpent: monthlySpent[c]!,
                gap: gap[c]!,
              ),
            )
            .sorted((a, b) => a.gap.compareTo(b.gap))
            .toList()
          // Don't bother showing target info when there is no spending
          ..removeWhere((c) => c.monthlyAmountSpent >= 0),
  );
}
