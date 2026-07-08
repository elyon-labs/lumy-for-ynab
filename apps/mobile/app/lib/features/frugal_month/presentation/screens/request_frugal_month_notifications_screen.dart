import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'request_notification_permissions_screen.dart';

class RequestFrugalMonthNotificationsScreen extends HookWidget {
  const RequestFrugalMonthNotificationsScreen({super.key});

  static String route = '/budget/frugal_month_notifications';

  @override
  Widget build(BuildContext context) {
    return RequestNotificationPermissionsScreen(
      title: 'Allow Frugal Month Notifications',
      subtitle: 'Would you like to receive notifications for Frugal Months?',
      onChoice: (value) {
        Navigator.of(context).pop(value);
      },
    );
  }
}
