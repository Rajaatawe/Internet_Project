import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user.dart';
import '../../../core/network/error_handling/remote_exceptions.dart';
import '../../../core/services/generalized_api.dart';
import 'auth_state.dart';
import '../../../core/models/enum/states_enum.dart';

class AuthCubit extends Cubit<AuthState> {

  final RemoteService _remoteDatasource;

  AuthCubit({required RemoteService remoteDatasource})
      : _remoteDatasource = remoteDatasource,
        super(const AuthState());
  // --------------------------
  // LOGIN
  // --------------------------
  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginState: StateValue.loading));
    try {
      Map<String, dynamic> payload = {
        'email': email,
        'password': password,
      };

      await _remoteDatasource.performAuthRequest("login", payload, UserClass.fromJson, useToken: false);

      emit(state.copyWith(loginState: StateValue.loaded, loginMessage: "success"));


    } catch (e) {
      if (e is RemoteExceptions) {

        emit(state.copyWith(loginState: StateValue.error, loginMessage: e.errorMsg.toString()));

      } else {

        emit(state.copyWith(loginState: StateValue.error, loginMessage: e.toString()));
      }
    }
  }

  // --------------------------
  // REGISTER
  // --------------------------
  Future<void> register({
    required String firstName,
    required String middleName,
    required String lastName,
    required String nationalNumber,
    required String phone,
    required String email,
    required String password,
     required String passwordConfirmation,

  }) async {
    emit(state.copyWith(registerState: StateValue.loading));
    try {
      Map<String,dynamic> data = {
        'first_name':firstName,
         'middle_name':middleName,
          'last_name':lastName,
           'phone':phone,
            'identity_number':nationalNumber,
             'password':password,
              'password_confirmation':passwordConfirmation,
              'email': email,
      };
      await _remoteDatasource.performAuthRequestRegisterOnly('register',data , UserClass.fromJson);
      emit(state.copyWith(
        registerState: StateValue.success,
        registerMessage: "Register success",
      ));
    } catch (e) {
      emit(state.copyWith(
        registerState: StateValue.error,
        registerMessage: e.toString(),
      ));
    }
  }

  // --------------------------
  // SEND OTP
  // --------------------------
  Future<void> sendOtp(String email) async {
    emit(state.copyWith(otpState: StateValue.loading));
    try {
    await _remoteDatasource.performPostRequestNoRes("send-otp",{'email':email}, useToken: false);
      emit(state.copyWith(
        otpState: StateValue.success,
        otpMessage: "OTP sent",
      ));
    } catch (e) {
      emit(state.copyWith(
        otpState: StateValue.error,
        otpMessage: e.toString(),
      ));
    }
  }

  // --------------------------
  // VERIFY OTP
  // --------------------------
  Future<void> verifyOtp(String code, String email) async {
    emit(state.copyWith(verifyOtpState: StateValue.loading));
    try {
await _remoteDatasource.performPostRequestNoRes("verify-otp",{'otp':code ,'email':email}, useToken: false);
      emit(state.copyWith(
        verifyOtpState: StateValue.success,
        verifyOtpMessage: "OTP verified",
      ));
    } catch (e) {
      emit(state.copyWith(
        verifyOtpState: StateValue.error,
        verifyOtpMessage: e.toString(),
      ));
    }
  }

  // --------------------------
  // LOGOUT
  // --------------------------

  Future<void> logout() async {
    emit(state.copyWith(logoutState: StateValue.loading));
    try {
     await _remoteDatasource.performDeleteRequestNoRes("logout",useToken: true);
      emit(state.copyWith(
        logoutState: StateValue.success,
        logoutMessage: "Logout done",
      ));
    } catch (e) {
      emit(state.copyWith(
        logoutState: StateValue.error,
        logoutMessage: e.toString(),
      ));
    }
  }

// --------------------------
  // FORGOT PASSWORD
  // --------------------------
  Future<void> forgetPassword(String email) async {
    emit(state.copyWith(forgotPasswordState: StateValue.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        forgotPasswordState: StateValue.success,
        forgotPasswordMessage: "Reset link sent",
      ));
    } catch (e) {
      emit(state.copyWith(
        forgotPasswordState: StateValue.error,
        forgotPasswordMessage: e.toString(),
      ));
    }
  }

  // --------------------------
  // RESET PASSWORD
  // --------------------------
  Future<void> resetPassword(String otp, String newPassword) async {
    emit(state.copyWith(resetPasswordState: StateValue.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        resetPasswordState: StateValue.success,
        resetPasswordMessage: "Password updated",
      ));
    } catch (e) {
      emit(state.copyWith(
        resetPasswordState: StateValue.error,
        resetPasswordMessage: e.toString(),
      ));
    }
  }
}