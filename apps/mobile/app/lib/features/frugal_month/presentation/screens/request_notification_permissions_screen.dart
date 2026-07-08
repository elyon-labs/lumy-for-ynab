import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../app/di.dart';
import '../../../notifications/notifications.dart';

class RequestNotificationPermissionsScreen extends HookWidget {
  const RequestNotificationPermissionsScreen({
    super.key,
    required this.onChoice,
    this.title = 'Stay on top of things with notifications.',
    this.subtitle = 'Allow notifications so we can let you know when something important happens.',
  });

  final String title;
  final String subtitle;
  final ValueSetter<bool> onChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: HEdgePadding(
          child: VLayout(
            children: [
              Expanded(
                child: VLayout(
                  children: [
                    const VSpace(space: Sizes.unit * 2),
                    CircleAvatar(
                      radius: Sizes.unit * 4,
                      backgroundColor: context.colors.good,
                      child: Icon(
                        Ionicons.notifications_outline,
                        size: Sizes.unit * 4,
                        color: context.colors.onGood,
                      ),
                    ),
                    const VSpace(space: Sizes.unit * 2),
                    Text(title, style: context.text.headline),
                    Text(subtitle, style: context.text.body.copyWith(color: context.colors.muted)),
                  ],
                ),
              ),
              SafeArea(
                child: VLayout(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      onPressed: () async {
                        final granted = await $notifications().requestPermission();
                        onChoice.call(granted);
                      },
                      child: const Text('Notify me'),
                    ),
                    SecondaryButton(
                      onPressed: () => onChoice(false),
                      child: const Text('No thanks'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
