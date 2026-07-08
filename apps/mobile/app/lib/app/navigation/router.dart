import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/presentation/error/error_screen.dart';
import '../../features/auth/domain/use_cases/get_ynab_access_token.dart';
import '../../features/auth/domain/use_cases/is_user_logged_in.dart';
import '../../features/auth/domain/use_cases/watch_user.dart';
import '../../features/auth/presentation/navigation/auth_routes.dart';
import '../../features/auth/presentation/screens/link_email_screen/link_email_screen.dart';
import '../../features/auth/presentation/screens/link_ynab_screen/link_ynab_screen.dart';
import '../../features/auth/presentation/screens/logout_screen/logout_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen/welcome_screen.dart';
import '../../features/home/presentation/screens/budget_tab/presentation/navigation/budget_tab_navigation.dart';
import '../../features/home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import '../../features/home/presentation/screens/home_screen/home_screen.dart';
import '../../features/home/presentation/screens/reports_tab/presentation/navigation/reports_tab_navigation.dart';
import '../../features/home/presentation/screens/reports_tab/presentation/screens/reports_tab/reports_tab.dart';
import '../../features/home/presentation/screens/settings_tab/presentation/navigation/settings_tab_navigation.dart';
import '../../features/home/presentation/screens/settings_tab/presentation/screens/settings_tab/settings_tab.dart';
import '../../persistence/settings.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();
final GlobalKey<NavigatorState> budgetNavigationKey = GlobalKey();
final GlobalKey<NavigatorState> reportsNavigationKey = GlobalKey();
final GlobalKey<NavigatorState> goalsNavigationKey = GlobalKey();
final GlobalKey<NavigatorState> settingsNavigationKey = GlobalKey();

GoRouter $router() => GoRouter.of(rootNavigatorKey.currentContext!);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter({
  required WatchUser watchUser,
  required GetYnabAccessToken getYnabAccessToken,
  required IsUserLoggedIn isUserLoggedIn,
  required Settings settings,
  String? initialLocation,
}) {
  return GoRouter(
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error ?? Exception('Experienced an unknown routing error'));
    },
    refreshListenable: GoRouterRefreshStream(watchUser()),
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      ...AuthRoutes(),
      GoRoute(path: '/', redirect: (_, __) => BudgetTab.route),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          return HomeScreen(shell: shell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: budgetNavigationKey,
            routes: [
              GoRoute(
                path: BudgetTab.route,
                builder: (context, state) => const BudgetTab(),
                routes: BudgetTabRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: reportsNavigationKey,
            routes: [
              GoRoute(
                path: ReportsTab.route,
                builder: (context, state) => const ReportsTab(),
                routes: ReportsTabRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: settingsNavigationKey,
            routes: [
              GoRoute(
                path: SettingsTab.route,
                builder: (context, state) => const SettingsTab(),
                routes: SettingsTabRoutes(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      bool isGoingToForbiddenRoute() {
        final isAuthenticatedRoute = [
          BudgetTab.route,
          ReportsTab.route,
          SettingsTab.route,
        ].any((s) => state.matchedLocation.startsWith(s));
        final isOtherForbiddenRoute = [
          // This route is not authenticated, but lives outside of the authenticated
          // routes to prevent bypass. Users who are not authenticated in some way
          // should not be able to access it.
          Uri.parse(LinkEmailScreen.buildMigrationRoute()).path,
        ].any((s) => state.matchedLocation.startsWith(s));

        return isAuthenticatedRoute || isOtherForbiddenRoute;
      }

      bool isOnLoginRoute() {
        return [
          WelcomeScreen.route,
          Uri.parse(LinkEmailScreen.buildMigrationRoute()).path,
        ].any((s) => state.matchedLocation.startsWith(s));
      }

      bool isOnOauthRoute() {
        return [LinkYnabScreen.buildRoute()].any((s) => state.matchedLocation.startsWith(s));
      }

      final isLoggedIn = await isUserLoggedIn();
      final isOnLogoutScreen = state.matchedLocation == LogoutScreen.route;
      final hasJustLoggedIn = isLoggedIn && isOnLoginRoute();
      final hasYnabAccessToken = (await getYnabAccessToken()).isSome();
      final hasJustLinkedYnab = isLoggedIn && hasYnabAccessToken && isOnOauthRoute();

      if (!isLoggedIn) {
        if (isOnLogoutScreen) {
          return WelcomeScreen.route;
        }

        if (hasYnabAccessToken) {
          // Existing users who have not migrated to the new auth model
          return LinkEmailScreen.buildMigrationRoute();
        }

        if (isGoingToForbiddenRoute()) {
          return WelcomeScreen.route;
        }

        // Navigating within unauthenticated routes, don't redirect.
        return null;
      } else {
        if (!hasYnabAccessToken) {
          return LinkYnabScreen.buildRoute();
        }
      }

      if (hasJustLoggedIn || hasJustLinkedYnab) {
        return BudgetTab.route;
      }

      return null;
    },
  );
}
