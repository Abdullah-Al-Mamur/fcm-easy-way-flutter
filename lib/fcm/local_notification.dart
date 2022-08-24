import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initializeLocalNotification(
      {void onNotificationPressed(Map<String, dynamic> data)?,
      required String icon}) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final initializationSettingsAndroid = AndroidInitializationSettings(icon);
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        onSelectNotification(payload: payload, onData: onNotificationPressed);
      },
    );
  }

  static Future onSelectNotification({String? payload, onData}) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');

      var jsonData = jsonDecode(payload);
      onData(jsonData);
    }
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print(title);
  }

  static showNotification({
    required RemoteNotification notification,
    Map<String, dynamic>? payload,
    String? icon,
  }) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: icon,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(payload));
  }
}
