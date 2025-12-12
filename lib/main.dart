import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/config/app_configt.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/features/home_page/presentation/home_page.dart';
import 'package:internet_application_project/features/my_complaints/presentation/my_complaints_page.dart';

import 'package:internet_application_project/features/notification_page/NotificationService.dart';
import 'package:provider/provider.dart';
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
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await safeFirebaseInit();

  print("📩 Background Notification:");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await safeFirebaseInit();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // to get saved preferences
  final appConst = AppConst();
  await appConst.init();

  runApp(
    MultiProvider(
      providers: [
        // AppConst provider
        ChangeNotifierProvider.value(value: appConst),



        // RemoteDatasource provider
        Provider<RemoteService>(
          create: (context) => RemoteService.getInstance(
            context.read<AppConst>(),
          ),
        ),
      ],   // Provide AppConst to RemoteDatasource
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
         BlocProvider(
              create: (_) => AuthCubit(
                  remoteDatasource: context.read<RemoteService>())),
        // BlocProvider(BlocProvider
        //     create: (_) => HomePageCubit(
        //         remoteService: context.read<RemoteService>())),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Outfit'),
        debugShowCheckedModeBanner: false,
        home: const MyComplaintsPage(),
      ),
    );
  }
}