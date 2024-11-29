import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    InitializationSettings initializationSettings =
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          showNotificationDialog(context, response.payload!);
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.max,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher"
        ),
      );

      await _notificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.notification?.body,
      );
    } catch (e) {
      print(e);
    }
  }
}