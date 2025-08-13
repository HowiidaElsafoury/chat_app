import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FireBaseMessagingManager {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> init() async {
    await _requestPermission();
    await messaging.setAutoInitEnabled(true);
    await messaging.getNotificationSettings();
    await _getFCMToken();
  }

  Future<void> _requestPermission() async {
    try {
      final NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (!kReleaseMode) {
        log(
          '${settings.authorizationStatus}',
          name:
              '🟢FireBaseMessagingManager:::_requestPermission::: Authorization Status:::',
        );
      }
    } catch (e) {
      if (!kReleaseMode) {
        log(
          '$e',
          name: '❌ FireBaseMessagingManager:::_requestPermission::: Error',
        );
      }
    }
  }

  Future<void> _getFCMToken() async {
    try {
      final fcmToken = await messaging.getToken();
      if (!kReleaseMode) {
        log(
          '${fcmToken}',
          name: '🟢FireBaseMessagingManager:::_getFCMToken: FCMtoken:::',
        );
      }
    } catch (e) {
      if (!kReleaseMode) {
        log('$e', name: '❌ FireBaseMessagingManager:::_getFCMToken::: Error');
      }
    }
  }

  void listen(Function(RemoteMessage message)? onMessage) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification?.title}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification?.body}',
        );
        onMessage?.call(message);
      }
    });
  }
}
