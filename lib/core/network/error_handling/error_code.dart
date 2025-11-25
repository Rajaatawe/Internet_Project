import '../../config/app_configt.dart';
import 'error_localization.dart';

enum ErrorCode {
  UNAUTHENTICATED,
  FORBIDDEN,
  BAD_REQUEST,
  NOT_FOUND,
  NO_INTERNET_CONNECTION,
  TIMEOUT,
  SERVER_ERROR,
  EXIST,
  NOT_EXIST_ACCOUNT,
  APP_ERROR,
  USER_DATA_NOT_FOUND,
  PENDING_APPROVAL,
  UNPROCESSABLE_ENTITY,
  UNKNOWN,
  CANCEL,
  BAD_CERTIFICATE
}



extension ErrorCodeTranslation on ErrorCode {
  String getLocalizedMessage() {
    final lang = AppConst.instance.selectedLanguage;
    return errorMessages[lang]?[this] ?? errorMessages['en']![ErrorCode.UNKNOWN]!;
  }
}
