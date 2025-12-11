import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/constants/app_assets.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/validator/validators.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/auth/presentation/register.dart';
import 'package:internet_application_project/features/auth/widgets/auth_text_field.dart';
import 'package:internet_application_project/features/auth/widgets/captcha_dialog.dart';

import '../../../core/models/enum/states_enum.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Responsive sizing methods
  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return width * 0.2; // Desktop
    } else if (width > 600) {
      return width * 0.15; // Tablet
    } else {
      return 24.0; // Mobile
    }
  }

  double _getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) {
      return 16.0; // Small mobile
    } else if (height > 1200) {
      return height * 0.1; // Large screen
    } else {
      return 32.0; // Normal
    }
  }

  double _getLogoSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 320; // Desktop
    } else if (width > 600) {
      return 300; // Tablet
    } else {
      return 250; // Mobile
    }
  }

  double _getSpacing(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) {
      return 16.0; // Small screen
    } else if (height > 1000) {
      return 48.0; // Large screen
    } else {
      return 24.0; // Normal screen
    }
  }

  double _getButtonWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return width * 0.3; // Desktop
    } else if (width > 600) {
      return width * 0.5; // Tablet
    } else {
      return width * 0.8; // Mobile
    }
  }

  double _getButtonHeight(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      return 50.0; // iOS standard
    } else {
      return 48.0; // Android standard
    }
  }

  // Adaptive text style methods
  TextStyle _getTitleStyle(BuildContext context) {
    final platform = Theme.of(context).platform;
    final width = MediaQuery.of(context).size.width;
    
    double fontSize;
    if (width > 600) {
      fontSize = 18.0; // Tablet & Desktop
    } else {
      fontSize = 16.0; // Mobile
    }

    return TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      letterSpacing: platform == TargetPlatform.iOS ? -0.5 : 0.0, // iOS typically uses negative letter spacing
    );
  }

  TextStyle _getFooterTextStyle(BuildContext context) {
    final platform = Theme.of(context).platform;
    final width = MediaQuery.of(context).size.width;
    
    double fontSize;
    if (width > 600) {
      fontSize = 18.0;
    } else {
      fontSize = 16.0;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: secondColor,
      letterSpacing: platform == TargetPlatform.iOS ? -0.3 : 0.0,
    );
  }

  TextStyle _getSignUpTextStyle(BuildContext context) {
    final platform = Theme.of(context).platform;
    final width = MediaQuery.of(context).size.width;
    
    double fontSize;
    if (width > 600) {
      fontSize = 18.0;
    } else {
      fontSize = 16.0;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: primaryColor,
      letterSpacing: platform == TargetPlatform.iOS ? -0.3 : 0.0,
      shadows: [
        Shadow(
          color: fourthColor,
          offset: const Offset(2.0, 3.0),
          blurRadius: 6.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isIOS = platform == TargetPlatform.iOS;
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    Container(
                      margin: EdgeInsets.only(
                        top: isDesktop ? 60.0 : 20.0,
                        bottom: _getSpacing(context),
                      ),
                      child: Image.asset(
                        logo,
                        width: _getLogoSize(context),
                        height: _getLogoSize(context)*0.8,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Email section
                    _buildInputSection(
                      context,
                      title: 'Enter your email or phone number',
                      hintText: 'example@gmail.com / 0999112233',
                      controller: emailController,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),

                    SizedBox(height: _getSpacing(context)),

                    // Password section
                    _buildInputSection(
                      context,
                      title: 'Enter your password',
                      hintText: '#7877765abfw@@',
                      controller: passwordController,
                      validator: validatePassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),

                    SizedBox(height: _getSpacing(context) * 0.8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Add forgot password functionality
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: thirdColor,
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: _getSpacing(context)),

                    // Login button
                    BlocConsumer<AuthCubit, AuthState>(
                      buildWhen: (previous, current) =>
                      current.loginState != previous.loginState,
                      listenWhen: (previous, current) =>
                      current.loginState != previous.loginState,
                    listener: (context,state) {
                      if (state.loginState == StateValue.loaded){
                        print("print success Login");

                      }else if(state.loginState == StateValue.error){
                        print("///////////////////////////////////////////////Error login");
                      }
                    },
                      builder: (context,state){
                        if (state.loginState == StateValue.loading){
                          return CustomButton(
                            title: '',
                              onTap: (){},
                            width: _getButtonWidth(context),
                            height: _getButtonHeight(context),
                            backgroundColor: primaryColor,
                            titleColor: Colors.white,
                          );
                        }
                        else{
                          return CustomButton(
                            formKey: formKey,
                            width: _getButtonWidth(context),
                            height: _getButtonHeight(context),
                            title: 'Login',
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                final success = await showCaptcha(context);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Login allowed!"),
                                      behavior: isIOS ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
                                      shape: isIOS
                                          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                          : null,
                                    ),
                                  );
                                  BlocProvider.of<AuthCubit>(context).login(emailController.text, passwordController.text);
                                  print('//////////////////////////////////////////////////////////////');
                                  print("Login perfecto");
                                  print('//////////////////////////////////////////////////////////////');

                                }
                              } else if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Please fix the errors before continuing.",
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: isIOS ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
                                    shape: isIOS
                                        ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                        : null,
                                  ),
                                );
                              }
                            },
                            backgroundColor: primaryColor,
                            titleColor: Colors.white,
                          );
                      }
                      },
                   ),

                    SizedBox(height: isDesktop ? 120 : 80),

                    // Sign up section
                    _buildSignUpSection(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(
    BuildContext context, {
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    required bool obscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _getTitleStyle(context),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        AuthTextField(
          hintText: hintText,
          icon: Icons.remove_red_eye,
          keyboardType: keyboardType,
          maxLines: 1,
          textEditingController: controller,
          validator: validator,
          obscureText: obscureText,
          showLabel: false,
        ),
      ],
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: _getFooterTextStyle(context),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final theme = Theme.of(context);
                if (theme.platform == TargetPlatform.iOS) {
                  return CupertinoPageTransition(
                    primaryRouteAnimation: animation,
                    secondaryRouteAnimation: secondaryAnimation,
                    child: child,
                    linearTransition: true,
                  );
                } else {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                }
              },
            ),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              'Sign Up',
              style: _getSignUpTextStyle(context),
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool> showCaptcha(BuildContext context) async {
  final result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CaptchaDialog(),
  );

  return result == true;
}