import 'package:equatable/equatable.dart';
import '../../../core/models/enum/states_enum.dart';

class AuthState extends Equatable {
  final StateValue loginState;
  final StateValue registerState;
  final StateValue otpState;
  final StateValue verifyOtpState;
  final StateValue logoutState;

  final StateValue forgotPasswordState;
  final StateValue resetPasswordState;

  final String loginMessage;
  final String registerMessage;
  final String otpMessage;
  final String verifyOtpMessage;
  final String logoutMessage;

  final String forgotPasswordMessage;
  final String resetPasswordMessage;

  const AuthState({
    this.loginState = StateValue.init,
    this.registerState = StateValue.init,
    this.otpState = StateValue.init,
    this.verifyOtpState = StateValue.init,
    this.logoutState = StateValue.init,

    this.forgotPasswordState = StateValue.init,
    this.resetPasswordState = StateValue.init,

    this.loginMessage = '',
    this.registerMessage = '',
    this.otpMessage = '',
    this.verifyOtpMessage = '',
    this.logoutMessage = '',
    this.forgotPasswordMessage = '',
    this.resetPasswordMessage = '',
  });

  AuthState copyWith({
    StateValue? loginState,
    StateValue? registerState,
    StateValue? otpState,
    StateValue? verifyOtpState,
    StateValue? logoutState,

    StateValue? forgotPasswordState,
    StateValue? resetPasswordState,

    String? loginMessage,
    String? registerMessage,
    String? otpMessage,
    String? verifyOtpMessage,
    String? logoutMessage,

    String? forgotPasswordMessage,
    String? resetPasswordMessage,
  }) {
    return AuthState(
      loginState: loginState ?? this.loginState,
      registerState: registerState ?? this.registerState,
      otpState: otpState ?? this.otpState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      logoutState: logoutState ?? this.logoutState,

      forgotPasswordState: forgotPasswordState ?? this.forgotPasswordState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,

      loginMessage: loginMessage ?? this.loginMessage,
      registerMessage: registerMessage ?? this.registerMessage,
      otpMessage: otpMessage ?? this.otpMessage,
      verifyOtpMessage: verifyOtpMessage ?? this.verifyOtpMessage,
      logoutMessage: logoutMessage ?? this.logoutMessage,

      forgotPasswordMessage:
      forgotPasswordMessage ?? this.forgotPasswordMessage,
      resetPasswordMessage:
      resetPasswordMessage ?? this.resetPasswordMessage,
    );
  }

  @override
  List<Object> get props => [
    loginState,
    registerState,
    otpState,
    verifyOtpState,
    logoutState,

    forgotPasswordState,
    resetPasswordState,

    loginMessage,
    registerMessage,
    otpMessage,
    verifyOtpMessage,
    logoutMessage,

    forgotPasswordMessage,
    resetPasswordMessage,
  ];
}
