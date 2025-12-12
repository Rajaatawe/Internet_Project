import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/auth/cubit/auth_cubit.dart';
import 'package:internet_application_project/features/auth/cubit/auth_state.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';

class OtpDialogContent extends StatefulWidget {
  final String email;
  final Function(String)? onVerified;

  const OtpDialogContent({super.key, required this.email, this.onVerified});

  @override
  State<OtpDialogContent> createState() => _OtpDialogContentState();
}

class _OtpDialogContentState extends State<OtpDialogContent> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        /// ---------------- VERIFY OTP ----------------
        if (_isVerifying) {
          if (state.verifyOtpState == StateValue.success) {
            setState(() {
              _isVerifying = false;
            });

            final code = _controllers.map((e) => e.text).join();
            widget.onVerified?.call(code);

            Navigator.pop(context, code);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.verifyOtpMessage),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.verifyOtpState == StateValue.error) {
            setState(() {
              _isVerifying = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.verifyOtpMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        }

        /// ---------------- RESEND OTP ----------------
        if (_isResending) {
          if (state.otpState == StateValue.success) {
            setState(() {
              _isResending = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.otpMessage),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.otpState == StateValue.error) {
            setState(() {
              _isResending = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.otpMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: ResponsiveUtils.isMobile(context)
              ? MediaQuery.of(context).size.width * 0.9
              : ResponsiveUtils.isTablet(context)
                  ? 480
                  : 520,
          padding: EdgeInsets.all(ResponsiveUtils.mediumSpacing(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter Verification Code",
                style: TextStyle(
                  fontSize: ResponsiveUtils.titleTextSize(context) + 2,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sent to ${widget.email}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.largeSpacing(context)),
              _buildOtpFields(context),
              const SizedBox(height: 16),
              _buildResendButton(context),
              SizedBox(height: ResponsiveUtils.mediumSpacing(context)),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // OTP BOXES
  // ---------------------------------------------------------------
  Widget _buildOtpFields(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    final boxSize = isDesktop ? 60 : isTablet ? 56 : 52;
    final spacing = isMobile ? 6.0 : 8.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: EdgeInsets.only(right: index < 5 ? spacing : 0),
          width: boxSize * 0.8,
          height: boxSize.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _focusNodes[index].hasFocus
                  ? primaryColor
                  : Colors.grey[400]!,
              width: _focusNodes[index].hasFocus ? 2.5 : 1.5,
            ),
            color: Colors.white,
            boxShadow: _focusNodes[index].hasFocus
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: isDesktop ? 26 : isTablet ? 24 : 22,
              fontWeight: FontWeight.w600,
              color: darkBrown,
            ),
            onChanged: (value) {
              // Move forward on input
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }

              // Move backward on delete
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------
  Widget _buildResendButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextButton(
          onPressed: _isResending ? null : _resendOtp,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.refresh,
                size: 18,
                color: _isResending ? Colors.grey : primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                _isResending ? "Sending..." : "Resend Code",
                style: TextStyle(
                  fontSize: 15,
                  color: _isResending ? Colors.grey : primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    final buttonWidth = isMobile
        ? MediaQuery.of(context).size.width * 0.5
        : ResponsiveUtils.isTablet(context)
            ? 220
            : 240;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CustomButton(
          width: buttonWidth.toDouble(),
          height: ResponsiveUtils.buttonHeight(context),
          title: _isVerifying ? "Verifying..." : "Verify Code",
          backgroundColor: primaryColor,
          titleColor: Colors.white,
          onTap: _isVerifying ? null : () => _submitOtp(context),
        );
      },
    );
  }

  // ---------------------------------------------------------------
  // VERIFICATION LOGIC - Only triggered by button click
  // ---------------------------------------------------------------
  void _submitOtp(BuildContext context) {
    final code = _controllers.map((c) => c.text).join();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter all 6 digits"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);
    context.read<AuthCubit>().verifyOtp(code, widget.email);
  }

  void _resendOtp() {
    setState(() => _isResending = true);

    // Clear all fields
    for (var ctrl in _controllers) {
      ctrl.clear();
    }

    // Move focus back to first box
    FocusScope.of(context).requestFocus(_focusNodes[0]);

    context.read<AuthCubit>().sendOtp(widget.email);
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}