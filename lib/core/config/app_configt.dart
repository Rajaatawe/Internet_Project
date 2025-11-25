import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AppConst extends ChangeNotifier {
  static final AppConst instance = AppConst._internal();
  factory AppConst() => instance;

  AppConst._internal() {
    debugPrint("[AppConst] Constructor called");
  }

  late SharedPreferences _prefs;

  User? _user;
  bool _isLoggedIn = false;
  bool _isApproved = false;
  bool _isDarkMode = false;
  bool _isFirstTime = true;
  String _selectedLanguage = 'ar'; // defaults to Arabic if error

  String? _previousRoute;
  Map<String, dynamic>? _previousArguments;
  bool _previousWantsRebuild = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isApproved => _isApproved;
  bool get isDarkMode => _isDarkMode;
  bool get isFirstTime => _isFirstTime;
  String get selectedLanguage => _selectedLanguage;

  String? get previousRoute => _previousRoute;
  Map<String, dynamic>? get previousArguments => _previousArguments;
  bool get previousWantsRebuild => _previousWantsRebuild;

  String? _appVersion; // app version to check and delete cache if necessary


  Future<void> init() async {
    debugPrint("[AppConst] init() started");
    _prefs = await SharedPreferences.getInstance();
    debugPrint("[AppConst] SharedPreferences instance loaded");
    // await _checkAppVersionAndClearUserIfNeeded();
    await loadPrefs();
    _loadUser();
    debugPrint("[AppConst] init() completed");

  }

  Future<void> loadPrefs() async {

    debugPrint("[AppConst] Loading preferences...");

    final Locale systemLocale = PlatformDispatcher.instance.locale;
    debugPrint('System Locale: ${systemLocale.languageCode}');

    _isFirstTime = _prefs.getBool('isFirstTime') ?? true;
    final Brightness platformBrightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = _prefs.getBool('isDarkMode') ?? true;
    // _selectedLanguage = _prefs.getString('localization') !=null ? _prefs.getString('localization')! : systemLocale!=null? systemLocale.languageCode:"ar";
    _selectedLanguage = _prefs.getString('localization') !=null ? _prefs.getString('localization')! :"ar";

    _isLoggedIn = _prefs.getBool("IsLoggedIn") ?? false;

    debugPrint("[AppConst] Preferences loaded:");
    debugPrint("  isFirstTime: $_isFirstTime");
    debugPrint("  isDarkMode: $_isDarkMode");
    debugPrint("  selectedLanguage: $_selectedLanguage");
    debugPrint("  isLoggedIn: $_isLoggedIn");

    notifyListeners();
  }

  Future<void> setIsFirstTime(bool value) async {
    debugPrint("[AppConst] setIsFirstTime($value)");
    _isFirstTime = value;
    await _prefs.setBool("isFirstTime", value);
    notifyListeners();
  }



  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    debugPrint("[AppConst] toggleTheme() → isDarkMode: $_isDarkMode");
    await _prefs.setBool("isDarkMode", _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    debugPrint("[AppConst] setLanguage($langCode)");
    _selectedLanguage = langCode;
    await _prefs.setString('localization', langCode);
    notifyListeners();
  }

  Future<void> saveUser(Map<String,dynamic> user) async {
    debugPrint("[AppConst] saveUser() → Saving user: ${user}");
    _user = User.fromJson(user);
    _isLoggedIn = true;


    await _prefs.setString("user", jsonEncode(user));
    await _prefs.setBool("IsLoggedIn", true);

    notifyListeners();
  }

  void _loadUser() {
    debugPrint("[AppConst] _loadUser() called");
    final userString = _prefs.getString("user");
    if (userString != null) {
      try {
        final json = jsonDecode(userString);
        final loadedUser = User.fromJson(json);
        _user = loadedUser;
        debugPrint("[AppConst] User loaded from prefs: ${_user!.toJson()}");
      } catch (e) {
        debugPrint("[AppConst] Failed to load user from prefs: $e");
        _user = null;
        _isApproved = false;
      }
      notifyListeners();
    } else {
      debugPrint("[AppConst] No user data found in prefs.");
    }
  }

  Future<void> removeUser() async {
    debugPrint("[AppConst] removeUser()");
    _user = null;
    _isApproved = false;
    _isLoggedIn = false;

    await _prefs.remove("user");
    await _prefs.setBool("IsLoggedIn", false);
    await _prefs.remove("token");

    notifyListeners();
  }

  Future<void> updateUser() async {
    debugPrint("[AppConst] updateUser()");
    if (_user != null) {
      await saveUser(_user!.toJson());
    } else {
      debugPrint("[AppConst] No user to update.");
    }
  }

  Future<void> setIsLoggedIn(bool value) async {
    debugPrint("[AppConst] setIsLoggedIn($value)");
    _isLoggedIn = value;
    await _prefs.setBool("IsLoggedIn", value);
    if (!value) {
      _user = null;
      _isApproved = false;
    }
    notifyListeners();
  }

  void setPreviousRoute(String route, {Map<String, dynamic>? args, bool wantsRebuild = false}) {
    debugPrint("[AppConst] setPreviousRoute($route, wantsRebuild: $wantsRebuild)");
    _previousRoute = route;
    _previousArguments = args;
    _previousWantsRebuild = wantsRebuild;
  }

  void clearPreviousRoute() {
    debugPrint("[AppConst] clearPreviousRoute()");
    _previousRoute = null;
    _previousArguments = null;
    _previousWantsRebuild = false;
  }


}
