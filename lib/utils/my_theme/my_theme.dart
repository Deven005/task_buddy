// import 'package:flutter/material.dart';
// import 'package:task_buddy/main.dart';
//
// // Define colors for Light and Dark themes dynamically using Hive values
// var appLightThemeColor = utils.getAppLightThemeColorPreference();
//
// var appDarkThemeColor = utils.getAppDarkThemeColorPreference();
//
// final lightTheme = ThemeData(
//   primarySwatch: Colors.blue,
//   brightness: Brightness.light,
//   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//   primaryColor: appLightThemeColor,
//   scaffoldBackgroundColor: Colors.white,
//   appBarTheme: AppBarTheme(
//     backgroundColor: appLightThemeColor,
//     iconTheme: const IconThemeData(color: Colors.white),
//     titleTextStyle: const TextStyle(
//         color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//   ),
//   cardTheme: CardTheme(
//     color: Colors.white,
//     elevation: 4,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   ),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
//     bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
//     titleLarge: TextStyle(
//         color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//   ),
//   iconTheme: const IconThemeData(color: Colors.blue),
//   useMaterial3: true,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//       elevation: 10,
//       backgroundColor: appLightThemeColor,
//       foregroundColor: Colors.white),
// );
//
// final darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: appDarkThemeColor,
//   scaffoldBackgroundColor: Colors.black,
//   appBarTheme: AppBarTheme(
//     backgroundColor: appDarkThemeColor,
//     iconTheme: const IconThemeData(color: Colors.white),
//     titleTextStyle: const TextStyle(
//         color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//   ),
//   cardTheme: CardTheme(
//     color: Colors.grey.shade800,
//     elevation: 4,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   ),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
//     bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
//     titleLarge: TextStyle(
//         color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//   ),
//   iconTheme: IconThemeData(color: appDarkThemeColor),
//   useMaterial3: true,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//       elevation: 10,
//       backgroundColor: Colors.black,
//       foregroundColor: appDarkThemeColor),
// );
