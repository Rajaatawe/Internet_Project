import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_configt.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../network/error_handling/error_code.dart';
import '../network/error_handling/error_handler.dart';
import '../network/error_handling/remote_exceptions.dart';

class RemoteService {
  final Dio dio = Dio();
  static Uri uri = Uri.parse(baseUrl);
  static RemoteService? _instance;
  final AppConst appConstProvider;

  /// to cache and save token
  String? _cachedToken;

  /// Private constructor
  RemoteService._(this.appConstProvider);

  /// Singleton instance
  static RemoteService getInstance(AppConst appConstProvider) {
    _instance ??= RemoteService._(appConstProvider);
    return _instance!;
  }

  ///////////////// AUTH /////////////////

  /// http post for most auth requests that share the same requests and responses
  Future<T> performAuthRequest<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic>) fromJson, {
    bool useToken = false,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');
    debugPrint('data  is $data');

    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      FormData formData = FormData.fromMap(data);
      final response = await dio.postUri(
        Uri.parse(baseUrl + endpoint),
        data: formData,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');

      /// if success
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {

          final userMap = response.data["data"]["user"];
          print(userMap);
          print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
          print('object1');
          final token = response.data["data"]["token"];
          print('object2');

          print(userMap);

          debugPrint("reached from json ");
          final user = fromJson(userMap);
          debugPrint("left from json ");

          debugPrint("reached save user");
          await appConstProvider.saveUser(userMap);
          debugPrint("left save user ");

          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("token", token);
            _cachedToken = token;
          }

          return user;

      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }
 Future<T> performAuthRequestRegisterOnly<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic>) fromJson, {
    bool useToken = false,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');
    debugPrint('data  is $data');

    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      FormData formData = FormData.fromMap(data);
      final response = await dio.postUri(
        Uri.parse(baseUrl + endpoint),
        data: formData,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');

      /// if success
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {

          final userMap = response.data["data"];
          print(userMap);
          print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");

          print(userMap);

          debugPrint("reached from json ");
          final user = fromJson(userMap);
          debugPrint("left from json ");

          debugPrint("reached save user");
          await appConstProvider.saveUser(userMap);
          debugPrint("left save user ");

          return user;

      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  Future<Response?> performVerifyTokenRequest(
    String endpoint, {
    bool useToken = true,
    required bool needResponse,
  }) async {
    debugPrint('HEAD request to endpoint: $endpoint');

    try {
      final response = await dio.getUri(
        Uri.parse(baseUrl + endpoint),
        options: await _setOptions(useToken),
      );

      if (needResponse) {
        debugPrint('HEAD status code: ${response.statusCode}');
      }

      final isValid = ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      );

      if (!isValid) {
        throw Exception("Error");
      }

      return response;
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  Future<void> performLogoutRequest<T>(
    String endpoint, {
    bool useToken = true,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoint is $endpoint');

    if (encrypt) {
      debugPrint("encryption enabled");
    }

    try {
      final response = await dio.postUri(
        Uri.parse(baseUrl + endpoint),
        options: await _setOptions(useToken),
      );

      if (isResponseEncrypted) {
        debugPrint("handling encrypted response");
      }

      debugPrint('response is $response');

      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        await appConstProvider.removeUser();
        await appConstProvider.setIsLoggedIn(false);
        _cachedToken = null;
      } else {
        throw Exception("Logout failed: ${response.data}");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  performDeleteAccountRequest<T>(
    String endpoint,
    dynamic data, {
    bool useToken = true,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');

    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      final response = await dio.deleteUri(
        Uri.parse(baseUrl + endpoint),
        data: data,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        await appConstProvider.removeUser();
        await appConstProvider.setIsLoggedIn(false);
        _cachedToken = null;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  ///////////////// GET /////////////////

  Future<T> performGetRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');
    try {
      final response = await dio.getUri(
        Uri.parse(baseUrl + endpoint),
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        return fromMap(response.data!["data"]);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  Future<List<T>> performGetListRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
    bool isResponseEncrypted = false,
    String? keyWord,
  }) async {
    debugPrint('endpoints  is $endpoint');

    try {
      final response = await dio.get(
        baseUrl + endpoint,
        options: await _setOptions(useToken),

      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        List<T> result = [];

        final dataList = keyWord == null
            ? response.data!["data"]
            : response.data!["data"][keyWord];

        for (var element in dataList) {
          result.add(fromMap(element));
        }
        return result;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  Future<List<T>> performGetListRequestWithPagination<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
    bool isResponseEncrypted = false,
    String? keyWord,
  }) async {
    debugPrint('endpoints  is $endpoint');

    try {
      final response = await dio.get(
        baseUrl + endpoint,
        options: await _setOptions(useToken),
      );

      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }

      debugPrint('response is $response');

      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        List<T> result = [];

        final rawList = response.data["data"];

        final dataSource = keyWord != null
            ? rawList[keyWord]
            : (rawList is Map<String, dynamic> && rawList["data"] is List
                  ? rawList["data"]
                  : rawList);

        for (var element in dataSource) {
          result.add(fromMap(element));
        }

        return result;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  ///////////////// POST /////////////////

  Future<T> performPostRequest<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');
    debugPrint('data  is $data');

    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      final response = await dio.postUri(
        uri.resolve(baseUrl + endpoint),
        data: data,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }

      debugPrint('response is $response');

      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        return fromMap(response.data!["data"]??{});
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }


Future<void> performPostRequestNoRes(
  String endpoint,
  dynamic data, {
  bool useToken = true,
  bool encrypt = false,
  bool isResponseEncrypted = false,
}) async {
  debugPrint('endpoints is $endpoint');
  debugPrint('data is $data');

  if (encrypt) {
    debugPrint("encryption");
  }
  
  try {
    final response = await dio.postUri(
      uri.resolve(baseUrl + endpoint),
      data: data,
      options: await _setOptions(useToken),
    );

    if (isResponseEncrypted) {
      debugPrint("encrypted response");
    }

    debugPrint('response is $response');

    if (ErrorHandler.handleRemoteStatusCode(
      response.statusCode!,
      response.data,
    )) {
      // You may want to handle the response data here if needed
      // For example, logging or further processing
      debugPrint('Processed data: ${response.data!["data"] ?? {}}');
    } else {
      throw Exception("Error");
    }
  } catch (e) {
    if (e is RemoteExceptions) rethrow;
    if (e is DioError) throw ErrorHandler.handleDioError(e);

    debugPrint("App-level error: ${e.toString()}");
    debugPrintStack();
    throw RemoteExceptions(
      ErrorCode.APP_ERROR,
      ErrorCode.APP_ERROR.getLocalizedMessage(),
    );
  }
}



  Future<T> performPostRequestWithFormData<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');
    debugPrint('data  is $data');
    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      FormData formData = FormData.fromMap(data);
      final response = await dio.postUri(
        uri.resolve(baseUrl + endpoint),
        data: formData,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        return fromMap(response.data!["data"]);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  ///////////////// PUT /////////////////

  Future<T> performPutRequest<T>(
    String endpoint,
    dynamic data,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
    bool encrypt = false,
    bool isResponseEncrypted = false,
  }) async {
    debugPrint('endpoints  is $endpoint');
    debugPrint('data  is $data');
    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      final response = await dio.putUri(
        uri.resolve(baseUrl + endpoint),
        data: data,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      debugPrint('response is $response');
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        return fromMap(response.data!["data"]);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  performPutRequestWithFormDataNoRes(
    String endpoint,
    dynamic data, {
    bool useToken = true,
    bool encrypt = false,
    bool isResponseEncrypted = false,
    String? keyWord,
    required bool needResponse,
  }) async {
    debugPrint('endpoints  is $endpoint');
    debugPrint('data  is $data');
    if (encrypt) {
      debugPrint("encryption");
    }
    try {
      data.fields.add(const MapEntry('_method', 'PUT'));
      final response = await dio.postUri(
        Uri.parse(baseUrl + endpoint),
        data: data,
        options: await _setOptions(useToken),
      );
      if (isResponseEncrypted) {
        debugPrint("encrypted response");
      }
      if (needResponse) {
        debugPrint('response is $response');
      }
      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data["data"],
      )) {
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  ///////////////// DELETE /////////////////

  Future<T> performDeleteRequest<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromMap, {
    bool useToken = true,
  }) async {
    debugPrint('DELETE endpoint: $endpoint');

    try {
      final response = await dio.deleteUri(
        uri.resolve(baseUrl + endpoint),
        options: await _setOptions(useToken),
      );

      debugPrint('response: $response');

      if (ErrorHandler.handleRemoteStatusCode(
        response.statusCode!,
        response.data,
      )) {
        return fromMap(response.data!);
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      if (e is RemoteExceptions) rethrow;
      if (e is DioError) throw ErrorHandler.handleDioError(e);

      debugPrint(" App-level error: ${e.toString()}");
      debugPrintStack();
      throw RemoteExceptions(
        ErrorCode.APP_ERROR,
        ErrorCode.APP_ERROR.getLocalizedMessage(),
      );
    }
  }

  Future<String?> _getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString("token");
    return _cachedToken;
  }

  clearToken() {
    _cachedToken = null;
  }

  Future<Options> _setOptions(bool useToken) async {
    Options options = Options(
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );
    if (useToken) {
      String? token = '46|buJtZa1MEvCB6zdHSAnvMKTv1FdJn92rfVhWvOtO295c7209';
      // String? token = await _getToken();
      // if (token == null) {
      //   throw const RemoteExceptions(
      //       ErrorCode.USER_DATA_NOT_FOUND, 'not logged in');
      // }
      debugPrint("token: $token");
      options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } else {
      options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }
    return options;
  }
}
