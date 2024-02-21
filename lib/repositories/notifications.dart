import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:online_college/consts/utils.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermissions() async {
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      try {
        if (kDebugMode) {
          print(message.notification?.title);
          print(message.notification?.body);
          print(message.data['page']);
        }

        initLocalNotifications(context, message);
        showNotification(message);
      } catch (e) {
        Utils().showToast(context: context, message: e.toString());
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(1000).toString(),
      'High performance notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'High performance notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      category: AndroidNotificationCategory.alarm,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await Future.delayed(
      Duration.zero,
      () async {
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title ?? 'title',
          message.notification?.body ?? 'body',
          notificationDetails,
        );
      },
    );
  }

  Future<String> getToken() async {
    String token = await messaging.getToken() ?? '';
    return token;
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        handleMessage(context, value);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    Navigator.of(context).pushNamed(message.data['page'].toString());
  }

  void sendNotification({
    required List<String> tokens,
    String page = '',
    required String title,
    required String message,
  }) async {
    print('tokens ${tokens}');

    var data = {
      "registration_ids": tokens,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': message,
      },
      'data': {
        'page': page,
      },
    };
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAuhSDaBw:APA91bGCkWIGn43dIkpD1UDGCrpNqZKUGQMIcfE4jYKBEN6uL3X_FlIzO4-7ScO55FzpAk3Kj3CKE8QsNjFABn2PKXtRzRUvl8qBAuwnq0OY8PjeTvsQkU4hks-V-swH888R2vmAnpAq',
      },
      body: jsonEncode(data),
    );
  }
}
