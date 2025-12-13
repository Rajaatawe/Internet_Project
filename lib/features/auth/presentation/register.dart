import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/validator/validators.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/auth/presentation/login_page.dart';
import 'package:internet_application_project/features/auth/widgets/otp_dialoge_content.dart';
import 'package:internet_application_project/features/auth/widgets/text_field_component.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../core/models/enum/states_enum.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalNumberController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? _verifiedEmail;
  String? _otpCode;
  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return width * 0.25;
    if (width > 800) return width * 0.2;
    if (width > 600) return width * 0.1;
    return 24.0;
  }

  double _getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) return 16.0;
    if (height > 1000) return 40.0;
    return 32.0;
  }

  double _getSpacing(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (height < 600) return 12.0;
    if (width > 600) return 20.0;
    return 15.0;
  }

  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 40.0;
    if (width > 600) return 34.0;
    return 30.0;
  }

  double _getButtonWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return width * 0.25;
    if (width > 600) return width * 0.4;
    return width * 0.65;
  }

  double _getButtonHeight(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS ? 52.0 : 50.0;
  }

  TextStyle _getFooterTextStyle(BuildContext context) {
    final platform = Theme.of(context).platform;
    final width = MediaQuery.of(context).size.width;
    double fontSize = width > 600 ? 18.0 : 16.0;
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: secondColor,
      letterSpacing: platform == TargetPlatform.iOS ? -0.3 : 0.0,
    );
  }

  TextStyle _getLoginTextStyle(BuildContext context) {
    final platform = Theme.of(context).platform;
    final width = MediaQuery.of(context).size.width;
    double fontSize = width > 600 ? 18.0 : 16.0;
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: primaryColor,
      letterSpacing: platform == TargetPlatform.iOS ? -0.3 : 0.0,
      shadows: const [
        Shadow(
          color: Colors.black26,
          offset: Offset(2.0, 3.0),
          blurRadius: 6.0,
        ),
      ],
    );
  }

  Widget _buildNameFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return Row(
        children: [
          Expanded(
            child: TextFieldComponent(
              hintText: 'First name',
              keyboardType: TextInputType.text,
              maxLines: 1,
              textEditingController: firstNameController,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'First name is required' : null,
              obscureText: false,
              showLabel: false,
              filled: false,
              withText: true,
              title: 'First name',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFieldComponent(
              hintText: 'Middle name',
              keyboardType: TextInputType.text,
              maxLines: 1,
              textEditingController: middleNameController,
              validator: (value) => null, // Optional
              obscureText: false,
              showLabel: false,
              filled: false,
              withText: true,
              title: 'Middle name',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFieldComponent(
              hintText: 'Last name',
              keyboardType: TextInputType.text,
              maxLines: 1,
              textEditingController: lastNameController,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Last name is required' : null,
              obscureText: false,
              showLabel: false,
              filled: false,
              withText: true,
              title: 'Last name',
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          TextFieldComponent(
            hintText: 'First name',
            keyboardType: TextInputType.text,
            maxLines: 1,
            textEditingController: firstNameController,
          validator: (v) {
  if (v == null || v.trim().isEmpty) {
    return 'First name is required';
  }
  return validateText(
    v,
    fieldName: 'First name',
    minLength: 2,
    maxLength: 50,
  );
},

            obscureText: false,
            showLabel: false,
            filled: false,
            withText: true,
            title: 'Enter your first name',
          ),
          SizedBox(height: _getSpacing(context)),
          TextFieldComponent(
            hintText: 'Middle name',
            keyboardType: TextInputType.text,
            maxLines: 1,
            textEditingController: middleNameController,
            validator: (value) => null,
            obscureText: false,
            showLabel: false,
            filled: false,
            withText: true,
            title: 'Enter your middle name',
          ),
          SizedBox(height: _getSpacing(context)),
          TextFieldComponent(
            hintText: 'Last name',
            keyboardType: TextInputType.text,
            maxLines: 1,
            textEditingController: lastNameController,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Last name is required' : null,
            obscureText: false,
            showLabel: false,
            filled: false,
            withText: true,
            title: 'Enter your last name',
          ),
        ],
      );
    }
  }

  Widget _buildEmailRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.otpState == StateValue.success) {
          // OTP sent successfully - show success message
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.otpMessage),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else if (state.otpState == StateValue.error) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.otpMessage),
          //     backgroundColor: Colors.red,
          //   ),
          // );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: width > 600 ? 3 : 2,
                child: TextFieldComponent(
                  hintText: 'example@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  textEditingController: emailController,
                  validator: (v) =>
                      validateEmail(v, mode: AuthFieldMode.emailOnly),

                  obscureText: false,
                  showLabel: false,
                  filled: false,
                  withText: true,
                  title: width > 600 ? 'Email' : 'Enter your email',
                  onChanged: (value) {
                    // Clear verification if email changes
                    if (_verifiedEmail != null && _verifiedEmail != value) {
                      setState(() {
                        _verifiedEmail = null;
                        _otpCode = null;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: width > 600 ? 16 : 10),
              Expanded(
                flex: width > 600 ? 2 : 1,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        validateEmail(emailController.text) == null) {
                      _showOtpDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a valid email first'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: _verifiedEmail == emailController.text
                      ? const Icon(Icons.verified, color: Colors.white)
                      : const Text(
                          'Send code',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ), // Small spacing between field and verification status
          // Show verification status
          if (_verifiedEmail == emailController.text &&
              emailController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Row(
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Email verified',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showOtpDialog(BuildContext context) {
    final email = emailController.text;

    // Send OTP via AuthCubit
    context.read<AuthCubit>().sendOtp(email);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OtpDialogContent(
        email: email,
        onVerified: (String code) {
          // Store verified email and OTP code
          setState(() {
            _verifiedEmail = email;
            _otpCode = code;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    ).then((value) {
      // This runs when dialog is closed
      if (value != null && value is String) {
        print("User entered and verified code: $value");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 600;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.registerState == StateValue.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.registerMessage),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else if (state.registerState == StateValue.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.registerMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.registerState == StateValue.loading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getHorizontalPadding(context),
                    vertical: _getVerticalPadding(context),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: isLargeScreen ? 20.0 : 10.0,
                            bottom: _getSpacing(context) * 1.5,
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: darkBrown,
                              fontSize: _getTitleFontSize(context),
                              fontWeight: FontWeight.bold,
                              letterSpacing: platform == TargetPlatform.iOS
                                  ? -0.5
                                  : 0.0,
                            ),
                          ),
                        ),
                        _buildNameFields(context),
                        SizedBox(height: _getSpacing(context)),
                        TextFieldComponent(
                          hintText: '121********',
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          textEditingController: nationalNumberController,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'National number is required'
                              : null,
                          obscureText: false,
                          showLabel: false,
                          filled: false,
                          withText: true,
                          title: 'Enter your national number',
                        ),
                        SizedBox(height: _getSpacing(context)),
                        TextFieldComponent(
                          hintText: '0999999999',
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          textEditingController: phoneController,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Phone number is required'
                              : null,
                          obscureText: false,
                          showLabel: false,
                          filled: false,
                          withText: true,
                          title: 'Enter your phone number',
                        ),
                        SizedBox(height: _getSpacing(context)),
                        _buildEmailRow(context),
                        SizedBox(height: _getSpacing(context)),
                        TextFieldComponent(
                          hintText: '#78777NM5abfw@@',
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          textEditingController: passwordController,
                          validator: validatePassword,
                          obscureText: true,
                          showLabel: false,
                          filled: false,
                          withText: true,
                          title: 'Enter your password',
                        ),
                        SizedBox(height: _getSpacing(context)),
                        TextFieldComponent(
                          hintText: '#78777NM5abfw@@',
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          textEditingController: confirmPasswordController,
                          validator: (value) {
                            if (confirmPasswordController.text.isEmpty)
                              return 'Confirm password cannot be empty';
                            if (value != passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                          obscureText: true,
                          showLabel: false,
                          filled: false,
                          withText: true,
                          title: 'Confirm your password',
                        ),
                        SizedBox(height: _getSpacing(context) * 2),

                        // زر Sign Up مع دعم Cubit Loading
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomButton(
                              formKey: formKey,
                              height: _getButtonHeight(context),
                              width: _getButtonWidth(context),
                              title: isLoading ? '' : 'Sign Up',
                              titleColor: Colors.white,
                              backgroundColor: primaryColor,
                              onTap: isLoading
                                  ? null
                                  : () {
                                      // First check if email is verified

                                      if (formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().register(
                                          firstName: firstNameController.text
                                              .trim(),
                                          middleName: middleNameController.text
                                              .trim(),
                                          lastName: lastNameController.text
                                              .trim(),
                                          nationalNumber:
                                              nationalNumberController.text
                                                  .trim(),
                                          phone: phoneController.text.trim(),
                                          email: emailController.text.trim(),
                                          password: passwordController.text
                                              .trim(),
                                          passwordConfirmation:
                                              confirmPasswordController.text
                                                  .trim(),
                                        );
                                        if (state.registerState ==
                                            StateValue.success) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      }
                                    },
                            ),
                            if (isLoading)
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: isLargeScreen ? 60 : 50),
                        _buildLoginSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account? ', style: _getFooterTextStyle(context)),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final theme = Theme.of(context);
                    if (theme.platform == TargetPlatform.iOS) {
                      return CupertinoPageTransition(
                        primaryRouteAnimation: animation,
                        secondaryRouteAnimation: secondaryAnimation,
                        child: child,
                        linearTransition: true,
                      );
                    } else {
                      return FadeTransition(opacity: animation, child: child);
                    }
                  },
            ),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text('Login', style: _getLoginTextStyle(context)),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    nationalNumberController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
