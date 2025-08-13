import 'package:chat_app/core/notification/firebase_messaging_manager.dart';
import 'package:chat_app/core/notification/local_notification_manager.dart';
import 'package:chat_app/core/notification/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  // LocalNotificationManager localNotification = LocalNotificationManager();
  // localNotification.init();
  // localNotification.showNotification(data: message.data);
  // if (!kReleaseMode) {
  //   log("🔔 Background/Terminated Notification: ${message.data}",
  //       name: 'NotificationServices -- firebaseMessagingBackgroundHandler');
  // }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationServices notificationServices=NotificationServices();
  await notificationServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Container()));
  }
}
