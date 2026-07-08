import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_repository.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/calculations/days_buffer/fn.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/worker.dart';
import '../../../../features/date_range/domain/models/date_range.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../days_buffer_chart.dart';

class DaysBufferChartDataCubit extends Cubit<Async<DaysBufferResult>> {
  DaysBufferChartDataCubit({
    required this.settings,
    required this.accountsRepo,
    required this.categoriesRepo,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory DaysBufferChartDataCubit.create() {
    return DaysBufferChartDataCubit(
      settings: inject(),
      accountsRepo: inject(),
      categoriesRepo: inject(),
      transactionsRepo: inject(),
      worker: inject(),
    );
  }

  final Settings settings;
  final AccountsRepository accountsRepo;
  final CategoriesRepository categoriesRepo;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = DaysBufferChart();
    final selectedDateRange = settings.watchSelectedDateRange();
    final accounts = settings.watchChartAccounts(chart);

    final sub = Rx.combineLatest2(selectedDateRange, accounts, (a, b) => (a, b))
        .switchMap((event) async* {
          final (selectedDateRange, accounts) = event;
          const categories = ExpensesInSelectedView();
          final accountsView = accounts.mapOr(
            AccountsWithIds.new,
            AccountsInFilter(chart.accountFilter),
          );
          final allTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange(selectedDateRange),
              accounts: const OnBudgetAccounts(),
              categories: const AllCategories(),
              filter: const NoFilter(),
              debugId: 'reports.days_buffer.all_transactions',
            ),
          );
          final expenseTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange(selectedDateRange),
              accounts: const OnBudgetAccounts(),
              categories: categories,
              filter: const ExpenseFilter(),
              debugId: 'reports.days_buffer.expense_transactions',
            ),
          );
          yield* Rx.combineLatest4(
            allTransactions,
            expenseTransactions,
            accountsRepo.watch(accountsView),
            categoriesRepo.watchCategories(categories),
            (a, b, c, d) => (a, b, c, d, selectedDateRange),
          );
        })
        .switchMap((event) async* {
          final (allTransactions, expenseTransactions, accounts, categories, selectedDateRange) =
              event;
          final value = await calculateDaysBufferInWorker(
            worker: worker,
            allTransactionsInDateRange: allTransactions,
            expenseTransactionsInDateRange: expenseTransactions,
            accounts: accounts,
            categories: categories,
            dateRange: selectedDateRange,
          );
          yield Loaded(value);
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

Future<DaysBufferResult> calculateDaysBufferInWorker({
  required Worker worker,
  required Iterable<PastTransaction> allTransactionsInDateRange,
  required Iterable<PastTransaction> expenseTransactionsInDateRange,
  required Iterable<Account> accounts,
  required Iterable<Category> categories,
  required DateRange dateRange,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateDaysBufferSync(
      allTransactionsInDateRange: allTransactionsInDateRange,
      expenseTransactionsInDateRange: expenseTransactionsInDateRange,
      accounts: accounts,
      categories: categories,
      dateRange: dateRange,
    ),
  );
}
