import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../app/di.dart';
import '../../../../utils/_list.dart';
import '../../../../utils/_local_date.dart';
import '../../../notifications/notifications.dart';
import '../../domain/models/frugal_month.dart';
import '../../domain/use_cases/watch_frugal_months.dart';
import '../screens/frugal_month_details_screen.dart';

class FrugalMonthStartNotification implements LocalNotification {
  FrugalMonthStartNotification({required this.frugalMonth});
  final FrugalMonth frugalMonth;

  @override
  String get body => '${frugalMonth.name} is starting, are you ready?';

  @override
  NotificationChannel get channel => NotificationChannel.frugalMonths;

  @override
  String get id => 'frugal_month_start_${frugalMonth.id}';

  @override
  NotificationPayload get payload {
    return NotificationPayload(
      destination: FrugalMonthDetailsScreen.buildBudgetTabRoute(frugalMonth.id),
    );
  }

  @override
  String get title => frugalMonth.name;
}

class FrugalMonthCheckInNotification implements LocalNotification {
  FrugalMonthCheckInNotification({required this.frugalMonth, required this.checkInNumber});

  final FrugalMonth frugalMonth;
  final int checkInNumber;

  @override
  String get body => 'Tap to check in on your progress for ${frugalMonth.name}';

  @override
  NotificationChannel get channel => NotificationChannel.frugalMonths;

  @override
  String get id => 'frugal_month_check_in_${checkInNumber}_${frugalMonth.id}';

  @override
  NotificationPayload get payload {
    return NotificationPayload(
      destination: FrugalMonthDetailsScreen.buildBudgetTabRoute(frugalMonth.id),
    );
  }

  @override
  String get title => frugalMonth.name;
}

class FrugalMonthEndNotification implements LocalNotification {
  FrugalMonthEndNotification({required this.frugalMonth});
  final FrugalMonth frugalMonth;

  String message() {
    final options = [
      "🏁 You did it! ${frugalMonth.name} is over, let's see how you did.",
      '🎉 ${frugalMonth.name} is done! How did you do? Tap to check it out.',
      "🎬 That's a wrap on ${frugalMonth.name}. Tap to see how you did.",
    ];
    return options.pickRandom();
  }

  @override
  String get body => message();

  @override
  NotificationChannel get channel => NotificationChannel.frugalMonths;

  @override
  String get id => 'frugal_month_end_${frugalMonth.id}';

  @override
  NotificationPayload get payload {
    return NotificationPayload(
      destination: FrugalMonthDetailsScreen.buildBudgetTabRoute(frugalMonth.id),
    );
  }

  @override
  String get title => frugalMonth.name;
}

class FrugalMonthNotificationsHandler {
  FrugalMonthNotificationsHandler({
    required FlutterLocalNotificationsPlugin notifications,
    required WatchFrugalMonths watchFrugalMonths,
  }) : _notifications = notifications,
       _watchFrugalMonths = watchFrugalMonths;

  factory FrugalMonthNotificationsHandler.create() {
    return FrugalMonthNotificationsHandler(
      notifications: inject(),
      watchFrugalMonths: WatchFrugalMonths.create(),
    );
  }

  final FlutterLocalNotificationsPlugin _notifications;
  final WatchFrugalMonths _watchFrugalMonths;

  Future<void> cancelAllFrugalMonthNotifications() async {
    final allMonths = await _watchFrugalMonths().nextValue();
    for (final month in allMonths) {
      await _notifications.cancel(FrugalMonthStartNotification(frugalMonth: month).intId);
      // Use all days of the month to be sure we cancel *all* check-ins
      for (var i = 0; i < month.month.daysInMonth().length; i++) {
        await _notifications.cancel(
          FrugalMonthCheckInNotification(frugalMonth: month, checkInNumber: i).intId,
        );
      }
      await _notifications.cancel(FrugalMonthEndNotification(frugalMonth: month).intId);
    }
  }

  Future<void> cancelFrugalMonthNotifications(String id) async {
    final allMonths = await _watchFrugalMonths().nextValue();
    final month = allMonths.firstWhereOrNull((f) => f.id == id);
    if (month != null) {
      await _notifications.cancel(FrugalMonthStartNotification(frugalMonth: month).intId);
      // Use all days of the month to be sure we cancel *all* check-ins
      for (var i = 0; i < month.month.daysInMonth().length; i++) {
        await _notifications.cancel(
          FrugalMonthCheckInNotification(frugalMonth: month, checkInNumber: i).intId,
        );
      }
      await _notifications.cancel(FrugalMonthEndNotification(frugalMonth: month).intId);
    }
  }

  Future<void> rescheduleFrugalMonthNotifications() async {
    final allMonths = await _watchFrugalMonths().nextValue();
    await cancelAllFrugalMonthNotifications();
    for (final month in allMonths) {
      await scheduleNewFrugalMonthNotifications(fMonth: month);
    }
  }

  Future<void> scheduleNewFrugalMonthNotifications({required FrugalMonth fMonth}) async {
    if (fMonth.month.lastDayOfMonth().isBefore(today)) return;
    // Notify at start only if the start of the desired month is
    // in the future.
    final shouldNotifyAtStart = fMonth.month.firstDayOfMonth().isAfter(today);
    final weeksInMonth = fMonth.month.daysInMonth().where((d) {
      return d.dayOfWeek == DayOfWeek.monday && d.isAfter(today);
    });
    // Kick-off notification
    final startOfMonth = fMonth.month.firstDayOfMonth();
    // Wrap-up notification
    final endOfMonth = fMonth.month.lastDayOfMonth().addDays(1);
    if (shouldNotifyAtStart) {
      await _notifications.schedule(
        FrugalMonthStartNotification(frugalMonth: fMonth),
        scheduledDate: tz.TZDateTime.parse(tz.local, startOfMonth.yyyyMMdd()),
      );
    }
    for (var week = 0; week < weeksInMonth.length; week++) {
      final weekStart = weeksInMonth.elementAt(week);
      if (weekStart.isBefore(today)) continue;
      await _notifications.schedule(
        FrugalMonthCheckInNotification(frugalMonth: fMonth, checkInNumber: week),
        scheduledDate: tz.TZDateTime.parse(tz.local, weekStart.yyyyMMdd()),
      );
    }
    await _notifications.schedule(
      FrugalMonthEndNotification(frugalMonth: fMonth),
      scheduledDate: tz.TZDateTime.parse(tz.local, endOfMonth.yyyyMMdd()),
    );
  }
}
