import 'package:flutter/widgets.dart';

import '../../../../app/di.dart';
import '../../../notifications/notifications.dart';
import '../notifications/frugal_month_notifications.dart';
import 'request_notification_permissions_screen.dart';

class UpdateFrugalMonthNotificationsScreen extends StatelessWidget {
  UpdateFrugalMonthNotificationsScreen({super.key, required this.id});
  final String id;

  static String buildRoute(String id) {
    return '/budget/frugal_month/$id/settings/notifications';
  }

  late final FrugalMonthNotificationsHandler _notifications = inject();

  @override
  Widget build(BuildContext context) {
    return RequestNotificationPermissionsScreen(
      title: 'Allow Frugal Month Notifications',
      subtitle: 'Would you like to receive notifications for all Frugal Months?',
      onChoice: (shouldNotify) async {
        await $settings().setFrugalMonthNotificationsEnabled(shouldNotify);
        if (!shouldNotify) {
          await _notifications.cancelAllFrugalMonthNotifications();
        } else {
          final granted = await $notifications().requestPermission();
          if (granted) {
            await _notifications.rescheduleFrugalMonthNotifications();
          }
        }
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
