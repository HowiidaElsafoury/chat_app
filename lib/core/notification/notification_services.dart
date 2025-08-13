import 'package:chat_app/core/notification/firebase_messaging_manager.dart';
import 'package:chat_app/core/notification/local_notification_manager.dart';

class NotificationServices {
  FireBaseMessagingManager fireBaseMessagingManager =
      FireBaseMessagingManager();
  LocalNotificationManager localNotificationManager =
      LocalNotificationManager();

  Future<void> init() async {
    await fireBaseMessagingManager.init();
    await localNotificationManager.init();
    _listenOnMessage();
  }

  void _listenOnMessage() {
    fireBaseMessagingManager.listen((message) async {
      await localNotificationManager.showNotification(
        messageBody: message.notification?.body,
        messageTitle: message.notification?.title,
      );
    });
  }
}
