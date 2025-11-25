import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/validator/validators.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/auth/presentation/login_page.dart';
import 'package:internet_application_project/features/auth/widgets/otp_dialoge_content.dart';
import 'package:internet_application_project/features/auth/widgets/text_field_component.dart';

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

  // Responsive sizing methods
  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return width * 0.25; // Desktop
    } else if (width > 800) {
      return width * 0.2; // Large Tablet
    } else if (width > 600) {
      return width * 0.1; // Tablet
    } else {
      return 24.0; // Mobile
    }
  }

  double _getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) {
      return 16.0; // Small mobile
    } else if (height > 1000) {
      return 40.0; // Large screen
    } else {
      return 32.0; // Normal
    }
  }

  double _getSpacing(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (height < 600) {
      return 12.0; // Small screen
    } else if (width > 600) {
      return 20.0; // Tablet & Desktop
    } else {
      return 15.0; // Mobile
    }
  }

  double _getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 40.0; // Desktop
    } else if (width > 600) {
      return 34.0; // Tablet
    } else {
      return 30.0; // Mobile
    }
  }

  double _getButtonWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return width * 0.25; // Desktop
    } else if (width > 600) {
      return width * 0.4; // Tablet
    } else {
      return width * 0.65; // Mobile
    }
  }

  double _getButtonHeight(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      return 52.0; // iOS standard
    } else {
      return 50.0; // Android standard
    }
  }

  // Adaptive text styles
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
      fontWeight: FontWeight.bold,
      color: secondColor,
      letterSpacing: platform == TargetPlatform.iOS ? -0.3 : 0.0,
    );
  }

  TextStyle _getLoginTextStyle(BuildContext context) {
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
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Middle name is required' : null,
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
      // Mobile: Vertical layout for name fields
      return Column(
        children: [
          TextFieldComponent(
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
            title: 'Enter your first name',
          ),
          SizedBox(height: _getSpacing(context)),
          TextFieldComponent(
            hintText: 'Middle name',
            keyboardType: TextInputType.text,
            maxLines: 1,
            textEditingController: middleNameController,
            validator: (value) => null, // Optional field
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
    final isSmallScreen = width < 400;

    if (isSmallScreen) {
      // For very small screens, stack vertically
      return Column(
        children: [
          TextFieldComponent(
            hintText: 'example@gmail.com',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            textEditingController: emailController,
            validator: validateEmail,
            obscureText: false,
            showLabel: false,
            filled: false,
            withText: true,
            title: 'Enter your email',
          ),
          SizedBox(height: _getSpacing(context)),
          TextFieldComponent(
            hintText: 'Send code',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            textEditingController: TextEditingController(),
            validator: (value) => null,
            obscureText: false,
            showLabel: false,
            filled: false,
            withText: true,
            readOnly: true,
            ontap: () {
              if (emailController.text.isNotEmpty &&
                  validateEmail(emailController.text) == null) {
                _showOtpDialog(context);
              }
            },
          ),
        ],
      );
    } else {
      // Normal row layout
      return Row(
        children: [
          Expanded(
            flex: width > 600 ? 3 : 2,
            child: TextFieldComponent(
              hintText: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              textEditingController: emailController,
              validator: validateEmail,
              obscureText: false,
              showLabel: false,
              filled: false,
              withText: true,
              title: width > 600 ? 'Email' : 'Enter your email',
            ),
          ),
          SizedBox(width: width > 600 ? 16 : 10),
          Expanded(
            flex: width > 600 ? 2 : 1,
            child: TextFieldComponent(
              hintText: 'Send code',
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              textEditingController: TextEditingController(),
              validator: (value) => null,
              obscureText: false,
              showLabel: false,
              filled: false,
              withText: true,
              readOnly: true,
              ontap: () {
                if (emailController.text.isNotEmpty &&
                    validateEmail(emailController.text) == null) {
                  _showOtpDialog(context);
                }
              },
            ),
          ),
        ],
      );
    }
  }

void _showOtpDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must interact with the dialog
    builder: (context) => const OtpDialogContent(),
  ).then((value) {
    if (value != null) {
      print("User entered code: $value");
      // Handle the OTP code here
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isIOS = platform == TargetPlatform.iOS;
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 600;

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
                    // Title
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
                          letterSpacing: isIOS ? -0.5 : 0.0,
                        ),
                      ),
                    ),

                    // Name Fields
                    _buildNameFields(context),
                    SizedBox(height: _getSpacing(context)),

                    // National Number
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

                    // Phone Number
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

                    // Email & Code Row
                    _buildEmailRow(context),
                    SizedBox(height: _getSpacing(context)),

                    // Password
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

                    // Confirm Password
                    TextFieldComponent(
                      hintText: '#78777NM5abfw@@',
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      textEditingController: confirmPasswordController,
                      validator: (value) {
                        if (confirmPasswordController.text.isEmpty)
                          return 'Confirm password cannot be empty';
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: true,
                      showLabel: false,
                      filled: false,
                      withText: true,
                      title: 'Confirm your password',
                    ),

                    SizedBox(height: _getSpacing(context) * 2),

                    // Sign Up Button
                    CustomButton(
                      formKey: formKey,
                      height: _getButtonHeight(context),
                      width: _getButtonWidth(context),
                      title: 'Sign Up',
                      titleColor: Colors.white,
                      backgroundColor: primaryColor,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // Handle registration logic
                        }
                      },
                    ),

                    SizedBox(height: isLargeScreen ? 60 : 50),

                    // Login Link
                    _buildLoginSection(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
    // Clean up all controllers
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
