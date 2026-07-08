import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/budgets/budgets_repository.dart';
import '../../../common/domain/categories/categories_repository.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/months/months_repository.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/domain/worker/worker.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_local_date.dart';
import '../../frugal_month/domain/use_cases/watch_current_frugal_month.dart';
import 'update_metrics_widget.dart';

class UpdateMetricsWidgetsCubit extends Cubit<Async> {
  UpdateMetricsWidgetsCubit({
    required bool isEnabled,
    required BudgetsRepository budgetsRepository,
    required WatchCurrentFrugalMonth watchCurrentFrugalMonth,
    required MonthsRepository monthsRepository,
    required CategoriesRepository categoriesRepository,
    required TransactionsRepository transactionsRepository,
    required Settings settings,
    required Worker worker,
  }) : _settings = settings,
       _categoriesRepository = categoriesRepository,
       _transactionsRepository = transactionsRepository,
       _monthsRepository = monthsRepository,
       _watchCurrentFrugalMonth = watchCurrentFrugalMonth,
       _budgetsRepository = budgetsRepository,
       _worker = worker,
       _isEnabled = isEnabled,
       super(const Loading()) {
    if (_isEnabled) unawaited(work());
  }

  factory UpdateMetricsWidgetsCubit.create({required bool isEnabled}) {
    return UpdateMetricsWidgetsCubit(
      isEnabled: isEnabled,
      budgetsRepository: inject(),
      watchCurrentFrugalMonth: WatchCurrentFrugalMonth.create(),
      monthsRepository: inject(),
      categoriesRepository: inject(),
      transactionsRepository: inject(),
      settings: inject(),
      worker: inject(),
    );
  }

  final bool _isEnabled;
  final BudgetsRepository _budgetsRepository;
  final WatchCurrentFrugalMonth _watchCurrentFrugalMonth;
  final MonthsRepository _monthsRepository;
  final CategoriesRepository _categoriesRepository;
  final TransactionsRepository _transactionsRepository;
  final Worker _worker;
  final Settings _settings;
  final _subs = CompositeSubscription();

  Future<void> work() async {
    final sub =
        Rx.combineLatest6(
              _settings.watchSelectedBudgetId(),
              _budgetsRepository.watchCurrencyFormat(),
              _settings.watchUseFrugalMonthLeftToSpend(),
              _watchCurrentFrugalMonth(),
              _monthsRepository.watchAllMonths(),
              _settings.watchBudgetTabCategoryView(),
              (
                selectedBudgetId,
                currencyFormat,
                useFrugalMonthLeftToSpend,
                currentFrugalMonth,
                allMonths,
                budgetTabCategoryView,
              ) => (
                selectedBudgetId,
                currencyFormat,
                useFrugalMonthLeftToSpend,
                currentFrugalMonth,
                allMonths,
                budgetTabCategoryView,
              ),
            )
            .switchMap((event) async* {
              final (
                selectedBudgetId,
                currencyFormat,
                useFrugalMonthLeftToSpend,
                currentFrugalMonth,
                allMonths,
                budgetTabCategoryView,
              ) = event;

              final categoryView = budgetTabCategoryView.mapOr(
                CategoriesInView.new,
                const ExpenseCategories(),
              );

              final currentMonthExpenseTransactions = _transactionsRepository.watch(
                TransactionsView(
                  dateRange: SpecificDateRange((from: thisMonth.firstDayOfMonth(), to: today)),
                  accounts: const OnBudgetAccounts(),
                  categories: categoryView,
                  filter: const ExpenseFilter(),
                ),
              );

              final lastMonthExpenseTransactions = _transactionsRepository.watch(
                TransactionsView(
                  dateRange: SpecificDateRange((
                    from: lastMonth.firstDayOfMonth(),
                    to: lastMonth.lastDayOfMonth(),
                  )),
                  accounts: const OnBudgetAccounts(),
                  categories: categoryView,
                  filter: const ExpenseFilter(),
                ),
              );

              final categories = _categoriesRepository.watchCategories(categoryView);

              yield* Rx.combineLatest3(
                categories,
                currentMonthExpenseTransactions,
                lastMonthExpenseTransactions,
                (categories, currentMonthExpenseTransactions, lastMonthExpenseTransactions) {
                  return (
                    categories,
                    currentMonthExpenseTransactions,
                    lastMonthExpenseTransactions,
                    selectedBudgetId,
                    currencyFormat,
                    useFrugalMonthLeftToSpend,
                    currentFrugalMonth,
                    allMonths,
                  );
                },
              );
            })
            .listen((event) async {
              final (
                categories,
                currentMonthExpenseTransactions,
                lastMonthExpenseTransactions,
                selectedBudgetId,
                currencyFormat,
                useFrugalMonthLeftToSpend,
                currentFrugalMonth,
                allMonths,
              ) = event;
              await updateMetricWidget(
                worker: _worker,
                selectedBudgetId: selectedBudgetId,
                currencyFormat: currencyFormat,
                useFrugalMonthLeftToSpend: useFrugalMonthLeftToSpend,
                currentFrugalMonth: currentFrugalMonth,
                allMonths: allMonths,
                categoriesInView: categories,
                currentMonthExpenseTransactions: currentMonthExpenseTransactions,
                lastMonthExpenseTransactions: lastMonthExpenseTransactions,
              );
            });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
