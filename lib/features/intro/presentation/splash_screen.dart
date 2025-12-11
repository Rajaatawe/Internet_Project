// import 'package:flutter/material.dart';
// import 'package:internet_application_project/core/constants/app_assets.dart';
// import 'package:internet_application_project/features/home_page/presentation/home_page.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   double _opacity = 0.0;
//   double _logoSize = 150.0; // Initial size for the logo

//   @override
//   void initState() {
//     super.initState();
//     // Start the fade-in animation
//     Future.delayed(Duration(milliseconds: 100), () {
//       setState(() {
//         _opacity = 1.0; // Fade in
//       });
//     });

//     // Start the morph animation after a delay
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         _logoSize = 250.0; // Increase size for morph effect
//       });
//     });

//     // Navigate to HomeScreen after a total delay
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFD6CFC4), // Soft Calm background
//       body: Center(
//         child: AnimatedOpacity(
//           opacity: _opacity,
//           duration: Duration(seconds: 1),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedContainer(
//                 duration: Duration(seconds: 1),
//                 curve: Curves.easeInOut,
//                 height: _logoSize,
//                 width: _logoSize,
//                 child: Image.asset(logo), 
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Welcome to My App',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF8B5B29), // Warm Earth Brown
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

