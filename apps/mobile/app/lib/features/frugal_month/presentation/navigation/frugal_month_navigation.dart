import 'package:flutter/material.dart' hide Flow;
import 'package:go_router/go_router.dart';

import '../../../../app/navigation/router.dart';
import '../../../../external/flow.dart';
import '../flows/create_frugal_month_flow.dart';
import '../screens/available_months_loading_screen.dart';
import '../screens/choose_frugal_month_accounts_screen.dart';
import '../screens/choose_frugal_month_categories_screen.dart';
import '../screens/choose_frugal_month_screen.dart';
import '../screens/frugal_month_details_screen.dart';
import '../screens/frugal_month_error_screen.dart';
import '../screens/frugal_month_settings_screen.dart';
import '../screens/frugal_month_splash_screen.dart';
import '../screens/request_frugal_month_notifications_screen.dart';
import '../screens/set_frugal_month_limit_screen.dart';
import '../screens/update_frugal_month_notifications_screen.dart';
import '../screens/view_frugal_month_accounts_screen.dart';
import '../screens/view_frugal_month_categories_screen.dart';

extension FrugalMonthsBuildContextX on BuildContext {
  void startCreateFrugalMonth() {
    go(AvailableMonthsLoadingScreen.route);
  }
}

// ignore: non_constant_identifier_names
List<RouteBase> FrugalMonthRoutes() {
  return [
    GoRoute(
      path: 'frugal_month_splash',
      pageBuilder: (context, state) {
        return const MaterialPage(fullscreenDialog: true, child: FrugalMonthSplashScreen());
      },
    ),
    ShellRoute(
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state, child) {
        return MaterialPage(
          fullscreenDialog: true,
          child: Flow(createManager: (_) => CreateFrugalMonthFlow.create(), child: child),
        );
      },
      routes: [
        GoRoute(
          path: 'available_months_loading',
          builder: (context, state) {
            return const AvailableMonthsLoadingScreen();
          },
        ),
        GoRoute(
          path: 'choose_frugal_month',
          builder: (context, state) {
            return const ChooseFrugalMonthScreen();
          },
          routes: [
            GoRoute(
              path: 'choose_categories',
              builder: (context, state) =>
                  const ChooseFrugalMonthCategoriesScreen(afterMonthChoice: true),
              routes: [
                GoRoute(
                  path: 'choose_accounts',
                  builder: (context, state) =>
                      const ChooseFrugalMonthAccountsScreen(afterMonthChoice: true),
                  routes: [
                    GoRoute(
                      path: 'set_target_amount',
                      builder: (context, state) =>
                          const SetFrugalMonthLimitScreen(afterMonthChoice: true),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'choose_categories',
          builder: (context, state) =>
              const ChooseFrugalMonthCategoriesScreen(afterMonthChoice: false),
          routes: [
            GoRoute(
              path: 'choose_accounts',
              builder: (context, state) =>
                  const ChooseFrugalMonthAccountsScreen(afterMonthChoice: false),
              routes: [
                GoRoute(
                  path: 'set_target_amount',
                  builder: (context, state) =>
                      const SetFrugalMonthLimitScreen(afterMonthChoice: false),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'frugal_month_error',
      builder: (context, state) {
        return const FrugalMonthErrorScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'frugal_month_notifications',
      builder: (context, state) {
        return const RequestFrugalMonthNotificationsScreen();
      },
    ),
    GoRoute(
      path: 'frugal_month/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FrugalMonthDetailsScreen(id: id);
      },
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'settings',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return FrugalMonthSettingsScreen(frugalMonthId: id);
          },
          routes: [
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: 'notifications',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return MaterialPage(
                  fullscreenDialog: true,
                  child: UpdateFrugalMonthNotificationsScreen(id: id),
                );
              },
            ),
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: 'categories',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return MaterialPage(
                  fullscreenDialog: true,
                  child: ViewFrugalMonthCategoriesScreen(id: id),
                );
              },
            ),
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: 'accounts',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return MaterialPage(
                  fullscreenDialog: true,
                  child: ViewFrugalMonthAccountsScreen(id: id),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
