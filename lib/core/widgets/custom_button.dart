import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.formKey,
    required this.height,
    required this.width,
    required this.title,
    this.onTap,
    this.backgroundColor = primaryColor,
    this.titleColor = Colors.white,
    this.fontSize,
    this.minWidth,
    this.maxWidth,
  });

  final double height;
  final double width;
  final double? fontSize;
  final String title;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color titleColor;
  final GlobalKey<FormState>? formKey;
  final double? minWidth;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    // Smart responsive calculations
    final double finalHeight = _calculateHeight(context);
    final double finalWidth = _calculateWidth(context);
    final double finalFontSize = _calculateFontSize(context);
    final double borderRadius = _calculateBorderRadius(context);

    return Container(
      width: finalWidth,
      height: finalHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: darkBrown.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: _calculatePadding(context),
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: finalFontSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateHeight(BuildContext context) {
    if (height != 0) return height;
    
    if (ResponsiveUtils.isMobile(context)) {
      return 44.0; // Optimal mobile touch target
    } else if (ResponsiveUtils.isTablet(context)) {
      return 48.0; // Comfortable for tablet
    } else {
      return 52.0; 
    }
  }

  double _calculateWidth(BuildContext context) {
    if (width != 0) return width;
    
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate responsive width based on screen size
    double responsiveWidth;
    if (ResponsiveUtils.isMobile(context)) {
      responsiveWidth = screenWidth * 0.8; // 80% on mobile
    } else if (ResponsiveUtils.isTablet(context)) {
      responsiveWidth = screenWidth * 0.4; // 40% on tablet
    } else {
      responsiveWidth = screenWidth * 0.2; // 20% on desktop
    }
    
    // Apply min/max constraints
    final double minW = minWidth ?? _getMinWidth(context);
    final double maxW = maxWidth ?? _getMaxWidth(context);
    
    return responsiveWidth.clamp(minW, maxW);
  }

  double _calculateFontSize(BuildContext context) {
    if (fontSize != null) return fontSize!;
    
    // Calculate font size based on button height for perfect proportions
    final buttonHeight = _calculateHeight(context);
    double baseSize;
    
    if (buttonHeight <= 44) {
      baseSize = 14.0; // Mobile
    } else if (buttonHeight <= 48) {
      baseSize = 16.0; // Tablet
    } else {
      baseSize = 18.0; // Desktop
    }
    
    // Adjust based on text length to prevent overflow
    final textLength = title.length;
    if (textLength > 15) {
      return baseSize * 0.9;
    } else if (textLength > 10) {
      return baseSize * 0.95;
    }
    
    return baseSize;
  }

  double _calculateBorderRadius(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 8.0;
    } else if (ResponsiveUtils.isTablet(context)) {
      return 10.0;
    } else {
      return 12.0;
    }
  }

  EdgeInsets _calculatePadding(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else if (ResponsiveUtils.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  double _getMinWidth(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 120.0;
    } else if (ResponsiveUtils.isTablet(context)) {
      return 140.0;
    } else {
      return 160.0;
    }
  }

  double _getMaxWidth(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 400.0;
    } else if (ResponsiveUtils.isTablet(context)) {
      return 500.0;
    } else {
      return 600.0;
    }
  }
}