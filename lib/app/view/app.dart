// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_cloud_messeging/counter/counter.dart';
import 'package:firebase_cloud_messeging/l10n/l10n.dart';
import 'package:firebase_cloud_messeging/fcm/local_notification.dart';
import 'package:firebase_cloud_messeging/sample_pages/sample_page1.dart';
import 'package:firebase_cloud_messeging/sample_pages/sample_page2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../fcm/push_notification_helper.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    PushNotificationHelper.initializeFCM(
      onNotificationPressed: (Map<String, dynamic>? data) {
        print('data => ${data.toString()}');
        if(data != null) {
          if(data['screen'] == 'sample_page_one'){
            print('navigator key state: ${_navigatorKey.currentState!}');
            _navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const SamplePageOne()),
            );
          }else{
            _navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const SamplePageTwo()),
            );
          }
        }
      },
      onTokenChanged: (String? token) {
        print(token);
      },
      icon: 'ic_launch_image',
      onNotificationReceived: firebaseMessagingBackgroundHandler,
      navigatorKey: _navigatorKey,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: _navigatorKey,
      home: const CounterPage(),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "Handling a background message: ${message.notification?.title?.toString()}");
  // LocalNotification.showNotification(notification: message.notification!);
}
