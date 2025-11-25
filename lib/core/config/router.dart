


// import 'package:flutter/material.dart';

// import '../../features/auth/Presentation/confirm_account.dart';
// import '../../features/auth/Presentation/forget_password.dart';
// import '../../features/auth/Presentation/login_screen.dart';
// import '../../features/auth/Presentation/register_screen.dart';
// import '../../features/auth/Presentation/reset_password.dart';
// import '../../features/main_layout/main_layout.dart';

// abstract class Routes {
//   static const String initial = "/";
//   static const String landingPages = "/landing_page";
//   static const String homepage = "/home_page";
//   static const String register = "/auth/register";
//   static const String login = "/auth/login";
//   static const String confirmAccount = "/auth/confirm_account";
//   static const String forgetPassword = "/auth/forget_password";
//   static const String resetPassword = "/auth/reset_password";
//   static const String aboutUs = "/aboutUs";
//   static const String searchScreen = "/searchScreen";
//   static const String privacyPolicy = "/privacyPolicy";
//   static const String socialMedia = "/socialMedia";
//   static const String profile = "/profile";
//   static const String notifications = "/notifications";
//   static const String moreScreen = "/moreScreen";
//   static const String contactUs = "/contactUs";
//   static const String carInfo = "/cars/carInfo";
//   static const String propertyInfo = "/properties/propertyInfo";
//   static const String addCar = "/cars/addCar";
//   static const String editCar = "/cars/editCar";
//   static const String myCars = "/cars/MyCars";
//   static const String addProperty = "/properties/addProperty";
//   static const String editProperty = "/properties/editProperty";
//   static const String myProperties = "/cars/MyProperties";
//   static const String ourServices = "/ourServices";
//   static const String ownerProfile = "/ownerProfile";
//   static const String favorites = "/favorites";
//   static const String appUpdates = "/appUpdates";


// }

// Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//   final args = settings.arguments as Map<String, dynamic>?;

//   switch (settings.name) {


//     case Routes.homepage:
//       return MaterialPageRoute(
//         builder: (_) => const MainLayout(),
//         settings: const RouteSettings(name: Routes.homepage),
//       );



//     case Routes.register:
//       final fromMainScreen = args?['fromMainScreen'] as bool? ?? true;
//       return MaterialPageRoute(
//         builder: (_) => RegisterScreen(fromMainScreen: fromMainScreen),
//         settings: const RouteSettings(name: Routes.register),
//       );

//     case Routes.login:
//       final fromMainScreen = args?['fromMainScreen'] as bool? ?? true;
//       return MaterialPageRoute(
//         builder: (_) => LoginScreen(fromMainScreen: fromMainScreen),
//         settings: const RouteSettings(name: Routes.login),
//       );

//     case Routes.confirmAccount:
//       final email = args?['email'] as String?;
//       final fromMainScreen = args?['fromMainScreen'] as bool? ?? true;
//       if (email == null) throw ArgumentError("Missing 'email'");
//       return MaterialPageRoute(
//         builder: (_) => ConfirmAccountScreen(email: email, fromMainScreen: fromMainScreen),
//         settings: const RouteSettings(name: Routes.confirmAccount),
//       );

//     case Routes.forgetPassword:
//       final fromMainScreen = args?['fromMainScreen'] as bool? ?? true;

//       return MaterialPageRoute(
//         builder: (_) => ForgetPasswordScreen(fromMainScreen: fromMainScreen),
//         settings: const RouteSettings(name: Routes.forgetPassword),
//       );

//     case Routes.resetPassword:
//       final email = args?['email'] as String?;
//       final fromMainScreen = args?['fromMainScreen'] as bool? ?? true;
//       if (email == null) throw ArgumentError("Missing 'email'");
//       return MaterialPageRoute(
//         builder: (_) => ResetPassword(email: email, fromMainScreen: fromMainScreen),
//         settings: const RouteSettings(name: Routes.resetPassword),
//       );



//     // case Routes.profile:
//     //   return MaterialPageRoute(
//     //     builder: (_) => const ProfileScreen(),
//     //     settings: const RouteSettings(name: Routes.profile),
//     //   );





//     default:
//       return MaterialPageRoute(
//         builder: (_) => const Scaffold(
//           body: Center(child: Text("No route defined")),
//         ),
//         settings: const RouteSettings(name: 'undefined'),
//       );
//   }
// }
