import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';

class OtpDialogContent extends StatefulWidget {
  const OtpDialogContent({super.key});

  @override
  State<OtpDialogContent> createState() => _OtpDialogContentState();
}

class _OtpDialogContentState extends State<OtpDialogContent> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: ResponsiveUtils.isMobile(context) 
            ? MediaQuery.of(context).size.width * 0.85
            : ResponsiveUtils.isTablet(context)
                ? 400
                : 450,
        padding: EdgeInsets.all(ResponsiveUtils.mediumSpacing(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "Enter The Code",
              style: TextStyle(
                fontSize: ResponsiveUtils.titleTextSize(context) + 2,
                fontWeight: FontWeight.w600,
                color: darkBrown,
              ),
            ),

            SizedBox(height: ResponsiveUtils.largeSpacing(context)),

            // OTP Input Fields - 5 boxes
            _buildOtpFields(context),

            SizedBox(height: ResponsiveUtils.largeSpacing(context)),

            // Buttons Row
            _buildButtonsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpFields(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final boxSize = ResponsiveUtils.isDesktop(context) ? 60 : 
                   ResponsiveUtils.isTablet(context) ? 55 : 50;
    final spacing = isMobile ? 8.0 : 12.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return Container(
          width: boxSize.toDouble(),
          height: boxSize.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focusNodes[index].hasFocus ? primaryColor : Colors.grey[400]!,
              width: _focusNodes[index].hasFocus ? 2 : 1,
            ),
            color: Colors.white,
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textInputAction: index == 4 ? TextInputAction.done : TextInputAction.next,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveUtils.isDesktop(context) ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
              
              // Auto-submit when all fields are filled
              if (value.isNotEmpty && index == 4) {
                _submitOtp(context);
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildButtonsRow(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final buttonWidth = isMobile 
        ? MediaQuery.of(context).size.width * 0.3
        : ResponsiveUtils.isTablet(context) ? 140 : 160;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Confirm button
        CustomButton(
          width: buttonWidth.toDouble(),
          height: ResponsiveUtils.buttonHeight(context) - 4,
          title: "confirm",
          backgroundColor: primaryColor,
          titleColor: Colors.white,
          onTap: () => _submitOtp(context),
        ),
        
        SizedBox(width: ResponsiveUtils.mediumSpacing(context)),
        
        // Again button
        CustomButton(
          width: buttonWidth.toDouble(),
          height: ResponsiveUtils.buttonHeight(context) - 4,
          title: "again",
          backgroundColor: Colors.grey[100]!,
          titleColor: darkBrown,
          onTap: _clearOtpFields,
        ),
      ],
    );
  }

  void _submitOtp(BuildContext context) {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 5) {
      Navigator.pop(context, code);
    } else {
      // Show error if not all fields are filled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter all 5 digits"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _clearOtpFields() {
    for (final controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
    
    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Code cleared"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}