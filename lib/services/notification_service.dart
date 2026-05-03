import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: android,
    );

    await notifications.initialize(
      settings,
    );
  }

  static Future<void> showRoast(
    String body,
  ) async {
    const androidDetails =
        AndroidNotificationDetails(
      'roomie_channel',
      'Roomie Roast',
      importance:
          Importance.max,
      priority:
          Priority.high,
    );

    const details =
        NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      0,
      'Roomie Roast 🔥',
      body,
      details,
    );
  }
}