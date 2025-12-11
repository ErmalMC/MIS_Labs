// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  // singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize plugin & timezone data
  Future<void> init() async {
    // initialize timezone database (required for zonedSchedule)
    tz.initializeTimeZones();

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        // handle notification tap here; payload available at resp.payload
        debugPrint('Notification tapped payload=${resp.payload}');
      },
    );
  }

  /// Schedule a repeating daily notification at [hour]:[minute] local time.
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    int id = 0,
    String title = 'Recipe of the Day',
    String body = 'Check out today\'s random recipe!',
    bool exact = false, // option to request exact if you later want to
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_recipe_channel',
      'Daily Recipe',
      channelDescription: 'Daily notification for recipe of the day',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));

    // Choose schedule mode: prefer INEXACT to avoid exact alarm permission issues
    final AndroidScheduleMode scheduleMode = exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      notificationDetails,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'random_recipe',
    );
  }
}
