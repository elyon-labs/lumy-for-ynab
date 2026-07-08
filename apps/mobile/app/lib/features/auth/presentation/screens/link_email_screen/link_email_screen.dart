import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../common/presentation/modals/confirmation_dialog.dart';
import '../../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../../utils/_build_context.dart';
import '../../../../home/presentation/screens/settings_tab/presentation/screens/settings_tab/settings_tab.dart';
import 'link_email_screen_cubit.dart';
import 'link_email_screen_state.dart';

class LinkEmailScreen extends StatelessWidget {
  const LinkEmailScreen({super.key, required this.isExistingUser});

  static String buildWelcomeRoute({required bool isExistingUser}) {
    return '/welcome/link-email?isExistingUser=$isExistingUser';
  }

  static String buildMigrationRoute() {
    return '/link-email?isExistingUser=false';
  }

  static String buildSettingsRoute() {
    return '${SettingsTab.route}/sync-status/link-email?isExistingUser=true';
  }

  final bool isExistingUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinkEmailScreenCubit.create(isExistingUser: isExistingUser),
      child: BlocBuilder<LinkEmailScreenCubit, LinkEmailScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: _Body(isExistingUser: isExistingUser),
          );
        },
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body({required this.isExistingUser});

  final bool isExistingUser;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LinkEmailScreenCubit>().state;

    final emailController = useTextEditingController();
    final emailUpdates = useListenable(emailController);
    final isUserLoggedIn = state.isUserLoggedIn;
    final isUserAnonymous = state.isUserAnonymous;
    final timeUntilMagicLinkResend = state.timeUntilMagicLinkResend;
    final isWaitingForResend = timeUntilMagicLinkResend > Duration.zero;
    final isSending = state.login is Loading;

    final hasInputEmail = emailUpdates.text.isNotEmpty;
    final canSubmit = !isWaitingForResend && hasInputEmail && !isSending;

    final submitButtonText = isSending
        ? 'Sending...'
        : isWaitingForResend
        ? 'Resend in ${timeUntilMagicLinkResend.inSeconds} seconds'
        : 'Send magic link';

    final isLinkingEmailToAnonymousAccount = isUserLoggedIn && isUserAnonymous && isExistingUser;
    final isSigningUp = !isUserLoggedIn && !isExistingUser && !isUserAnonymous;
    final isLoggingIn = isExistingUser && !isUserLoggedIn && !isUserAnonymous;

    final showGuestLogin = !hasInputEmail && isSigningUp;

    final headlineText = isLoggingIn && !isLinkingEmailToAnonymousAccount
        ? 'Welcome back!'
        : 'Link your email';

    final titleText = isLoggingIn && !isLinkingEmailToAnonymousAccount
        ? 'Enter the email address you used when setting up your account.'
        : 'Use this email address across devices to sync your Lumy data. None of the financial data fetched from YNAB leaves your device.';

    final error = state.login.error;

    return HEdgePadding(
      child: VEdgePadding(
        child: SafeArea(
          child: VLayout(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: VLayout(
                    children: [
                      Text(headlineText, style: context.text.headline),
                      Text(
                        titleText,
                        style: context.text.title.copyWith(color: context.colors.muted),
                      ),
                      const VSpace(space: Sizes.unit * 4),
                      OutlinedChild(
                        child: HEdgePadding(
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(hintText: 'Email address'),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final continueAsGuest = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return const _GuestUserConfirmationDialog();
                              },
                            );
                            if (true == continueAsGuest && context.mounted) {
                              await context.read<LinkEmailScreenCubit>().logInAnonymously();
                            }
                          },
                          child: Text('Continue as guest', style: context.text.caption),
                        ),
                      ).visible(showGuestLogin),
                    ],
                  ),
                ),
              ),
              const VSpace(space: Sizes.unit * 2),
              VLayout(
                spacing: Sizes.unit * 2,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (error.isNone() && timeUntilMagicLinkResend > Duration.zero)
                    Text(
                      'Check your email for a magic link to log in.',
                      style: TextStyle(color: context.colors.muted),
                      textAlign: TextAlign.center,
                    ),
                  if (error.isSome())
                    Text(
                      error.unwrap().toString(),
                      style: TextStyle(color: context.colors.error),
                      textAlign: TextAlign.center,
                    ),
                  VLayout(
                    spacing: 0,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PrimaryButton(
                        onPressed: !canSubmit
                            ? null
                            : () async {
                                late Result<void, Exception> result;
                                if (isLinkingEmailToAnonymousAccount) {
                                  result = await context.read<LinkEmailScreenCubit>().linkEmail(
                                    emailController.text,
                                  );
                                } else {
                                  result = await context
                                      .read<LinkEmailScreenCubit>()
                                      .logInWithEmail(emailController.text);
                                }
                                if (result.isOk() && context.mounted) {
                                  context.showToast(const Text('Magic link sent!'));
                                }
                              },
                        child: Text(submitButtonText),
                      ),
                      if (kDebugMode)
                        TextButton(
                          onPressed: () async {
                            await context.read<LinkEmailScreenCubit>().logInWithEmailAndPassword(
                              email: '',
                              password: 'TempP@ssw0rd!',
                            );
                          },
                          child: const Text('Log in with email & password'),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestUserConfirmationDialog extends StatelessWidget {
  const _GuestUserConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: const Text('Continue as Guest?'),
      body: const Text(
        'If you continue as a guest, your data could be lost if you uninstall the app or log out. You can always link an email later.',
      ),
      confirmButton: DialogActionButton(isDestructive: true, text: 'Continue as Guest'),
      cancelButton: DialogActionButton(text: 'Go back'),
    );
  }
}
