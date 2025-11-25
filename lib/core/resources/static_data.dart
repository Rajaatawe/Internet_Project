// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:internet_application_project/core/resources/provider_colors.dart';
// // import 'package:integration_example/core/resources/provider_colors.dart';



// //..............Fonts....................
// const String mainFontFamily = "Tajawal";
// const String secondaryFont = "Avenir";


// //..............Colors....................


// const Color appPrimaryColor = Color.fromARGB(255, 64, 160, 200);
// const secondaryColor = Color.fromARGB(255, 238, 249, 255);
// const Color appWhiteColor = Color(0xffffffff);
// const Color appGreyColor = Color(0xffa1a1ae);
// const Color lightGreyColor = Color(0xfff2f2f5);
//  Color errorColor = const Color.fromARGB(255, 231, 76, 60);
//  Color successColor = const Color.fromARGB(255, 46, 204, 113);
//  const lightBlueColor= Color(0xFF1A6EA0);
//  const darkBlueColor= Color(0xFF144870);
//  Color lightGreyBorder = Colors.grey.shade300;
//  Color lightBrownColor = const Color(0xD8F8DDD4);
//  Color yellowColor= const Color.fromARGB(255, 253, 255, 0);


// const Color facebookColor = Color.fromARGB(249, 7, 80, 243);
//  const Color instagramColor =Colors.pink;
//  const Color twitterColor = Colors.blue;
// const Color snapChatColor = Colors.amber;
// const Color whatsappColor = Colors.green;



// //..............TextStyle....................


// //main color (primary)
// TextStyle mainPrimaryTextStyle =   TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w800,color: appPrimaryColor,fontFamily: mainFontFamily);
// TextStyle mediumPrimaryTextStyle =  TextStyle(fontSize: 16.sp.clamp(0, 18), fontWeight: FontWeight.w500, color: appPrimaryColor, fontFamily: mainFontFamily);
// TextStyle smallPrimaryTextStyle =  TextStyle(fontSize: 14.sp,color: appPrimaryColor,fontFamily: mainFontFamily);

// // black
// TextStyle bigBlackTextStyle =    TextStyle(fontSize: 26.sp,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: mainFontFamily);
// TextStyle mainBlackTextStyle =   TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w600,color: Colors.black,fontFamily: mainFontFamily);
// TextStyle mediumBlackTextStyle =  TextStyle(fontSize: 16.sp,color: Colors.black,fontWeight: FontWeight.w400,fontFamily: mainFontFamily, overflow: TextOverflow.ellipsis);
// TextStyle smallBlackTextStyle =  TextStyle(fontSize: 14.sp,color: Colors.black,fontFamily: mainFontFamily);

// // grey
// TextStyle bigGreyTextStyle =    TextStyle(fontSize: 26.sp,fontWeight: FontWeight.bold,color: appGreyColor,fontFamily: mainFontFamily);
// TextStyle mainGreyTextStyle =   TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w800,color: appGreyColor,fontFamily: mainFontFamily);
// TextStyle mediumGreyTextStyle = TextStyle(fontSize: 16.sp, color: appGreyColor, fontFamily: mainFontFamily, overflow: TextOverflow.ellipsis);
// TextStyle smallGreyTextStyle =  TextStyle(fontSize: 14.sp,color: appGreyColor,fontFamily: mainFontFamily);

// // white
// TextStyle bigWhiteTextStyle =    TextStyle(fontSize: 26.sp,fontWeight: FontWeight.bold,color: appWhiteColor,fontFamily: mainFontFamily);
// TextStyle mainWhiteTextStyle =   TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w800,color: appWhiteColor,fontFamily: mainFontFamily);
// TextStyle mediumWhiteTextStyle =  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: appWhiteColor, fontFamily: mainFontFamily);
// TextStyle smallWhiteTextStyle =  TextStyle(fontSize: 14.sp, color: appWhiteColor, fontFamily: mainFontFamily);


// TextStyle bigTextStyle =    TextStyle(fontSize: 26.sp,fontWeight: FontWeight.bold,fontFamily: mainFontFamily);
// TextStyle mainTextStyle =   TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w800,fontFamily: mainFontFamily);
// TextStyle mediumTextStyle =  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500,fontFamily: mainFontFamily);
// TextStyle smallTextStyle =  TextStyle(fontSize: 14.sp, fontFamily: mainFontFamily);

// TextStyle smallHeaderTextStyle = TextStyle(fontFamily: mainFontFamily, fontSize: 15.sp, color: appPrimaryColor,);
// TextStyle bigHeaderTextStyle = TextStyle(color: appPrimaryColor, fontSize: 18.sp, fontWeight: FontWeight.w400);




// //..............BoxShadow....................

// List<BoxShadow>? boxShadow =   [
//   BoxShadow(
//     color: Colors.black.withOpacity(0.2),
//     blurRadius: 10,
//     spreadRadius: 2,
//     offset: const Offset(0, 6),
//   ),
// ];


// //...........Gradient........................
//  LinearGradient  basicGradient = const LinearGradient(
//    begin: Alignment.centerRight, // 270deg = from right to left
//    end: Alignment.centerLeft,
//    colors: [
//      Colors.transparent,
//      Color(0xFF54423D), // Equivalent to #54423D
//    ],
//  );

//  LinearGradient advancedGradient =  LinearGradient(
//      begin: Alignment.topRight,
//      end: Alignment.topLeft,
//      colors: [
//        appPrimaryColor,
//        appPrimaryColor.withOpacity(0.8),
//        appPrimaryColor.withOpacity(0.75),
//        appPrimaryColor.withOpacity(0.75),
//        appPrimaryColor.withOpacity(0.8),
//        appPrimaryColor
//      ]);

// LinearGradient advancedGradientReversed =  LinearGradient(
//   end: Alignment.centerRight,
//   begin: Alignment.centerLeft,
//   colors: [
//     appPrimaryColor,
//     appPrimaryColor.withOpacity(0.8),
//     appPrimaryColor.withOpacity(0.75),
//     appPrimaryColor.withOpacity(0.75),
//     appPrimaryColor.withOpacity(0.8),
//     appPrimaryColor
//   ],
// );


// LinearGradient advancedBlueGradient =  const  LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [
//     Color(0xFF1A6EA0),
//     Color(0xFF144870),
//   ],
// );

// Decoration boxDecoration = BoxDecoration(
//     borderRadius: const BorderRadius.all(Radius.circular(20)),
//     color: notifier!.getContainer,
//     boxShadow: boxShadow,
// );

// Border mainContainerBorder =
// Border.all(color: Colors.black54, width: 1);


// //const value
//  const double padding = 15;


// // *****************************************
// ColorNotifier? notifier;


