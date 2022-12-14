import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'local_notification.dart';

class PushNotificationHelper {

  static late ValueChanged<String?> _onTokenChanged;

  static initializeFCM({
    required void onTokenChanged(String? token),
    void onNotificationPressed(Map<String, dynamic> data)?,
    required BackgroundMessageHandler onNotificationReceived,
    GlobalKey<NavigatorState>? navigatorKey,
    required String icon,
  }) async {
    _onTokenChanged = onTokenChanged;

    await LocalNotification.initializeLocalNotification(
      onNotificationPressed: onNotificationPressed,
      icon: icon,
    );

    await Firebase.initializeApp();

    FirebaseMessaging.instance.getToken().then(onTokenChanged);

    Stream<String> _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(onTokenChanged);

    FirebaseMessaging.onBackgroundMessage(onNotificationReceived);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        print('getInitialMessage');
        print(message);
        if (message != null) {
          if (navigatorKey != null)
            Timer.periodic(
              Duration(
                milliseconds: 500,
              ),
              (timer) {
                if (navigatorKey.currentState == null) return;
                onNotificationPressed!(message.data);
                timer.cancel();
              },
            );
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('On message called!');

      onNotificationReceived(message);
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        LocalNotification.showNotification(
          notification: notification,
          payload: message.data,
          icon: icon,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp called!');
      onNotificationPressed!(message.data);
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('onBackgroundMessage Called');
      onNotificationPressed!(message.data);
      onNotificationReceived(message);
    });
  }

  static deleteRefreshToken() {
    FirebaseMessaging.instance.deleteToken();
    FirebaseMessaging.instance.getToken().then(_onTokenChanged);
  }
}
