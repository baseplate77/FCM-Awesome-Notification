import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> _bgMessageHandler(RemoteMessage remoteMessage) async {
  print("Background Message ${remoteMessage.toMap()}");
  // this funtion wil create notification from BG based on the payload
  NotificationController.createNotificationFromJson(remoteMessage);
}

class NotificationController extends ChangeNotifier {
  // SINGLETON PATTERN
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

// INITIALIZATION METHOD

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          enableVibration: true,
          defaultColor: Colors.redAccent,
          channelShowBadge: true,
          enableLights: true,
        ),
      ],
      debug: debug,
    );
  }

  // REMOTE NOTIFICAIONT INITIALIZATION

  static Future<void> initializeRemoteNotifications() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_bgMessageHandler);

    FirebaseMessaging.onMessage
        .listen(NotificationController.onMessageListiner);

    // Ignore this method as Awesome notication listener will sever us best
    FirebaseMessaging.onMessageOpenedApp
        .listen(NotificationController.onMessageOpenedAppListiner);
  }

  static onMessageListiner(RemoteMessage remoteMessage) {
    print("onMessage Recevied : ${remoteMessage.toMap()}");
    NotificationController.createNotificationFromJson(remoteMessage);
  }

  static onMessageOpenedAppListiner(RemoteMessage remoteMessage) {
    print("onMessageOpendedApp recevied : ${remoteMessage}");
  }

  static createNotificationFromJson(RemoteMessage remoteMessage) async {
    await AwesomeNotifications()
        .createNotificationFromJsonData(remoteMessage.data);
  }

  static createLocalNotification(RemoteMessage remoteMessage) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: "basic_channel",
        title: remoteMessage.notification!.title,
        body: remoteMessage.notification!.body,
      ),
    );
  }

  static getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM token : $fcmToken");
  }

  static requrestNotificationPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print("recivedAction : ${receivedAction.toString()}");

    Fluttertoast.showToast(
      msg: 'Action notification recevied',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint("Notification created");

    Fluttertoast.showToast(
      msg: 'Notification created ',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint("Notification displayed");

    Fluttertoast.showToast(
      msg: 'Notification displayed ',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("Notification dismiss");

    Fluttertoast.showToast(
      msg: 'Notification dismiss ',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static getInitialMessage() async {
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    print("remote message receviced : ${remoteMessage.toString()}");
  }

  /// This method is call when a any given cause the app launch
  /// Note the app was terminated
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    if (receivedAction == null) return;
  }
}
