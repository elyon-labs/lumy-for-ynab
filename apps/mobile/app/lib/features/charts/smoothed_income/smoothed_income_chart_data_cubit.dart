import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/transactions/filters.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../common/domain/worker/_transactions_sync.dart';
import '../../../common/domain/worker/worker.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../date_range/domain/models/date_range.dart';
import 'smoothed_income_chart.dart';

class SmoothedIncomeChartDataCubit extends Cubit<Async<SmoothedIncomeChartData>> {
  SmoothedIncomeChartDataCubit({
    required this.settings,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory SmoothedIncomeChartDataCubit.create() {
    return SmoothedIncomeChartDataCubit(
      settings: inject(),
      transactionsRepo: inject(),
      worker: inject(),
    );
  }

  final Settings settings;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = SmoothedIncomeChart();
    final accountsSetting = settings.watchChartAccounts(chart);

    final sub = accountsSetting
        .switchMap((accounts) async* {
          final accountsView = accounts.mapOr(
            AccountsWithIds.new,
            AccountsInFilter(chart.accountFilter),
          );
          final inDateRange = transactionsRepo.watch(
            TransactionsView(
              dateRange: const SelectedDateRange(),
              accounts: accountsView,
              categories: const AllCategories(),
              filter: const NoFilter(),
              debugId: 'reports.smoothed_income.in_date_range',
            ),
          );
          final inDateRangeAndView = transactionsRepo.watch(
            TransactionsView(
              dateRange: const SelectedDateRange(),
              accounts: accountsView,
              categories: const CategoriesInSelectedView(),
              filter: const NoFilter(),
              debugId: 'reports.smoothed_income.in_date_range_and_view',
            ),
          );
          final selectedDateRange = settings.watchSelectedDateRange();
          yield* Rx.combineLatest3(
            inDateRange,
            inDateRangeAndView,
            selectedDateRange,
            (a, b, c) => (a, b, c),
          );
        })
        .switchMap((event) async* {
          final (inDateRange, inDateRangeAndView, selectedDateRange) = event;
          final data = await calculateSmoothedIncomeInWorker(
            worker: worker,
            inDateRange: inDateRange,
            inDateRangeAndView: inDateRangeAndView,
            selectedDateRange: selectedDateRange,
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

Future<SmoothedIncomeChartData> calculateSmoothedIncomeInWorker({
  required Worker worker,
  required List<PastTransaction> inDateRange,
  required List<PastTransaction> inDateRangeAndView,
  required DateRange selectedDateRange,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateSmoothedIncomeSync(
      inDateRange: inDateRange,
      inDateRangeAndView: inDateRangeAndView,
      selectedDateRange: selectedDateRange,
    ),
  );
}

SmoothedIncomeChartData calculateSmoothedIncomeSync({
  required List<PastTransaction> inDateRange,
  required List<PastTransaction> inDateRangeAndView,
  required DateRange selectedDateRange,
}) {
  final totalIncome = inDateRange.sumAmountFilteredSync(isIncome);

  final allDaysInDuration = selectedDateRange.daysInRange();
  final duration = selectedDateRange.duration();

  final dates = selectedDateRange.monthsInRange();

  final expenseTransactions = inDateRangeAndView.filterSync(isExpense);
  final dailyIncome = totalIncome ~/ duration.inDays;

  final datesToTransactions = expenseTransactions.groupByDateSync();

  // Sum up the amount of transactions for each day.
  final spendByDate = <LocalDate, int>{};
  for (final entry in datesToTransactions.entries) {
    spendByDate[entry.key] = entry.value.sumAmountFilteredSync(isExpense);
  }

  // Offset each day's spend with daily income
  final netIncomeByDate = Map.fromEntries(
    allDaysInDuration.map((date) {
      final spend = spendByDate[date] ?? 0;
      return MapEntry(date, spend + dailyIncome);
    }),
  );

  // Calculate the average net income for each day of each month.
  final datesToAvgNetIncome = Map.fromEntries(
    dates.map((date) {
      final days = netIncomeByDate.entries.where((e) {
        // If we ever allow for more granular date ranges (e.g weeks),
        // this will likely need updating.
        return e.key.isSameMonthAs(date);
      });
      final avg = days.map((e) => e.value).sum ~/ days.length;
      return MapEntry(date, avg);
    }),
  );

  final averageNetIncome = datesToAvgNetIncome.values.sum ~/ datesToAvgNetIncome.length;

  return SmoothedIncomeChartData(
    dailyIncome: dailyIncome,
    totalIncome: totalIncome,
    averageNetIncome: averageNetIncome,
    datesToAvgNetIncome: datesToAvgNetIncome,
  );
}

class SmoothedIncomeChartData extends Equatable {
  const SmoothedIncomeChartData({
    required this.dailyIncome,
    required this.totalIncome,
    required this.averageNetIncome,
    required this.datesToAvgNetIncome,
  });
  final int dailyIncome;
  final int totalIncome;
  final int averageNetIncome;
  final Map<LocalDate, int> datesToAvgNetIncome;

  @override
  List<Object?> get props => [dailyIncome, totalIncome, averageNetIncome, datesToAvgNetIncome];
}
