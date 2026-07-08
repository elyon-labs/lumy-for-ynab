import 'package:blackbird/blackbird.dart';
import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/transactions/filters.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../../common/domain/worker/_transactions_sync.dart';
import '../../../../common/domain/worker/worker.dart';
import '../../../../persistence/drift/local_database.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_local_date.dart';
import '../../../../utils/sort.dart';
import '../../../../ynab_api/_transaction.dart';
import '../../../date_range/domain/models/date_range.dart';
import '../models/spend_tracker.dart';
import '../models/spend_tracker_data.dart';
import '../models/transaction_conditions.dart';
import 'watch_all_spend_trackers.dart';

class WatchSpendTrackerData {
  WatchSpendTrackerData({
    required WatchAllSpendTrackers watchAllSpendTrackers,
    required Settings settings,
    required TransactionsRepository transactionsRepository,
    required LocalDatabase database,
    required Worker worker,
  }) : _settings = settings,
       _watchAllSpendTrackers = watchAllSpendTrackers,
       _transactionsRepository = transactionsRepository,
       _worker = worker,
       _database = database;

  factory WatchSpendTrackerData.create() {
    return WatchSpendTrackerData(
      watchAllSpendTrackers: WatchAllSpendTrackers.create(),
      settings: inject(),
      transactionsRepository: inject(),
      database: inject(),
      worker: inject(),
    );
  }

  final WatchAllSpendTrackers _watchAllSpendTrackers;
  final Settings _settings;
  // TOOD: Swap out for other use cases when we migrate
  final TransactionsRepository _transactionsRepository;
  final Worker _worker;
  final LocalDatabase _database;

  Stream<SpendTrackerData> call(String spendTrackerId) {
    final spendTrackersStream = _watchAllSpendTrackers();
    final budgetIdStream = _settings.watchSelectedBudgetId();
    final selectedDateRangeStream = _settings.watchSelectedDateRange();
    const transactionsView = TransactionsView(
      dateRange: SelectedDateRange(),
      accounts: AllAccounts(),
      categories: AllCategories(),
      filter: NoFilter(),
    );
    final transactionsStream = _transactionsRepository.watch(transactionsView);

    return Rx.combineLatest4(
      budgetIdStream,
      selectedDateRangeStream,
      transactionsStream,
      spendTrackersStream,
      (a, b, c, d) => (a, b, c, d, spendTrackerId),
    ).switchMap((value) async* {
      final (budgetId, selectedDateRange, onBudgetTransactions, spendTrackers, spendTrackerId) =
          value;
      switch (budgetId) {
        case Some(:final some):
          final categoriesStream = _database.watchCategories(budgetId: some);
          final categoryGroupsStream = _database.watchCategoryGroups(budgetId: some);
          final payeesStream = _database.watchPayees(budgetId: some);
          final accountsStream = _database.watchAccounts(budgetId: some);

          yield* Rx.combineLatest4(
            categoriesStream,
            categoryGroupsStream,
            payeesStream,
            accountsStream,
            (a, b, c, d) => (a, b, c, d, spendTrackerId, onBudgetTransactions, spendTrackers),
          ).switchMap((event) async* {
            final (
              categories,
              categoryGroups,
              payees,
              accounts,
              spendTrackerId,
              onBudgetTransactions,
              spendTrackers,
            ) = event;

            final spendTracker = spendTrackers.firstWhereOrNull((e) => e.id == spendTrackerId);
            if (spendTracker == null) {
              yield* NeverStream();
            } else {
              yield await calculateSpendTrackerDataInWorker(
                worker: _worker,
                spendTracker: spendTracker,
                onBudgetTransactions: onBudgetTransactions,
                categoryGroups: categoryGroups,
                categories: categories,
                payees: payees,
                accounts: accounts,
                selectedDateRange: selectedDateRange,
              );
            }
          });

        case None():
          yield* NeverStream();
      }
    });
  }
}

Future<SpendTrackerData> calculateSpendTrackerDataInWorker({
  required Worker worker,
  required SpendTracker spendTracker,
  required List<PastTransaction> onBudgetTransactions,
  required List<CategoryGroup> categoryGroups,
  required List<Category> categories,
  required List<Payee> payees,
  required List<Account> accounts,
  required DateRange selectedDateRange,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateSpendTrackerDataSync(
      spendTracker: spendTracker,
      onBudgetTransactions: onBudgetTransactions,
      categoryGroups: categoryGroups,
      categories: categories,
      payees: payees,
      accounts: accounts,
      selectedDateRange: selectedDateRange,
    ),
  );
}

SpendTrackerData calculateSpendTrackerDataSync({
  required SpendTracker spendTracker,
  required List<PastTransaction> onBudgetTransactions,
  required List<CategoryGroup> categoryGroups,
  required List<Category> categories,
  required List<Payee> payees,
  required List<Account> accounts,
  required DateRange selectedDateRange,
}) {
  final filter = spendTrackerFilter(spendTracker, categoryGroups);
  final incomeSum = onBudgetTransactions.sumAmountFilteredSync(isIncome);
  final filtered = onBudgetTransactions.filterSync(filter);

  final grouped = groupBy(filtered, (t) => t.localDate.firstDayOfMonth()).sortByKeys(dateDesc);
  final groupedSum = grouped.mapValues((value) => value.sumAmountFilteredSync(filter));
  final sorted = groupedSum.sortByValues(intDesc);
  final maxSpend = sorted.entries.lastOrNull;
  final minSpend = sorted.entries.firstOrNull;

  final monthsInRange = selectedDateRange.monthsInRange();
  final sumAmount = filtered.sumAmountFilteredSync(filter);
  final percentIncome = incomeSum == 0 ? 0.0 : sumAmount.abs() / incomeSum;
  final transactionsCount = filtered.countFilteredSync(filter);
  final duration = selectedDateRange.duration();
  final transactionsPerWeek = duration.inDays < 7
      ? transactionsCount.toDouble()
      : transactionsCount / (duration.inDays / 7);
  final averageWeeklySpend = duration.inDays < 7
      ? sumAmount.toDouble()
      : sumAmount / (duration.inDays / 7);
  final numberOfMonths = monthsInRange.length;
  final transactionsPerMonth = transactionsCount / numberOfMonths;
  final averageMonthlySpend = sumAmount / numberOfMonths;

  final filteredByMonth = groupBy(filtered, (t) => t.localDate.firstDayOfMonth());
  final spendPerMonth = <LocalDate, int>{};
  for (final month in monthsInRange) {
    final transactionsForMonth = filteredByMonth[month] ?? [];
    spendPerMonth[month] = transactionsForMonth.sumAmountFilteredSync(filter);
  }

  return SpendTrackerData(
    spendTracker: spendTracker,
    description: _spendTrackerDescription(
      spendTracker: spendTracker,
      categories: categories,
      categoryGroups: categoryGroups,
      payees: payees,
      accounts: accounts,
    ),
    netTotal: sumAmount,
    transactionsCount: transactionsCount,
    monthsToTransactions: filtered.groupByDateSync(dateDesc),
    transactionsPerWeek: transactionsPerWeek,
    averageWeeklySpend: averageWeeklySpend.toInt(),
    transactionsPerMonth: transactionsPerMonth,
    averageMonthlySpend: averageMonthlySpend.toInt(),
    monthsToSpend: spendPerMonth,
    percentIncome: percentIncome,
    minSpendForMonth: minSpend != null ? (month: minSpend.key, spend: minSpend.value) : null,
    maxSpendForMonth: maxSpend != null ? (month: maxSpend.key, spend: maxSpend.value) : null,
  );
}

String? _spendTrackerDescription({
  required SpendTracker spendTracker,
  required List<Category> categories,
  required List<CategoryGroup> categoryGroups,
  required List<Payee> payees,
  required List<Account> accounts,
}) {
  String? descriptionForCategory(String categoryId, {required bool isTrue}) {
    final category = categories.firstWhereOrNull((c) => c.id == categoryId);
    return category != null
        ? isTrue
              ? 'Transactions categorized as **${category.name}**.'
              : 'Transactions not categorized as **${category.name}**.'
        : null;
  }

  String? descriptionForCategoryGroup(String categoryGroupId, {required bool isTrue}) {
    final categoryGroup = categoryGroups.firstWhereOrNull((g) => g.id == categoryGroupId);
    return categoryGroup != null
        ? isTrue
              ? 'Transactions categorized as **${categoryGroup.name}**.'
              : 'Transactions not categorized as **${categoryGroup.name}**.'
        : null;
  }

  String? descriptionForAccount(String accountId, {required bool isTrue}) {
    final account = accounts.firstWhereOrNull((g) => g.id == accountId);
    return account != null
        ? isTrue
              ? 'Transactions categorized as **${account.name}**.'
              : 'Transactions not categorized as **${account.name}**.'
        : null;
  }

  String? descriptionForFlag(String flagName, {required bool isTrue}) {
    final flag = Flag.values.firstWhereOrNull((f) => f.name == flagName);
    return flag != null
        ? isTrue
              ? 'Transactions flagged with a **${flag.name}** flag.'
              : 'Transactions not flagged with a **${flag.name}** flag.'
        : null;
  }

  String? descriptionForMemo(String memo, {required bool isTrue}) {
    return isTrue
        ? 'Transactions with memo containing **$memo**.'
        : 'Transactions without memo containing **$memo**.';
  }

  String? descriptionForPayee(String payeeId, {required bool isTrue}) {
    final payee = payees.firstWhereOrNull((p) => p.id == payeeId);
    return payee != null
        ? isTrue
              ? 'Transactions with payee **${payee.name}**.'
              : 'Transactions without payee **${payee.name}**.'
        : null;
  }

  return switch (spendTracker.condition) {
    IsTrue<TransactionTestPayload, TransactionTest>(:final test) => switch (test) {
      HasFlagColor(:final value) => descriptionForFlag(value, isTrue: true),
      HasPayeeId(:final value) => descriptionForPayee(value, isTrue: true),
      HasCategoryId(:final value) => descriptionForCategory(value, isTrue: true),
      HasCategoryGroupId(:final value) => descriptionForCategoryGroup(value, isTrue: true),
      HasAccountId(:final value) => descriptionForAccount(value, isTrue: true),
      HasMemoKeyword(:final value) => descriptionForMemo(value, isTrue: true),
      IsIncome() => 'On-budget transactions that are income.',
      IsInflow() => 'Transactions that are inflows.',
      IsExpense() => 'On-budget transactions that are expenses.',
      IsOutflow() => 'Transactions that are outflows.',
    },
    IsNotTrue<TransactionTestPayload, TransactionTest>(:final test) => switch (test) {
      HasFlagColor(:final value) => descriptionForFlag(value, isTrue: false),
      HasPayeeId(:final value) => descriptionForPayee(value, isTrue: false),
      HasCategoryId(:final value) => descriptionForCategory(value, isTrue: false),
      HasCategoryGroupId(:final value) => descriptionForCategoryGroup(value, isTrue: false),
      HasAccountId(:final value) => descriptionForAccount(value, isTrue: false),
      HasMemoKeyword(:final value) => descriptionForMemo(value, isTrue: false),
      IsIncome() => 'Transactions that are not income.',
      IsInflow() => 'Transactions that are not inflows.',
      IsExpense() => 'Transactions that are not expenses.',
      IsOutflow() => 'Transactions that are not outflows.',
    },
    _ => null, // Don't describe complex conditions
  };
}

// TODO: See if the JSON serialization is actually necessary.
TransactionFilter spendTrackerFilter(SpendTracker tracker, List<CategoryGroup> categoryGroups) {
  // Serialize the condition so the returned closure only captures sendable data.
  // The condition is lazily reconstructed in the target isolate on first use.
  final json = TransactionConditionX.toJson(tracker.condition);
  TransactionCondition? cond; // lazily initialized inside the isolate
  return (BaseTransaction t, BaseTransaction? parent) {
    cond ??= TransactionConditionX.fromJson(json);
    return (cond!).evaluateSafe((txn: t, parent: parent, groups: categoryGroups));
  };
}
