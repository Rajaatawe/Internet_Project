import 'package:dio/dio.dart';
import 'error_code.dart';

class RemoteExceptions implements Exception {
  final ErrorCode errorCode;
  final dynamic errorMsg;
  Response? response; // <-- optional

  RemoteExceptions(this.errorCode, this.errorMsg, {this.response});

  @override
  String toString() => 'RemoteExceptions(errorMsg: $errorMsg)';
}
