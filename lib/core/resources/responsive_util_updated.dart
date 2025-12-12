import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  // Modern breakpoints based on common device categories
  static const double _mobileBreakpoint = 600;      // Phones
  static const double _tabletBreakpoint = 900;      // Tablets
  static const double _desktopBreakpoint = 1200;    // Small desktops
  static const double _largeDesktopBreakpoint = 1600; // Large desktops

  // Screen size detection methods
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static Orientation orientation(BuildContext context) => MediaQuery.of(context).orientation;

  // Modern device type detection with better breakpoints
  static bool isSmallMobile(BuildContext context) => screenWidth(context) < 375;
  static bool isMediumMobile(BuildContext context) => screenWidth(context) >= 375 && screenWidth(context) < 480;
  static bool isLargeMobile(BuildContext context) => screenWidth(context) >= 480 && screenWidth(context) < _mobileBreakpoint;
  static bool isMobile(BuildContext context) => screenWidth(context) < _mobileBreakpoint;
  static bool isTablet(BuildContext context) => screenWidth(context) >= _mobileBreakpoint && screenWidth(context) < _desktopBreakpoint;
  static bool isSmallTablet(BuildContext context) => screenWidth(context) >= _mobileBreakpoint && screenWidth(context) < _tabletBreakpoint;
  static bool isLargeTablet(BuildContext context) => screenWidth(context) >= _tabletBreakpoint && screenWidth(context) < _desktopBreakpoint;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= _desktopBreakpoint;
  static bool isSmallDesktop(BuildContext context) => screenWidth(context) >= _desktopBreakpoint && screenWidth(context) < _largeDesktopBreakpoint;
  static bool isLargeDesktop(BuildContext context) => screenWidth(context) >= _largeDesktopBreakpoint;

  // Platform detection
  static bool isIOS(BuildContext context) => Theme.of(context).platform == TargetPlatform.iOS;
  static bool isAndroid(BuildContext context) => Theme.of(context).platform == TargetPlatform.android;
  static bool isWeb(BuildContext context) => kIsWeb;
  static bool isMobileWeb(BuildContext context) => kIsWeb && isMobile(context);

  // Enhanced responsive padding with better scaling
  static EdgeInsets screenPadding(BuildContext context) {
    final width = screenWidth(context);
    
    if (isLargeDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 32);
    } else if (isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.15, vertical: 24);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.08, vertical: 20);
    } else if (isLargeMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else if (isMediumMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  static EdgeInsets contentPadding(BuildContext context) {
    final width = screenWidth(context);
    
    if (isLargeDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.25);
    } else if (isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.2);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: width * 0.12);
    } else if (isLargeMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20);
    }
  }

  static EdgeInsets sectionPadding(BuildContext context) {
    final height = screenHeight(context);
    
    if (height < 600) {
      return const EdgeInsets.symmetric(vertical: 20);
    } else if (height < 800) {
      return const EdgeInsets.symmetric(vertical: 32);
    } else if (height < 1000) {
      return const EdgeInsets.symmetric(vertical: 40);
    } else {
      return const EdgeInsets.symmetric(vertical: 48);
    }
  }

  static EdgeInsets cardPadding(BuildContext context) {
    if (isLargeDesktop(context)) {
      return const EdgeInsets.all(28);
    } else if (isDesktop(context)) {
      return const EdgeInsets.all(24);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    } else if (isLargeMobile(context)) {
      return const EdgeInsets.all(18);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  // Enhanced responsive spacing
  static double smallSpacing(BuildContext context) {
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 12;
    return 8;
  }

  static double mediumSpacing(BuildContext context) {
    if (isLargeDesktop(context)) return 32;
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 20;
    if (isLargeMobile(context)) return 16;
    return 12;
  }

  static double largeSpacing(BuildContext context) {
    if (isLargeDesktop(context)) return 48;
    if (isDesktop(context)) return 36;
    if (isTablet(context)) return 28;
    if (isLargeMobile(context)) return 24;
    return 20;
  }

  static double extraLargeSpacing(BuildContext context) {
    final height = screenHeight(context);
    
    if (height < 600) return 32;
    if (height < 800) return 48;
    if (height < 1000) return 64;
    return 80;
  }

  // Modern responsive text sizes with better scaling
  static double displayLargeTextSize(BuildContext context) {
    if (isLargeDesktop(context)) return 64;
    if (isDesktop(context)) return 56;
    if (isTablet(context)) return 48;
    if (isLargeMobile(context)) return 40;
    if (isMediumMobile(context)) return 32;
    return 28;
  }

  static double displayMediumTextSize(BuildContext context) {
    if (isLargeDesktop(context)) return 48;
    if (isDesktop(context)) return 40;
    if (isTablet(context)) return 36;
    if (isLargeMobile(context)) return 32;
    if (isMediumMobile(context)) return 28;
    return 24;
  }

  static double headlineTextSize(BuildContext context) {
    if (isLargeDesktop(context)) return 40;
    if (isDesktop(context)) return 36;
    if (isTablet(context)) return 32;
    if (isLargeMobile(context)) return 28;
    if (isMediumMobile(context)) return 24;
    return 22;
  }

  static double titleTextSize(BuildContext context) {
    if (isLargeDesktop(context)) return 28;
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 22;
    if (isLargeMobile(context)) return 20;
    if (isMediumMobile(context)) return 18;
    return 16;
  }

  static double bodyTextSize(BuildContext context) {
    if (isLargeDesktop(context)) return 20;
    if (isDesktop(context)) return 18;
    if (isTablet(context)) return 17;
    if (isLargeMobile(context)) return 16;
    return 14;
  }

  static double captionTextSize(BuildContext context) {
    if (isLargeDesktop(context)) return 18;
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 15;
    return 14;
  }

  // Adaptive button sizes with better platform optimization
  static double buttonHeight(BuildContext context) {
    if (isLargeDesktop(context)) return 64;
    if (isDesktop(context)) return 56;
    if (isTablet(context)) return 52;
    if (isIOS(context)) return 50;
    return 48;
  }

  static double buttonWidth(BuildContext context, {double mobileRatio = 0.9, double tabletRatio = 0.6, double desktopRatio = 0.3}) {
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
    if (isLargeDesktop(context)) return 56;
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 44;
    return 40;
  }

  // Adaptive icon sizes
  static double smallIconSize(BuildContext context) {
    if (isLargeDesktop(context)) return 24;
    if (isDesktop(context)) return 22;
    if (isTablet(context)) return 20;
    return 18;
  }

  static double mediumIconSize(BuildContext context) {
    if (isLargeDesktop(context)) return 36;
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 28;
    return 24;
  }

  static double largeIconSize(BuildContext context) {
    if (isLargeDesktop(context)) return 48;
    if (isDesktop(context)) return 42;
    if (isTablet(context)) return 36;
    return 32;
  }

  // Image and logo sizes with better scaling
  static double smallLogoSize(BuildContext context) {
    if (isLargeDesktop(context)) return 120;
    if (isDesktop(context)) return 100;
    if (isTablet(context)) return 80;
    return 60;
  }

  static double mediumLogoSize(BuildContext context) {
    if (isLargeDesktop(context)) return 200;
    if (isDesktop(context)) return 160;
    if (isTablet(context)) return 120;
    return 80;
  }

  static double largeLogoSize(BuildContext context) {
    if (isLargeDesktop(context)) return 280;
    if (isDesktop(context)) return 240;
    if (isTablet(context)) return 180;
    return 120;
  }

  static double coverImageHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isLargeDesktop(context)) return height * 0.5;
    if (isDesktop(context)) return height * 0.45;
    if (isTablet(context)) return height * 0.4;
    if (isLargeMobile(context)) return height * 0.35;
    return height * 0.3;
  }

  // Enhanced card sizes
  static double cardHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isLargeDesktop(context)) return 280;
    if (isDesktop(context)) return 240;
    if (isTablet(context)) return 200;
    if (height < 600) return 140;
    if (height < 800) return 160;
    return 180;
  }

  static double cardWidth(BuildContext context) {
    final width = screenWidth(context);
    
    if (isLargeDesktop(context)) return 400;
    if (isDesktop(context)) return 350;
    if (isTablet(context)) return 300;
    if (isLargeMobile(context)) return width * 0.85;
    return width * 0.9;
  }

  // Form field sizes with better accessibility
  static double textFieldHeight(BuildContext context) {
    if (isLargeDesktop(context)) return 68;
    if (isDesktop(context)) return 60;
    if (isTablet(context)) return 56;
    return 52;
  }

  static double textFieldWidth(BuildContext context) {
    final width = screenWidth(context);
    
    if (isLargeDesktop(context)) return width * 0.3;
    if (isDesktop(context)) return width * 0.4;
    if (isTablet(context)) return width * 0.6;
    if (isLargeMobile(context)) return width * 0.8;
    return width * 0.9;
  }

  // Enhanced grid layout methods
  static int gridCrossAxisCount(BuildContext context) {
    if (isLargeDesktop(context)) return 5;
    if (isDesktop(context)) return 4;
    if (isLargeTablet(context)) return 3;
    if (isTablet(context)) return 2;
    if (isLargeMobile(context)) return 2;
    return 1;
  }

  static double gridChildAspectRatio(BuildContext context) {
    if (isLargeDesktop(context)) return 1.3;
    if (isDesktop(context)) return 1.25;
    if (isTablet(context)) return 1.1;
    return 1.0;
  }

  static double gridSpacing(BuildContext context) {
    if (isLargeDesktop(context)) return 24;
    if (isDesktop(context)) return 20;
    if (isTablet(context)) return 16;
    return 12;
  }

  // Dialog and modal sizes with better proportions
  static double dialogWidth(BuildContext context) {
    final width = screenWidth(context);
    
    if (isLargeDesktop(context)) return width * 0.3;
    if (isDesktop(context)) return width * 0.4;
    if (isTablet(context)) return width * 0.6;
    if (isLargeMobile(context)) return width * 0.85;
    return width * 0.9;
  }

  static double dialogHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isLargeDesktop(context)) return height * 0.5;
    if (isDesktop(context)) return height * 0.6;
    if (isTablet(context)) return height * 0.7;
    return height * 0.75;
  }

  static double bottomSheetHeight(BuildContext context) {
    final height = screenHeight(context);
    
    if (isLargeDesktop(context)) return height * 0.4;
    if (isDesktop(context)) return height * 0.5;
    if (isTablet(context)) return height * 0.6;
    return height * 0.7;
  }

  // Navigation and app bar sizes with better scaling
  static double appBarHeight(BuildContext context) {
    if (isLargeDesktop(context)) return 96;
    if (isDesktop(context)) return 88;
    if (isTablet(context)) return 76;
    return kToolbarHeight;
  }

  static double bottomNavBarHeight(BuildContext context) {
    if (isLargeDesktop(context)) return 80;
    if (isDesktop(context)) return 72;
    if (isIOS(context)) return 90;
    return 64;
  }

  static double navBarIconSize(BuildContext context) {
    if (isLargeDesktop(context)) return 32;
    if (isDesktop(context)) return 28;
    if (isTablet(context)) return 24;
    return 20;
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
    if (isLargeDesktop(context)) return 16;
    if (isDesktop(context)) return 14;
    if (isTablet(context)) return 12;
    return 8;
  }

  static double mediumBorderRadius(BuildContext context) {
    if (isLargeDesktop(context)) return 20;
    if (isDesktop(context)) return 18;
    if (isTablet(context)) return 16;
    return 12;
  }

  static double largeBorderRadius(BuildContext context) {
    if (isLargeDesktop(context)) return 28;
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 20;
    return 16;
  }

  // Elevation and shadow
  static double smallElevation(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  static double mediumElevation(BuildContext context) {
    if (isDesktop(context)) return 8;
    if (isTablet(context)) return 6;
    return 4;
  }

  static double largeElevation(BuildContext context) {
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 12;
    return 8;
  }

  // Enhanced responsive font styles with better platform adaptation
  static TextStyle adaptiveHeadlineStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: headlineTextSize(context),
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color,
      letterSpacing: isIOS(context) ? -0.5 : -0.3,
      height: 1.2,
    );
  }

  static TextStyle adaptiveTitleStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: titleTextSize(context),
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      letterSpacing: isIOS(context) ? -0.3 : -0.1,
      height: 1.3,
    );
  }

  static TextStyle adaptiveBodyStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: bodyTextSize(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      letterSpacing: isIOS(context) ? -0.1 : 0.0,
      height: 1.5,
    );
  }

  static TextStyle adaptiveCaptionStyle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: captionTextSize(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      letterSpacing: isIOS(context) ? -0.1 : 0.0,
      height: 1.4,
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
    if (isLargeDesktop(context)) return 16/9;
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

  // New methods for advanced responsive design
  static double getScaledSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    
    if (width < 375) return baseSize * 0.8;      // Small mobile
    if (width < 600) return baseSize * 0.9;      // Mobile
    if (width < 900) return baseSize;            // Tablet
    if (width < 1200) return baseSize * 1.1;     // Small desktop
    if (width < 1600) return baseSize * 1.2;     // Desktop
    return baseSize * 1.3;                       // Large desktop
  }

  static bool isLandscape(BuildContext context) => orientation(context) == Orientation.landscape;
  static bool isPortrait(BuildContext context) => orientation(context) == Orientation.portrait;

  // Method to get the current breakpoint name for debugging
  static String currentBreakpoint(BuildContext context) {
    if (isSmallMobile(context)) return 'Small Mobile';
    if (isMediumMobile(context)) return 'Medium Mobile';
    if (isLargeMobile(context)) return 'Large Mobile';
    if (isSmallTablet(context)) return 'Small Tablet';
    if (isLargeTablet(context)) return 'Large Tablet';
    if (isSmallDesktop(context)) return 'Small Desktop';
    if (isLargeDesktop(context)) return 'Large Desktop';
    return 'Unknown';
  }

  // Method to check if device has notch or dynamic island
  static bool hasTopNotch(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.top > 0;
  }

  // Method to check if device has bottom safe area (like iPhone home indicator)
  static bool hasBottomSafeArea(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.bottom > 0;
  }
}