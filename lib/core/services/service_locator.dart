import 'package:internet_application_project/core/config/app_configt.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';

class ServiceLocator {
  static RemoteService? _remoteService;
  static AppConst? _appConst;

  static void setup({required AppConst appConst}) {
    _appConst = appConst;
    _remoteService = RemoteService.getInstance(appConst);
  }

  static RemoteService get remoteService {
    if (_remoteService == null) {
      throw Exception('ServiceLocator not initialized. Call setup() first.');
    }
    return _remoteService!;
  }
}