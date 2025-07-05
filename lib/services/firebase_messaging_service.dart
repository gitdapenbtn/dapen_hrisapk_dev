import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dpbtn_absen/services/notification_service.dart';

class FirebaseMessagingService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> init(NotificationService notificationService) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await FirebaseMessaging.instance.getToken();
    await _secureStorage.write(key: 'fcm_registration_id', value: token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        notificationService.show(notification.hashCode, notification.title!, notification.body!);
      }
    });
  }
}