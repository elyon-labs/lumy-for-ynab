import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_db;
import 'package:timezone/timezone.dart' as tz;
import 'package:universal_platform/universal_platform.dart';

import '../../app/navigation/router.dart';

part 'notifications.mapper.dart';

@pragma('vm:entry-point')
void onTapNotificationInBackground(NotificationResponse notificationResponse) {
  final payload = notificationResponse.payload;
  if (payload?.isNotEmpty ?? false) {
    final payloadJson = jsonDecode(payload!);
    final notificationPayload = NotificationPayloadMapper.fromJson(payloadJson as String);
    $router().go(notificationPayload.destination);
  }
}

void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {}

typedef HasNotificationPermissions = Future<bool> Function();

extension NotificationsX on FlutterLocalNotificationsPlugin {
  Future<void> init() async {
    tz_db.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('ic_icon');
    const iosSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestBadgePermission: false,
      requestAlertPermission: false,
      requestSoundPermission: false,
      notificationCategories: [DarwinNotificationCategory('frugal_months')],
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTapNotificationInBackground,
      onDidReceiveBackgroundNotificationResponse: onTapNotificationInBackground,
    );
  }

  /// If the application was started by a notification tap, and that notification
  /// contained a [NotificationPayload], this method will return the payload.
  Future<NotificationPayload?> getAppStartNotificationPayload() async {
    // Be extra careful here, as this method is called during app startup.
    try {
      final appStartPayload = await getNotificationAppLaunchDetails();
      final payload = appStartPayload?.notificationResponse?.payload;
      return payload != null
          ? NotificationPayloadMapper.fromMap(jsonDecode(payload) as Map<String, dynamic>)
          : null;
    } catch (err) {
      return null;
    }
  }

  Future<void> schedule(
    LocalNotification notification, {
    required tz.TZDateTime scheduledDate,
  }) async {
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await zonedSchedule(
      stringToInt(notification.id),
      notification.title,
      notification.body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notification.channel.id,
          notification.channel.name,
          channelDescription: notification.channel.description,
        ),
      ),
      payload: jsonEncode(notification.payload),
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<bool> hasPermission() async {
    late final bool granted;
    if (UniversalPlatform.isAndroid) {
      final plugin =
          resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      granted = await plugin?.areNotificationsEnabled() ?? false;
    } else if (UniversalPlatform.isIOS) {
      final options =
          await resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
              .checkPermissions();
      granted = options?.isEnabled ?? false;
    } else {
      // Unsupported platform
      granted = false;
    }
    return granted;
  }

  Future<bool> requestPermission() async {
    late final bool granted;
    if (UniversalPlatform.isAndroid) {
      final plugin =
          resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      granted = await plugin?.requestNotificationsPermission() ?? false;
    } else if (UniversalPlatform.isIOS) {
      granted =
          await resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else {
      // Unsupported platform
      granted = false;
    }
    return granted;
  }
}

enum NotificationChannel {
  frugalMonths('frugal_months', 'Frugal Months', 'Notifications for Frugal Months'),
  monthInReview('month_in_review', 'Month in Review', 'Notifications for Month in Review');

  const NotificationChannel(this.id, this.name, this.description);

  final String id;
  final String name;
  final String description;
}

abstract class LocalNotification {
  LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.channel,
  });
  final String id;
  final String title;
  final String body;
  final NotificationPayload payload;
  final NotificationChannel channel;
}

extension LocalNotificationX on LocalNotification {
  int get intId => stringToInt(id);
}

int stringToInt(String s) {
  // Hash the string using SHA-256
  final bytes = utf8.encode(s); // Data being hashed
  final digest = sha256.convert(bytes);

  // This is a simple way to convert the hash into a somewhat unique integer.
  var result = 0;
  for (var i = 0; i < 4; i++) {
    result = (result << 4) | digest.bytes[i];
  }
  return result;
}

@MappableClass()
class NotificationPayload with NotificationPayloadMappable {
  NotificationPayload({required this.destination});

  final String destination;
}
