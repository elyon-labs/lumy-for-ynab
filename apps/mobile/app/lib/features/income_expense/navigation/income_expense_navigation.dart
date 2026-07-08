import 'package:go_router/go_router.dart';
import 'package:time_machine/time_machine.dart';

import '../../../app/navigation/router.dart';
import '../../../utils/_local_date.dart';
import '../category_view.dart/income_expense_create_category_view.dart';
import '../screens/choose_income_expense_accounts_screen.dart';
import '../screens/choose_income_expense_categories_screen.dart';
import '../screens/expense_transactions_for_category_screen.dart';
import '../screens/expense_transactions_screen.dart';
import '../screens/income_expense_screen.dart';
import '../screens/income_transactions_for_payee_screen.dart';
import '../screens/income_transactions_screen.dart';

// ignore: non_constant_identifier_names
List<RouteBase> IncomeExpenseRoutes() {
  return [
    GoRoute(
      path: 'income_expense',
      builder: (context, state) => const IncomeExpenseScreen(),
      routes: [
        GoRoute(
          path: 'categories',
          builder: (context, state) {
            return const ChooseIncomeExpenseCategoriesScreen();
          },
          routes: [
            GoRoute(
              path: 'create_category_view',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                return const IncomeExpenseCreateCategoryView();
              },
              routes: [
                GoRoute(
                  path: 'name',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    return const IncomeExpenseNameNewCategoryViewScreen();
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'accounts',
          builder: (context, state) {
            return const ChooseIncomeExpenseAccountsScreen();
          },
        ),
        GoRoute(
          path: 'income_transactions/:month',
          builder: (context, state) {
            final month = state.pathParameters['month']!;
            final date = yearMonthFormatter.parse(month);
            return IncomeTransactionsScreen(month: LocalDate.dateTime(date));
          },
          routes: [
            GoRoute(
              path: 'payee/:payeeId',
              builder: (context, state) {
                final payeeId = state.pathParameters['payeeId']!;
                final month = state.pathParameters['month']!;
                final date = yearMonthFormatter.parse(month);
                return IncomeTransactionsForPayeeScreen(
                  month: LocalDate.dateTime(date),
                  payeeId: payeeId,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'expense_transactions/:month',
          builder: (context, state) {
            final month = state.pathParameters['month']!;
            final date = yearMonthFormatter.parse(month);
            return ExpenseTransactionsScreen(month: LocalDate.dateTime(date));
          },
          routes: [
            GoRoute(
              path: 'category/:categoryId',
              builder: (context, state) {
                final payeeId = state.pathParameters['categoryId']!;
                final month = state.pathParameters['month']!;
                final date = yearMonthFormatter.parse(month);
                return ExpenseTransactionsForCategoryScreen(
                  month: LocalDate.dateTime(date),
                  categoryId: payeeId,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
