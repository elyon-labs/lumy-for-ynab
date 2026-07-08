import 'package:go_router/go_router.dart';

import '../../../../app/navigation/router.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_choose_spend_tracker_source_screen.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_choose_spend_tracker_type_screen.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_edit_spend_tracker_query_screen/reports_edit_spend_tracker_query_screen.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_spend_tracker_details_screen.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_spend_tracker_transactions_screen.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_spend_trackers_list_screen.dart';
import '../flows/create_spend_tracker/screens/name_spend_tracker_screen.dart';
import '../screens/rename_spend_tracker_screen/rename_spend_tracker_screen.dart';

// ignore: non_constant_identifier_names
List<RouteBase> SpendTrackersRoutes() {
  return [
    GoRoute(
      path: 'spend_trackers',
      builder: (context, state) => const ReportsSpendTrackerListScreen(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'create_spend_tracker',
      builder: (context, state) => const ReportsChooseSpendTrackerTypeScreen(),
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'source',
          builder: (context, state) => const ReportsChooseSpendTrackerSourceScreen(),
          routes: [
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: 'name',
              builder: (context, state) => const NameSpendTrackerScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: 'spend_tracker_details/:id',
      builder: (context, state) =>
          ReportsSpendTrackerDetailsScreen(spendTrackerId: state.pathParameters['id']!),
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'rename',
          builder: (context, state) =>
              RenameSpendTrackerScreen(spendTrackerId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: 'transactions',
          builder: (context, state) =>
              ReportsSpendTrackerTransactionsScreen(spendTrackerId: state.pathParameters['id']!),
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'edit_advanced_query',
          builder: (context, state) =>
              ReportsEditSpendTrackerQueryScreen(spendTrackerId: state.pathParameters['id']!),
        ),
      ],
    ),
  ];
}
