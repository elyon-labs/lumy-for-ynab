import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';

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

Future<void> updateMetricsWidgetInBackground({required ElyonColors palette}) async {
  final settings = inject<Settings>();
  final budgetsRepo = inject<BudgetsRepository>();
  final watchCurrentFrugalMonth = WatchCurrentFrugalMonth.create();
  final monthsRepo = inject<MonthsRepository>();
  final categoriesRepo = inject<CategoriesRepository>();
  final transactionsRepo = inject<TransactionsRepository>();
  final worker = inject<Worker>();

  final budgetTabCategoryView = await settings.watchBudgetTabCategoryView().nextValue();
  final categoryView = budgetTabCategoryView.mapOr(CategoriesInView.new, const ExpenseCategories());

  await updateMetricWidget(
    worker: worker,
    selectedBudgetId: await settings.watchSelectedBudgetId().nextValue(),
    currencyFormat: await budgetsRepo.watchCurrencyFormat().nextValue(),
    useFrugalMonthLeftToSpend: await settings.watchUseFrugalMonthLeftToSpend().nextValue(),
    currentFrugalMonth: await watchCurrentFrugalMonth().nextValue(),
    allMonths: await monthsRepo.watchAllMonths().nextValue(),
    categoriesInView: await categoriesRepo.watchCategories(categoryView).nextValue(),
    currentMonthExpenseTransactions: await transactionsRepo
        .watch(
          TransactionsView(
            dateRange: SpecificDateRange((from: thisMonth.firstDayOfMonth(), to: today)),
            accounts: const OnBudgetAccounts(),
            categories: categoryView,
            filter: const ExpenseFilter(),
          ),
        )
        .first,
    lastMonthExpenseTransactions: await transactionsRepo
        .watch(
          TransactionsView(
            dateRange: SpecificDateRange((
              from: lastMonth.firstDayOfMonth(),
              to: lastMonth.lastDayOfMonth(),
            )),
            accounts: const OnBudgetAccounts(),
            categories: categoryView,
            filter: const ExpenseFilter(),
          ),
        )
        .first,
  );
}
