import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationManager {
  //instance
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //define channel id
  static const String _channelId = 'chat-notification';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'This channel is used for important notifications';
  Future<void> init() async {
    await initalizeLocalNotification();
    await _createNotificationChannel();
  }

  Future<void> initalizeLocalNotification() async {
    const AndroidInitializationSettings androidConfigs =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosConfigs =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    InitializationSettings initializationSettings =
        const InitializationSettings(android: androidConfigs, iOS: iosConfigs);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // TODO: Handle notification tap
        if (!kReleaseMode) {
          log(
            'Notification tapped: ${response.payload}',
            name: 'NotificationServices -- onNotificationTap',
          );
        }
      },
    );
  }
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  Future<void> showNotification({
    int? messageId,
    String? messageTitle,
    String? messageBody,
    Map<String, dynamic>? data,
  }) async {
    // if (data != null) {
    //   title = GetConfigs.isArabicLanguage()
    //       ? data["title_ar"] ?? ''
    //       : data["title"] ?? '';
    //   body = GetConfigs.isArabicLanguage()
    //       ? data["body_ar"] ?? ''
    //       : data["body"] ?? '';
    // } else {
    //   id = messageId ?? 0;
    //   title = messageTitle ?? '';
    //   body = messageBody ?? '';
    // }


    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      messageId ?? 0,
      messageTitle,
      messageBody,
      platformChannelSpecifics,
      payload: data.toString(),
    );
  }
}
