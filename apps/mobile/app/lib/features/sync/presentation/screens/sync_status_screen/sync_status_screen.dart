import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../utils/_build_context.dart';
import '../../../../auth/domain/models/user.dart';
import '../../../../auth/presentation/screens/change_email_screen/change_email_screen.dart';
import '../../../../auth/presentation/screens/link_email_screen/link_email_screen.dart';
import '../../../../home/presentation/screens/settings_tab/presentation/screens/settings_tab/settings_tab.dart';
import '../sync_screen/sync_screen.dart';
import 'sync_status_screen_cubit.dart';

class SyncStatusScreen extends StatelessWidget {
  const SyncStatusScreen({super.key, required this.justLinked, required this.emailChangeConfirmed});

  static const route = '${SettingsTab.route}/sync-status';

  static String buildLinkEmailRoute() {
    return '$route?just-linked=true';
  }

  final bool justLinked;
  final bool emailChangeConfirmed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SyncStatusScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Backup')),
        body: _AccountToast(
          justLinked: justLinked,
          emailChangeConfirmed: emailChangeConfirmed,
          child: const _Body(),
        ),
      ),
    );
  }
}

class _AccountToast extends HookWidget {
  const _AccountToast({
    required this.justLinked,
    required this.emailChangeConfirmed,
    required this.child,
  });

  final bool justLinked;
  final bool emailChangeConfirmed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SyncStatusScreenCubit>().state;
    final isEmailChangeComplete = state.user.value.when(
      some: (user) {
        return user is AuthenticatedUser && !user.isAnonymous && user.pendingEmail == null;
      },
      none: () => false,
    );

    useEffect(() {
      if (justLinked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.showToast(const Text('Email linked successfully!'), duration: 3.seconds);
        });
      } else if (emailChangeConfirmed && isEmailChangeComplete) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.showToast(const Text('Email changed successfully!'), duration: 3.seconds);
        });
      }
      return null;
    }, [justLinked, emailChangeConfirmed, isEmailChangeComplete]);

    return child;
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SyncStatusScreenCubit>().state;
    final user = state.user;
    final hasUnsyncedData = state.hasUnsyncedData;
    return SingleChildScrollView(
      child: VLayout(
        spacing: Sizes.unit * 2,
        children: [
          const VSpace(space: Sizes.edgePadding),
          if (hasUnsyncedData)
            HEdgePadding(
              child: OutlinedChild(
                child: ListRow(
                  implicitTrailing: false,
                  leading: Icon(Icons.warning, color: context.colors.warning),
                  title: const Text('You have unsynced data'),
                  subtitle: const Text('Tap to sync your data now.'),
                  onTap: () {
                    GoRouter.of(context).go(SyncScreen.route);
                  },
                ),
              ),
            ),
          VLayout(
            children: [
              const HEdgePadding(child: SectionHeader('Account')),
              _UserRow(user: user),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user});

  final Async<User> user;

  @override
  Widget build(BuildContext context) {
    final maybeUser = user.value;
    return maybeUser.when(
      some: (user) {
        if (user is AuthenticatedUser) {
          if (user.isAnonymous) {
            return ListRow(
              title: const Text('Logged in anonymously'),
              subtitle: const Text(
                'Logging out will result in data loss. Tap to link an email address.',
              ),
              onTap: () async {
                GoRouter.of(context).go(LinkEmailScreen.buildSettingsRoute());
              },
            );
          }

          return ListRow(
            title: Text(user.email ?? 'No email'),
            subtitle: Text(
              user.pendingEmail == null
                  ? 'Tap to change the email used for login'
                  : 'Pending change to ${user.pendingEmail}. Confirm both inboxes to finish.',
            ),
            onTap: () {
              GoRouter.of(context).go(ChangeEmailScreen.buildSettingsRoute());
            },
          );
        }

        return const SizedBox.shrink();
      },
      none: () => const ListRow(title: Text('No user found')),
    );
  }
}
