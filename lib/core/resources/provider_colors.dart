// import 'package:flutter/material.dart';
// import '../config/app_configt.dart';
// import '../resources/colorfile.dart';

// class ColorNotifier with ChangeNotifier {
//   bool isDark;
//   final AppConst appConstProvider;

//   ColorNotifier(this.appConstProvider) : isDark = appConstProvider.isDarkMode;

//   Color _getColor(Color lightColor, Color darkColor) {
//     return isDark ? darkColor : lightColor;
//   }

//   // Color mapping for theme-based colors
//   Color get getPrimaryColor => _getColor(primaryColor, darkPrimaryColor);
//   Color get getBgColor => _getColor(bgColor, darkBgColor);
//   Color get getBorderColor => _getColor(bordercolor, darkbordercolor);
//   Color get getIconColor => _getColor(iconcolor, darkiconcolor);
//   Color get getContainer => _getColor(continercolor, darkcontinercolor);
//   Color get getContainerShadow => _getColor(continercolo1r, darkcontinercolo1r);

//   Color get getTextColor1 => _getColor(textdark, textwhite);
//   Color get getMainText => _getColor(themblack, themgrey);
//   Color get getMainGrey => _getColor(themblackgrey, themlitegrey);

//   Color get getBackNotiColor => _getColor(notibackcolor, darkbackcolor);
//   Color get getSubColors => _getColor(notisubcolor, darksubcolor);
//   Color get getBackgroundColor => _getColor(lightBackgroundColor, darkBackgroundColor);
//   Color get getBackTextColors => _getColor(backtextcolor, darktextcolor);
//   Color get getFilTextColors => _getColor(filtexcolor, darkfilcolor);
//   Color get getDolorColors => _getColor(dolorcolor, darkdolorcolor);
//   Color get getMainTextColor => _getColor(themgrey1, themblack1);

//   /// This will notify the listeners, which in turn updates the theme
//   void toggleTheme() {
//     isDark = !isDark;
//     appConstProvider.toggleTheme();  // Sync the theme with the AppConst class
//     notifyListeners();  // Notify listeners to rebuild with the updated theme
//   }
// }
