import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _requestNotificationPermission();

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Local Notification Init
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          print("📦 OPEN PAYLOAD: $payload");
        }
      },
    );

    /// Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fcm_channel',
      'FCM Notifications',
      description: 'Channel for FCM notifications',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Foreground handler
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    /// Background opened
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📨 تم فتح التطبيق من إشعار");
    });

    /// Token
    final token = await _messaging.getToken();
    print("🔑 FCM Token: $token");
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 حالة الإذن: ${settings.authorizationStatus}');
  }

  String _createPayload(RemoteMessage message) {
    return jsonEncode({
      "title": message.notification?.title ?? "",
      "body": message.notification?.body ?? "",
      "data": message.data,
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'FCM Notifications',
      channelDescription: 'Channel for FCM notifications',
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: _createPayload(message),
    );
  }
}
