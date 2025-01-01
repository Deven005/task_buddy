import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_buddy/main.dart';
import 'package:task_buddy/screens/task/task_details.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin and the timezone data
  static Future<void> initialize() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute<void>(builder: (context) => const TaskDetailsScreen()),
    );
  }

  // Show Notification
  static Future<void> showNotification(
      int taskId, String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel', // Channel ID
      'Task Notifications', // Channel Name
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Display the notification immediately
    await flutterLocalNotificationsPlugin.show(
      taskId, // Task ID as unique notification ID
      title,
      body,
      notificationDetails,
    );
  }

  // Schedule Notification with Timezone
  static Future<void> scheduleNotification(
      int taskId, String title, String body, DateTime scheduledTime) async {
    // Convert the scheduledTime to a timezone-aware DateTime object

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime,
        tz.getLocation(_getFullTimeZoneName(DateTime.now().timeZoneName)));

    const androidDetails = AndroidNotificationDetails(
      'task_channel', // Channel ID
      'Task Notifications', // Channel Name
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule notification using timezone
    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskId, // Task ID as notification ID
      title,
      body,
      tzScheduledTime, // Scheduled time for the notification
      notificationDetails,
      // Allow notification when the app is idle
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Convert the abbreviation to a full timezone name
  static String _getFullTimeZoneName(String timeZoneAbbreviation) {
    Map<String, String> timeZoneMap = {
      'IST': 'Asia/Kolkata', // Indian Standard Time
      'UTC': 'UTC', // Coordinated Universal Time
      'CET': 'Europe/Paris', // Central European Time
      'PST': 'America/Los_Angeles', // Pacific Standard Time
      // Add other abbreviations if needed
    };

    // Return the full timezone name if available, or fallback to UTC
    return timeZoneMap[timeZoneAbbreviation] ?? 'UTC';
  }

  /// Toggle notification permission
  Future<void> updateNotificationPermission(bool isEnabled) async {
    if (isEnabled) {
      // Schedule or show a sample notification to verify
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'task_channel', // Channel ID
        'Task Notifications', // Channel name
        channelDescription: 'This channel is for Task Notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Notifications Enabled',
        'You will receive notifications from now on.',
        platformChannelSpecifics,
      );
    } else {
      // Cancel all notifications if disabled
      await flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
