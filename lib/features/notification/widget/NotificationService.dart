import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_application_project/core/models/notification_model.dart';
import 'package:internet_application_project/features/notification/cubit/notification_cubit.dart';
import 'package:internet_application_project/features/notification/presentation/notifications_list_page.dart';
import 'package:internet_application_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  String? token = "";

  static final NotificationService _instance =
      NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _storageKey = 'saved_notifications';

  Future<void> init() async {
    await _requestPermission();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (_) => _openNotificationsPage(),
    );

    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'fcm_channel',
      'FCM Notifications',
      importance: Importance.high,
      description: 'FCM Channel',
    );

    token = await _messaging.getToken();
    print("🔑❤FCM token: $token🎄❤");

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // ✅ عند التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((message) {
      _handleMessage(message);
      _showLocalNotification(message);
    });

    // ✅ عند الضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
      _openNotificationsPage();
    });

    // ✅ عند فتح التطبيق من إشعار
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
      _openNotificationsPage();
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ✅ حفظ الإشعار (Foreground)
  Future<void> _handleMessage(RemoteMessage message) async {
    final notification = NotificationModel(
      title: message.notification?.title ?? '',
      description: message.notification?.body ?? '',
      time: DateTime.now().toIso8601String(),
    );

    await _saveNotification(notification);

    if (navigatorKey.currentContext != null) {
      final cubit =
          BlocProvider.of<NotificationCubit>(
              navigatorKey.currentContext!);
      cubit.addNotification(notification);
    }
  }

  // ✅ التخزين الدائم
  Future<void> _saveNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];

    list.add(jsonEncode(notification.toJson()));
    await prefs.setStringList(_storageKey, list);
  }

  // ✅ تحميل الإشعارات بعد إعادة فتح التطبيق
  Future<List<NotificationModel>> loadStoredNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];

    return list
        .map((e) => NotificationModel.fromJson(jsonDecode(e)))
        .toList();
  }

  void _openNotificationsPage() {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => const NotificationsListPage(),
        ),
      );
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'FCM Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
