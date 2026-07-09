import 'package:go_router/go_router.dart';

import '../../../../../../../app/navigation/router.dart';
import '../../../../../../../external/flow.dart';
import '../../../../../../about/presentation/screens/about_app_screen/about_app_screen.dart';
import '../../../../../../sync/presentation/navigation/sync_navigation.dart';
import '../../../../../../whats_new/screens/whats_new_screen.dart';
import '../flows/settings_create_category_view/screens/settings_choose_categories_for_view_screen.dart';
import '../flows/settings_create_category_view/screens/settings_name_new_category_view_screen.dart';
import '../flows/settings_create_category_view/settings_create_category_view_flow.dart';
import '../flows/settings_edit_category_view/screens/settings_edit_category_view_categories_screen.dart';
import '../flows/settings_edit_category_view/screens/settings_edit_category_view_name_screen.dart';
import '../screens/category_view_details_screen/category_view_details_screen.dart';
import '../screens/category_view_list_screen/category_views_list_screen.dart';
import '../screens/debug_screen.dart';
import '../screens/feature_flags_screen.dart';
import '../screens/spend_tracker_ordering_screen/spend_tracker_ordering_screen.dart';
import 'settings_chart_settings_route.dart';
import 'settings_frugal_month_details_route.dart';

// ignore: non_constant_identifier_names
List<RouteBase> SettingsTabRoutes() {
  return [
    SettingsChartSettingsRoute(),
    SettingsTabPastFrugalMonthsRoute(),
    SettingsTabSyncStatusRoute(),
    GoRoute(
      path: 'spend_tracker_ordering',
      builder: (context, state) => const SpendTrackerOrderingScreen(),
    ),
    GoRoute(path: 'whats_new', builder: (context, state) => const WhatsNewScreen()),
    GoRoute(path: 'debug', builder: (context, state) => const DebugScreen()),
    GoRoute(path: 'feature_flags', builder: (context, state) => const FeatureFlagsScreen()),
    GoRoute(path: 'about', builder: (context, state) => const AboutAppScreen()),
    GoRoute(
      path: 'category_views',
      builder: (context, state) => const CategoryViewsListScreen(),
      routes: [
        ShellRoute(
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state, child) {
            return Flow(
              createManager: (_) => SettingsCreateCategoryViewFlow.create(),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const SettingsChooseCategoriesForViewScreen(),
              routes: [
                GoRoute(
                  path: 'name',
                  builder: (context, state) => const SettingsNameNewCategoryViewScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              CategoryViewDetailsScreen(viewId: state.pathParameters['id']!),
          routes: [
            GoRoute(
              path: 'edit',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) =>
                  SettingsEditCategoryViewCategoriesScreen(viewId: state.pathParameters['id']!),
              routes: [
                GoRoute(
                  path: 'name',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) =>
                      SettingsEditCategoryViewNameScreen(viewId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
