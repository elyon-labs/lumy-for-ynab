import 'package:go_router/go_router.dart';

import '../../../../app/navigation/router.dart';
import '../../../auth/presentation/screens/change_email_screen/change_email_screen.dart';
import '../../../auth/presentation/screens/link_email_screen/link_email_screen.dart';
import '../screens/sync_screen/sync_screen.dart';
import '../screens/sync_status_screen/sync_status_screen.dart';

// ignore: non_constant_identifier_names
RouteBase SettingsTabSyncStatusRoute() {
  return GoRoute(
    parentNavigatorKey: rootNavigatorKey,
    path: 'sync-status',
    builder: (context, state) {
      final justLinked = state.uri.queryParameters['just-linked']?.toLowerCase() == 'true';
      final emailChangeConfirmed =
          state.uri.queryParameters['email-change-confirmed']?.toLowerCase() == 'true';
      return SyncStatusScreen(justLinked: justLinked, emailChangeConfirmed: emailChangeConfirmed);
    },
    routes: [
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: 'link-email',
        builder: (context, state) {
          return const LinkEmailScreen(isExistingUser: true);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: 'change-email',
        builder: (context, state) {
          return const ChangeEmailScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: 'sync',
        builder: (context, state) {
          return const SyncScreen();
        },
      ),
    ],
  );
}
