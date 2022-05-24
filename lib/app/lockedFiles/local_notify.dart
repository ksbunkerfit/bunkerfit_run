import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<NotificationDetails> _notificationDetails() async {
  return NotificationDetails(
    android: AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 0 * 1000,
      usesChronometer: true,
    ),
    iOS: IOSNotificationDetails(),
  );
}

Future localNotifyInit({bool initScheduled = false}) async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOS = IOSInitializationSettings();
  const macOS = MacOSInitializationSettings();

  const settings =
      InitializationSettings(android: android, iOS: iOS, macOS: macOS);

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onSelectNotification: (payload) async {
      print(payload);
    },
  );
}

Future showNotification({
  int id = 0,
  String? title,
  String? body,
  String? payload,
}) async =>
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
