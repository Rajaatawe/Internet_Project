import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static String? _previousRoute;
  static Object? _previousArguments;
  static bool _previousWantsRebuild = false;

  static void navigateWithReturn({
    required String route,
    Object? arguments,
    bool rebuildOnReturn = false,
    required String currentRoute,
  }) {
    debugPrint("Current route: $currentRoute");
    debugPrint("Arguments: $arguments");

    _previousRoute = currentRoute;
    _previousArguments = arguments;
    _previousWantsRebuild = rebuildOnReturn;

    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }


  static void returnToPrevious() {
    if (_previousRoute == null) {
      debugPrint("No previous route stored. Falling back to pop.");
      navigatorKey.currentState?.pop();
      return;
    }

    bool routeFound = false;

    navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name == _previousRoute) {
        routeFound = true;
        return true;
      }
      return false;
    });

    if (!routeFound) {
      debugPrint("Previous route '$_previousRoute' not found in stack. Doing a single pop.");
      navigatorKey.currentState?.pop();
    }
  }

}
