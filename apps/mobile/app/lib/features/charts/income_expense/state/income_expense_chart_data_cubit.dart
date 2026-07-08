import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/calculations/income_expense/fn.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/payees/payees_repository.dart';
import '../../../../common/domain/payees/payees_view.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/worker.dart';
import '../../../../features/date_range/domain/models/date_range.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../income_expense_chart.dart';

class IncomeExpenseChartDataCubit extends Cubit<Async<IncomeExpenseChartData>> {
  IncomeExpenseChartDataCubit({
    required this.settings,
    required this.transactionsRepo,
    required this.categoriesRepo,
    required this.payeesRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory IncomeExpenseChartDataCubit.create() {
    return IncomeExpenseChartDataCubit(
      settings: inject(),
      transactionsRepo: inject(),
      categoriesRepo: inject(),
      payeesRepo: inject(),
      worker: inject(),
    );
  }

  final Settings settings;
  final TransactionsRepository transactionsRepo;
  final CategoriesRepository categoriesRepo;
  final PayeesRepository payeesRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = IncomeExpenseChart();
    final setting = settings.watchChartAccounts(chart);
    final selectedDateRange = settings.watchSelectedDateRange();
    final categoryView = settings.watchReportsTabCategoryView();

    final sub = Rx.combineLatest3(setting, selectedDateRange, categoryView, (a, b, c) => (a, b, c))
        .switchMap((value) async* {
          final (chartAccounts, selectedDateRange, categoryView) = value;
          final accounts = chartAccounts.mapOr(
            AccountsWithIds.new,
            AccountsInFilter(chart.accountFilter),
          );
          final categories = categoryView.mapOr(CategoriesInView.new, const AllCategories());
          final transactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: const SelectedDateRange(),
              accounts: accounts,
              categories: const AllCategories(),
              filter: const NoFilter(),
              debugId: 'reports.income_expense.transactions',
            ),
          );
          yield* Rx.combineLatest3(
            transactions,
            payeesRepo.watch(const AllPayees()),
            categoriesRepo.watchCategories(categories),
            (a, b, c) => (a, b, c, selectedDateRange),
          );
        })
        .switchMap((event) async* {
          final (transactions, payees, categories, dateRange) = event;
          final incomeExpense = await calculateIncomeExpenseInWorker(
            worker: worker,
            categories: categories,
            payees: payees,
            transactions: transactions,
            dateRange: dateRange,
          );
          yield Loaded(IncomeExpenseChartData.fromRaw(incomeExpense));
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

Future<IncomeExpenseData> calculateIncomeExpenseInWorker({
  required Worker worker,
  required List<Category> categories,
  required List<Payee> payees,
  required List<PastTransaction> transactions,
  required DateRange dateRange,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateIncomeExpenseSync(
      categories: categories,
      payees: payees,
      transactions: transactions,
      dateRange: dateRange,
    ),
  );
}

class IncomeExpenseChartData extends Equatable {
  const IncomeExpenseChartData({
    required this.average,
    required this.datesToExpense,
    required this.datesToIncome,
    required this.datesToNet,
  });

  factory IncomeExpenseChartData.fromRaw(IncomeExpenseData data) {
    final months = data.monthData..sortBy((element) => element.month);
    final datesToExpenses = Map.fromEntries(
      months.map((month) {
        return MapEntry(month.month, month.summary.expense);
      }),
    );
    final datesToIncome = Map.fromEntries(
      months.map((month) {
        return MapEntry(month.month, month.summary.income);
      }),
    );
    final datesToNet = Map.fromEntries(
      months.map((month) {
        return MapEntry(month.month, month.summary.net);
      }),
    );
    final averageExpense = datesToExpenses.values.average.toInt();
    final averageIncome = datesToIncome.values.average.toInt();
    return IncomeExpenseChartData(
      average: (averageExpense: averageExpense, averageIncome: averageIncome),
      datesToExpense: datesToExpenses,
      datesToIncome: datesToIncome,
      datesToNet: datesToNet,
    );
  }

  final ({int averageExpense, int averageIncome}) average;
  final Map<LocalDate, int> datesToExpense;
  final Map<LocalDate, int> datesToIncome;
  final Map<LocalDate, int> datesToNet;

  @override
  List<Object?> get props => [average, datesToExpense, datesToIncome];
}
