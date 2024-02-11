import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
class Notifications {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body, DateTime dateTime) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'exam_notification_channel', // Update channel ID
      'Exam Notifications',
      'Notifications for upcoming exams',
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true, // Add this parameter if necessary
      // Add other necessary parameters here
    );
    final iosPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local), // Update timezone usage
      const NotificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
