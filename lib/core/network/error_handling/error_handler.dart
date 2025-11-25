import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'remote_exceptions.dart';
import 'error_code.dart';

class ErrorHandler {
  static RemoteExceptions handleDioError(DioError e) {

    debugPrint("DioError intercepted: ${e.toString()}");

    final response = e.response;

    if (response != null) {

      debugPrint(" Dio Error Status Code: ${response.statusCode}");
      debugPrint(" Dio Error Response Data: ${response.data}");

      // Try to extract a server message
      String? serverMessage;

      if (response.data is Map && response.data['message'] is String) {
        serverMessage = response.data['message'];
      }
      else{
        final errorCode= mapStatusCodeToErrorCode(response.statusCode??-1);
        serverMessage =errorCode.getLocalizedMessage();
      }

      // Delegate to centralized status code handler
      try {
        ErrorHandler.handleRemoteStatusCode(
          response.statusCode ?? -1,
          serverMessage ?? ErrorCode.UNKNOWN.getLocalizedMessage(),
        );
      } catch (ex) {
        // Make sure only RemoteExceptions are thrown
        if (ex is RemoteExceptions) {
          return ex;
        }
        else {
          return  RemoteExceptions(ErrorCode.UNKNOWN,ErrorCode.UNKNOWN.getLocalizedMessage() );
        }
      }
    }

    // No response: infer based on Dio error type
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RemoteExceptions(ErrorCode.TIMEOUT, ErrorCode.TIMEOUT.getLocalizedMessage());

      case DioExceptionType.connectionError:
        return RemoteExceptions(ErrorCode.NO_INTERNET_CONNECTION,ErrorCode.NO_INTERNET_CONNECTION.getLocalizedMessage() );

      case DioExceptionType.cancel:
        return RemoteExceptions(ErrorCode.CANCEL, ErrorCode.CANCEL.getLocalizedMessage());

      case DioExceptionType.badCertificate:
        return RemoteExceptions(ErrorCode.BAD_CERTIFICATE, ErrorCode.BAD_CERTIFICATE.getLocalizedMessage());

      case DioExceptionType.unknown:
      default:
        return  RemoteExceptions(ErrorCode.UNKNOWN, ErrorCode.UNKNOWN.getLocalizedMessage());
    }
  }



  static bool handleRemoteStatusCode(int statusCode, dynamic msg) {

    if (statusCode >= 200 && statusCode < 300) {
      return true;
    } else if (statusCode == 400) {
      throw RemoteExceptions(ErrorCode.BAD_REQUEST, msg?? ErrorCode.BAD_REQUEST.getLocalizedMessage());
    } else if (statusCode == 401) {
      throw RemoteExceptions(ErrorCode.UNAUTHENTICATED, msg ?? ErrorCode.UNAUTHENTICATED.getLocalizedMessage());
    } else if (statusCode == 403) {
      throw RemoteExceptions(ErrorCode.FORBIDDEN, msg ?? ErrorCode.FORBIDDEN.getLocalizedMessage());
    }
    else if (statusCode == 404) {
      throw RemoteExceptions(ErrorCode.NOT_FOUND, msg ?? ErrorCode.NOT_FOUND.getLocalizedMessage());
    }
    else if (statusCode == 409) {
      throw RemoteExceptions(ErrorCode.PENDING_APPROVAL, msg ?? ErrorCode.PENDING_APPROVAL.getLocalizedMessage());
    } else if (statusCode == 422) {
      throw RemoteExceptions(ErrorCode.UNPROCESSABLE_ENTITY, msg ?? ErrorCode.UNPROCESSABLE_ENTITY.getLocalizedMessage());
    } else if (statusCode >= 500) {
      throw RemoteExceptions(ErrorCode.SERVER_ERROR, msg?? ErrorCode.SERVER_ERROR.getLocalizedMessage());
    } else {
      throw RemoteExceptions(ErrorCode.UNKNOWN, msg ?? ErrorCode.UNKNOWN.getLocalizedMessage());
    }
  }


  static ErrorCode mapStatusCodeToErrorCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ErrorCode.BAD_REQUEST;
      case 401:
        return ErrorCode.UNAUTHENTICATED;
      case 403:
        return ErrorCode.FORBIDDEN;
      case 404:
        return ErrorCode.NOT_FOUND;
      case 408:
        return ErrorCode.TIMEOUT;
      case 409:
        return ErrorCode.PENDING_APPROVAL;
      case 422:
        return ErrorCode.UNPROCESSABLE_ENTITY;
      case 426:
        return ErrorCode.NOT_EXIST_ACCOUNT;
      case 495:
        return ErrorCode.BAD_CERTIFICATE;
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ErrorCode.SERVER_ERROR;
      default:
        return ErrorCode.UNKNOWN;
    }
  }

}

