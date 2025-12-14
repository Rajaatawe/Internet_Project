import 'package:flutter/material.dart';
import 'package:internet_application_project/core/constants/app_assets.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/features/auth/presentation/login_page.dart';
import 'package:internet_application_project/features/home_page/presentation/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _logoSize = 150.0; 

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // Fade in
      });
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _logoSize = 250.0; // Increase size for morph effect
      });
    });

    // Navigate to LoginPage after a total delay with animation
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start from below the screen
        const end = Offset.zero; // End at the center of the screen
        const curve = Curves.bounceInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 500), // Duration of the transition
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBrown,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                height: _logoSize,
                width: _logoSize,
                child: Image.asset(logo), 
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to Sajelha',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
