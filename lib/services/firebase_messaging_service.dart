import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dpbtn_absen/services/notification_service.dart';

class FirebaseMessagingService {
  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();

  Future<void> init(NotificationService notificationService) async {
    await Firebase.initializeApp();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance
          .getAPNSToken()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => null,
          );

      if (kDebugMode) {
        print("APNS_TOKEN: $apnsToken");
      }
    }

    String? token;

    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) {
        print("FCM_TOKEN_ERROR: $e");
      }
    }

    if (token != null) {
      await _secureStorage.write(
        key: 'fcm_registration_id',
        value: token,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        notificationService.show(
          notification.hashCode,
          notification.title!,
          notification.body!,
        );
      }
    });
  }
}
