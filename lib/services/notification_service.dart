import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettingsIos = DarwinInitializationSettings();
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void show(int id, String title, String body, {String? payload}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
