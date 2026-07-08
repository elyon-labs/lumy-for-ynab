import 'package:go_router/go_router.dart';
import '../screens/link_email_screen/link_email_screen.dart';
import '../screens/link_ynab_screen/link_ynab_screen.dart';
import '../screens/logout_screen/logout_screen.dart';
import '../screens/welcome_screen/welcome_screen.dart';

// ignore: non_constant_identifier_names
List<RouteBase> AuthRoutes() {
  return [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      routes: [
        GoRoute(
          path: 'link-email',
          builder: (context, state) {
            final isExistingUser = state.uri.queryParameters['isExistingUser'] == 'true';
            return LinkEmailScreen(isExistingUser: isExistingUser);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/link-email',
      builder: (context, state) {
        final isExistingUser = state.uri.queryParameters['isExistingUser'] == 'true';
        return LinkEmailScreen(isExistingUser: isExistingUser);
      },
    ),
    GoRoute(
      path: '/oauth',
      builder: (context, state) {
        return const LinkYnabScreen();
      },
    ),

    GoRoute(path: '/logout', builder: (context, state) => const LogoutScreen()),
  ];
}
