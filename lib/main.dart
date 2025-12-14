import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/config/app_configt.dart';
import 'package:internet_application_project/core/models/notification_model.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/features/home_page/presentation/home_page.dart';
import 'package:internet_application_project/features/my_complaints/presentation/my_complaints_page.dart';
import 'package:internet_application_project/features/my_complaints/presentation/view_documents_page.dart';

import 'package:internet_application_project/features/notification/widget/NotificationService.dart';
import 'package:internet_application_project/features/notification/cubit/notification_cubit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/service_locator.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register.dart';

Future<void> safeFirebaseInit() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  const String storageKey = 'saved_notifications';

  final notification = NotificationModel(
    title: message.notification?.title ?? '',
    description: message.notification?.body ?? '',
    time: DateTime.now().toIso8601String(),
  );

  final list = prefs.getStringList(storageKey) ?? [];
  list.add(jsonEncode(notification.toJson()));

  await prefs.setStringList(storageKey, list);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await safeFirebaseInit();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  final appConst = AppConst();
  await appConst.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appConst),
        Provider<RemoteService>(
          create: (context) =>
              RemoteService.getInstance(context.read<AppConst>()),
              
        ),
      ], // Provide AppConst to RemoteDatasource
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => NotificationService().init());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationCubit(remoteDatasource: context.read<RemoteService>())),

        BlocProvider(
          create: (_) =>
              AuthCubit(remoteDatasource: context.read<RemoteService>()),
        ),
        // BlocProvider(BlocProvider
        //     create: (_) => HomePageCubit(
        //         remoteService: context.read<RemoteService>())),
      ],
      
      child: MaterialApp(
          navigatorKey: navigatorKey,

        theme: ThemeData(fontFamily: 'Outfit'),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
