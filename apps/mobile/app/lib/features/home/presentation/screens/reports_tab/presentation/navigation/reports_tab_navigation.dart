import 'package:go_router/go_router.dart';

import '../../../../../../charts/navigation/chart_details_route.dart';
import '../../../../../../income_expense/navigation/income_expense_navigation.dart';
import '../../../../../../month_in_review/navigation/month_in_review_navigation.dart';
import '../../../../../../recurring_transactions/navigation/recurring_transactions_navigation.dart';
import '../../../../../../spend_tracker/presentation/navigation/spend_trackers_navigation.dart';
import 'reports_create_category_view_route.dart';

// ignore: non_constant_identifier_names
List<RouteBase> ReportsTabRoutes() {
  return [
    ReportsCreateCategoryViewRoute(),
    ChartDetailsRoute(),
    RecurringTransactionsRoute(),
    ...MonthInReviewRoutes(),
    ...SpendTrackersRoutes(),
    ...IncomeExpenseRoutes(),
  ];
}
