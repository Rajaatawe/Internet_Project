import 'package:flutter/material.dart';
import 'package:internet_application_project/features/auth/presentation/login_page.dart';
import 'package:internet_application_project/features/home_page/presentation/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(
        fontFamily: 'Outfit',

      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}