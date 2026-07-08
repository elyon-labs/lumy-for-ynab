import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/calculations/income_expense/fn.dart';
import '../../../common/domain/categories/categories_repository.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/payees/payees_repository.dart';
import '../../../common/domain/payees/payees_view.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';

class IncomeExpenseReportCubit extends Cubit<Async<IncomeExpenseData>> {
  IncomeExpenseReportCubit({
    required this.settings,
    required this.categoriesRepo,
    required this.payeesRepo,
    required this.transactionsRepo,
  }) : super(const Loading()) {
    fetch();
  }

  factory IncomeExpenseReportCubit.create() {
    return IncomeExpenseReportCubit(
      settings: inject(),
      categoriesRepo: inject(),
      payeesRepo: inject(),
      transactionsRepo: inject(),
    );
  }

  final Settings settings;
  final CategoriesRepository categoriesRepo;
  final PayeesRepository payeesRepo;
  final TransactionsRepository transactionsRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final selectedDateRange = settings.watchSelectedDateRange();
    final categoryViewSetting = settings.watchIncomeExpenseCategoryView();
    final accountsSetting = settings.watchIncomeExpenseAccounts();
    final sub =
        Rx.combineLatest3(
              selectedDateRange,
              categoryViewSetting,
              accountsSetting,
              (a, b, c) => (a, b, c),
            )
            .switchMap((value) async* {
              final (selectedDateRange, categoryView, accountsView) = value;
              final accounts = accountsView.mapOr(AccountsWithIds.new, const OnBudgetAccounts());
              final categories = categoryView.mapOr(CategoriesInView.new, const AllCategories());
              final transactions = transactionsRepo.watch(
                TransactionsView(
                  dateRange: SpecificDateRange(selectedDateRange),
                  accounts: accounts,
                  categories: const AllCategories(),
                  filter: const NoFilter(),
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
              final incomeExpense = await calculateIncomeExpense(
                categories: categories,
                payees: payees,
                transactions: transactions,
                dateRange: dateRange,
              );
              yield Loaded(incomeExpense);
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
