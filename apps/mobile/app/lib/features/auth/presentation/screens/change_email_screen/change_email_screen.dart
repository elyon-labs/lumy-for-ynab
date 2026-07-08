import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../utils/_build_context.dart';
import '../../../../home/presentation/screens/settings_tab/presentation/screens/settings_tab/settings_tab.dart';
import 'change_email_screen_cubit.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({super.key});

  static String buildSettingsRoute() {
    return '${SettingsTab.route}/sync-status/change-email';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeEmailScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Change email')),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChangeEmailScreenCubit>().state;
    final emailController = useTextEditingController();
    final emailUpdates = useListenable(emailController);

    final inputEmail = emailUpdates.text.trim();
    final currentEmail = state.currentEmail;
    final pendingEmail = state.pendingEmail;
    final normalizedInputEmail = inputEmail.toLowerCase();
    final normalizedCurrentEmail = currentEmail?.toLowerCase();
    final isCurrentEmail = normalizedInputEmail == normalizedCurrentEmail;
    final timeUntilResend = state.timeUntilEmailChangeResend;
    final isWaitingForResend = timeUntilResend > Duration.zero;
    final isSending = state.changeEmail is Loading;
    final canSubmit = inputEmail.isNotEmpty && !isCurrentEmail && !isWaitingForResend && !isSending;
    final error = state.changeEmail.error;

    final submitButtonText = isSending
        ? 'Sending...'
        : isWaitingForResend
        ? 'Resend in ${timeUntilResend.inSeconds} seconds'
        : 'Send confirmation emails';

    return HEdgePadding(
      child: VEdgePadding(
        child: SafeArea(
          child: VLayout(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: VLayout(
                    children: [
                      Text('Change email', style: context.text.headline),
                      Text(
                        'Confirm this change from both your current and new inbox.',
                        style: context.text.title.copyWith(color: context.colors.muted),
                      ),
                      const VSpace(space: Sizes.unit * 4),
                      if (currentEmail != null)
                        Text('Current email: $currentEmail', style: context.text.caption),
                      if (pendingEmail != null)
                        Text(
                          'Pending change: $pendingEmail',
                          style: context.text.caption.copyWith(color: context.colors.muted),
                        ),
                      const VSpace(space: Sizes.unit * 2),
                      OutlinedChild(
                        child: HEdgePadding(
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(hintText: 'New email address'),
                          ),
                        ),
                      ),
                      if (isCurrentEmail)
                        Text(
                          'Enter an email that is different from your current email.',
                          style: TextStyle(color: context.colors.muted),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
              const VSpace(space: Sizes.unit * 2),
              VLayout(
                spacing: Sizes.unit * 2,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (error.isNone() && timeUntilResend > Duration.zero)
                    Text(
                      'Confirmation emails sent. Confirm the change from both your current and new inbox.',
                      style: TextStyle(color: context.colors.muted),
                      textAlign: TextAlign.center,
                    ),
                  if (error.isSome())
                    Text(
                      error.unwrap().toString(),
                      style: TextStyle(color: context.colors.error),
                      textAlign: TextAlign.center,
                    ),
                  PrimaryButton(
                    onPressed: !canSubmit
                        ? null
                        : () async {
                            final result = await context.read<ChangeEmailScreenCubit>().submit(
                              inputEmail,
                            );
                            if (result.isOk() && context.mounted) {
                              context.showToast(const Text('Confirmation emails sent!'));
                            }
                          },
                    child: Text(submitButtonText),
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
