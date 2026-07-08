import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../app/di.dart';
import '../../../common/presentation/_int.dart';
import '../../../utils/_local_date.dart';
import '../../notifications/notifications.dart';
import '../screens/month_in_review_screen.dart';

class MonthInReviewNotification implements LocalNotification {
  MonthInReviewNotification({required this.deliveryMonth});
  final LocalDate deliveryMonth;

  @override
  String get body => 'Your Month in Review report is ready. Tap to check it out.';

  @override
  NotificationChannel get channel => NotificationChannel.monthInReview;

  @override
  String get id => 'month_in_review_${deliveryMonth.monthOfYear}_${deliveryMonth.year}';

  @override
  NotificationPayload get payload {
    return NotificationPayload(destination: MonthInReviewScreen.route);
  }

  @override
  String get title =>
      "That's a wrap on ${deliveryMonth.subtractMonths(1).monthOfYear.toMonthName()}!";
}

class MonthInReviewNotificationsHandler {
  MonthInReviewNotificationsHandler({required FlutterLocalNotificationsPlugin notifications})
    : _notifications = notifications;

  factory MonthInReviewNotificationsHandler.create() {
    return MonthInReviewNotificationsHandler(notifications: inject());
  }

  final FlutterLocalNotificationsPlugin _notifications;

  Future<void> cancelAllMonthInReviewNotifications() async {
    final next12Deliveries = List.generate(
      12,
      // The next 12 months, starting from next month
      (i) => today.firstDayOfMonth().addMonths(i + 1),
    );
    for (final month in next12Deliveries) {
      final id = 'month_in_review_${month.monthOfYear}_${month.year}';
      await _notifications.cancel(stringToInt(id));
    }
  }

  Future<void> scheduleNext12MonthInReviewNotifications() async {
    await cancelAllMonthInReviewNotifications();
    final requests = await _notifications.pendingNotificationRequests();
    final next12Deliveries = List.generate(
      12,
      // The next 12 months, starting from the next month
      (i) => today.firstDayOfMonth().addMonths(i + 1),
    );
    for (final month in next12Deliveries) {
      final id = MonthInReviewNotification(deliveryMonth: month).id;
      if (requests.any((e) => e.id == stringToInt(id))) {
        continue;
      }
      final notification = MonthInReviewNotification(deliveryMonth: month);
      await _notifications.schedule(
        notification,
        scheduledDate: tz.TZDateTime.parse(tz.local, month.yyyyMMdd()),
      );
    }
  }
}
