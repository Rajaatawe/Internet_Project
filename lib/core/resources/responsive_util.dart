import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  // Screen size detection methods
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static Orientation orientation(BuildContext context) => MediaQuery.of(context).orientation;

  // Device type detection
  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 1200;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 1200;
  static bool isSmallMobile(BuildContext context) => screenWidth(context) < 375;
  static bool isLargeTablet(BuildContext context) => screenWidth(context) >= 900 && screenWidth(context) < 1200;
  static bool isLargeDesktop(BuildContext context) => screenWidth(context) >= 1600;

  // Platform detection
  static bool isIOS(BuildContext context) => Theme.of(context).platform == TargetPlatform.iOS;
  static bool isAndroid(BuildContext context) => Theme.of(context).platform == TargetPlatform.android;
  static bool isWeb(BuildContext context) => kIsWeb;
  static bool isMobileWeb(BuildContext context) => kIsWeb && isMobile(context);

  // Responsive padding methods
  static EdgeInsets screenPadding(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);
    
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(
        horizontal: width * 0.15,
        vertical: height * 0.05,
      );
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.04,
      );
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  static EdgeInsets contentPadding(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.2);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.15);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    }
  }

  static EdgeInsets sectionPadding(BuildContext context) {
    final height = screenHeight(context);
    
    if (height < 600) {
      return const EdgeInsets.symmetric(vertical: 16.0);
    } else if (height > 1000) {
      return EdgeInsets.symmetric(vertical: height * 0.04);
    } else {
      return const EdgeInsets.symmetric(vertical: 24.0);
    }
  }

  static EdgeInsets cardPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(24.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  // Responsive spacing methods
  static double smallSpacing(BuildContext context) {
    if (isDesktop(context)) return 16.0;
    if (isTablet(context)) return 12.0;
    return 8.0;
  }

  static double mediumSpacing(BuildContext context) {
    final height = screenHeight(context);
    
    if (height < 600) {
      return 16.0;
    } else if (height > 1000) {
      return 32.0;
    } else {
      return 24.0;
    }
  }

  static double largeSpacing(BuildContext context) {
    final height = screenHeight(context);
    
    if (height < 600) {
      return 24.0;
    } else if (height > 1000) {
      return 48.0;
    } else {
      return 32.0;
    }
  }

  static double extraLargeSpacing(BuildContext context) {
    final height = screenHeight(context);
    
    if (height < 600) {
      return 32.0;
    } else if (height > 1000) {
      return 80.0;
    } else {
      return 60.0;
    }
  }

  // Responsive text sizes
  static double displayLargeTextSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 48.0;
    if (isTablet(context)) return 40.0;
    if (isSmallMobile(context)) return 28.0;
    return 32.0;
  }

  static double displayMediumTextSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 36.0;
    if (isTablet(context)) return 32.0;
    if (isSmallMobile(context)) return 22.0;
    return 24.0;
  }

  static double headlineTextSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 28.0;
    if (isSmallMobile(context)) return 22.0;
    return 24.0;
  }

  static double titleTextSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 22.0;
    if (isTablet(context)) return 20.0;
    if (isSmallMobile(context)) return 16.0;
    return 18.0;
  }

  static double bodyTextSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 18.0;
    if (isTablet(context)) return 16.0;
    return 14.0;
  }

  static double captionTextSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 17.0;
    if (isTablet(context)) return 15.0;
    return 14.0;
  }

  // Adaptive button sizes
  static double buttonHeight(BuildContext context) {
    if (isIOS(context)) return 50.0;
    if (isDesktop(context)) return 60.0;
    return 48.0;
  }

  static double buttonWidth(BuildContext context, {double mobileRatio = 0.8, double tabletRatio = 0.5, double desktopRatio = 0.3}) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) {
      return width * desktopRatio;
    } else if (isTablet(context)) {
      return width * tabletRatio;
    } else {
      return width * mobileRatio;
    }
  }

  static double iconButtonSize(BuildContext context) {
    if (isDesktop(context)) return 48.0;
    if (isTablet(context)) return 44.0;
    return 40.0;
  }

  // Adaptive icon sizes
  static double smallIconSize(BuildContext context) {
    if (isDesktop(context)) return 20.0;
    if (isTablet(context)) return 18.0;
    return 16.0;
  }

  static double mediumIconSize(BuildContext context) {
    if (isDesktop(context)) return 34.0;
    if (isTablet(context)) return 30.0;
    return 26.0;
  }

  static double largeIconSize(BuildContext context) {
    if (isDesktop(context)) return 36.0;
    if (isTablet(context)) return 32.0;
    return 24.0;
  }

  // Image and logo sizes
  static double smallLogoSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 80.0;
    if (isTablet(context)) return 60.0;
    return 40.0;
  }

  static double mediumLogoSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 150.0;
    if (isTablet(context)) return 120.0;
    return 80.0;
  }

  static double largeLogoSize(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 200.0;
    if (isTablet(context)) return 150.0;
    return 100.0;
  }

  static double coverImageHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isDesktop(context)) return height * 0.4;
    if (isTablet(context)) return height * 0.35;
    return height * 0.3;
  }

  // Card sizes
  static double cardHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isDesktop(context)) return 200.0;
    if (isTablet(context)) return 180.0;
    if (height < 600) return 120.0;
    return 150.0;
  }

  static double cardWidth(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return 300.0;
    if (isTablet(context)) return 250.0;
    return width * 0.8;
  }

  // Form field sizes
  static double textFieldHeight(BuildContext context) {
    if (isDesktop(context)) return 60.0;
    if (isTablet(context)) return 55.0;
    return 50.0;
  }

  static double textFieldWidth(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return width * 0.4;
    if (isTablet(context)) return width * 0.6;
    return width * 0.9;
  }

  // Grid layout methods
  static int gridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    if (isSmallMobile(context)) return 1;
    return 2;
  }

  static double gridChildAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 1.2;
    if (isTablet(context)) return 1.1;
    return 1.0;
  }

  static double gridSpacing(BuildContext context) {
    if (isDesktop(context)) return 20.0;
    if (isTablet(context)) return 16.0;
    return 12.0;
  }

  // Dialog and modal sizes
  static double dialogWidth(BuildContext context) {
    final width = screenWidth(context);
    
    if (isDesktop(context)) return width * 0.4;
    if (isTablet(context)) return width * 0.6;
    return width * 0.9;
  }

  static double dialogHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isDesktop(context)) return height * 0.6;
    if (isTablet(context)) return height * 0.7;
    return height * 0.8;
  }

  static double bottomSheetHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isDesktop(context)) return height * 0.5;
    if (isTablet(context)) return height * 0.6;
    return height * 0.7;
  }

  // Navigation and app bar sizes
  static double appBarHeight(BuildContext context) {
    if (isDesktop(context)) return 80.0;
    if (isTablet(context)) return 70.0;
    return kToolbarHeight;
  }

  static double bottomNavBarHeight(BuildContext context) {
    if (isIOS(context)) return 90.0;
    if (isDesktop(context)) return 70.0;
    return 60.0;
  }

  static double navBarIconSize(BuildContext context) {
    if (isDesktop(context)) return 28.0;
    if (isTablet(context)) return 24.0;
    return 20.0;
  }

  // Animation durations (adaptive based on platform)
  static Duration shortAnimationDuration(BuildContext context) {
    if (isIOS(context)) return const Duration(milliseconds: 300);
    return const Duration(milliseconds: 200);
  }

  static Duration mediumAnimationDuration(BuildContext context) {
    if (isIOS(context)) return const Duration(milliseconds: 500);
    return const Duration(milliseconds: 300);
  }

  static Duration longAnimationDuration(BuildContext context) {
    if (isIOS(context)) return const Duration(milliseconds: 800);
    return const Duration(milliseconds: 500);
  }

  // Border radius methods
  static double smallBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 12.0;
    if (isTablet(context)) return 10.0;
    return 8.0;
  }

  static double mediumBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 16.0;
    if (isTablet(context)) return 14.0;
    return 12.0;
  }

  static double largeBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 20.0;
    if (isTablet(context)) return 18.0;
    return 16.0;
  }

  // Elevation and shadow
  static double smallElevation(BuildContext context) {
    if (isDesktop(context)) return 4.0;
    if (isTablet(context)) return 3.0;
    return 2.0;
  }

  static double mediumElevation(BuildContext context) {
    if (isDesktop(context)) return 8.0;
    if (isTablet(context)) return 6.0;
    return 4.0;
  }

  static double largeElevation(BuildContext context) {
    if (isDesktop(context)) return 16.0;
    if (isTablet(context)) return 12.0;
    return 8.0;
  }

  // Responsive font styles with platform adaptation
  static TextStyle adaptiveHeadlineStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: headlineTextSize(context),
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
      letterSpacing: isIOS(context) ? -0.5 : 0.0,
    );
  }

  static TextStyle adaptiveTitleStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: titleTextSize(context),
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      letterSpacing: isIOS(context) ? -0.3 : 0.0,
    );
  }

  static TextStyle adaptiveBodyStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: bodyTextSize(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      letterSpacing: isIOS(context) ? -0.1 : 0.0,
    );
  }

  static TextStyle adaptiveCaptionStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: captionTextSize(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      letterSpacing: isIOS(context) ? -0.1 : 0.0,
    );
  }

  // Safe area insets
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: padding.top,
      bottom: padding.bottom,
      left: padding.left,
      right: padding.right,
    );
  }

  // Keyboard-aware methods
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  // Aspect ratio helpers
  static double adaptiveAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 16/9;
    if (isTablet(context)) return 4/3;
    return 1.0;
  }

  // Percentage-based sizing
  static double widthPercentage(BuildContext context, double percentage) {
    return screenWidth(context) * percentage;
  }

  static double heightPercentage(BuildContext context, double percentage) {
    return screenHeight(context) * percentage;
  }

  // Minimum and maximum constraints
  static double constrainedWidth(BuildContext context, {double min = 0, double max = double.infinity}) {
    final width = screenWidth(context);
    return width.clamp(min, max);
  }

  static double constrainedHeight(BuildContext context, {double min = 0, double max = double.infinity}) {
    final height = screenHeight(context);
    return height.clamp(min, max);
  }
}