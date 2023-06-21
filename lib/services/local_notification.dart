import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotification {
  static Future<void> createBasicNotificationWithPlayload() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "basic_channel",
        title: "This is Basic Notificaition",
        body: "Press on the notificaiton on it one Temp Screen",
        payload: {
          "screen_name": "TEMP_SCREEN",
          // add any other parameter like user ID, etc
        },
      ),
    );
  }
}
