import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_buddy/providers/app/app_settings_provider.dart';
import 'package:task_buddy/screens/my_bottom_navigation_bar.dart';
import 'package:task_buddy/screens/task/add_task.dart';
import 'package:task_buddy/screens/task/task_details.dart';
import 'package:task_buddy/utils/database/database_helper.dart';
import 'package:task_buddy/utils/utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late final DatabaseHelper dbHelper;
final Utils utils = Utils();
late Color userSelectedColor;

Future<void> main() async {
  await utils.initRun();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsNotifierProvider);
    final themeMode = appSettings['themeMode'];
    final appLightThemeColor = appSettings['appLightThemeColor'];
    final appDarkThemeColor = appSettings['appDarkThemeColor'];
    userSelectedColor =
        themeMode == ThemeMode.light ? appLightThemeColor : appDarkThemeColor;

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor:
          Color.lerp(appLightThemeColor, Colors.white, 0.5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: appLightThemeColor,
        brightness: Brightness.light, // Matches ThemeData.brightness
      ),
      primaryColor: appLightThemeColor,
      chipTheme: ChipThemeData(
        backgroundColor: Color.lerp(appLightThemeColor, Colors.white, 0.8),
        selectedColor: appLightThemeColor,
        shadowColor: appLightThemeColor,
        elevation: 10,
        secondarySelectedColor:
            Color.lerp(appLightThemeColor, Colors.black, 0.5),
        labelStyle: GoogleFonts.openSans(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
          fontWeight: FontWeight.bold,
        ),
        secondaryLabelStyle: GoogleFonts.openSans(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.5),
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appLightThemeColor,
        iconTheme: IconThemeData(
            color: Color.lerp(appLightThemeColor, Colors.white, 0.8)),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: Color.lerp(appLightThemeColor, Colors.white, 0.7),
        shadowColor: Color.lerp(appLightThemeColor, Colors.grey, 0.3),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.openSans(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.openSans(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: GoogleFonts.robotoSlab(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.8),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.merriweather(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.6),
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appLightThemeColor,
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.raleway(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.6),
          fontWeight: FontWeight.w400,
        ),
        labelStyle: GoogleFonts.raleway(
          color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: appLightThemeColor,
        foregroundColor: Colors.white,
      ),
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color.lerp(appDarkThemeColor, Colors.black, 0.5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: appDarkThemeColor,
        brightness: Brightness.dark, // Matches ThemeData.brightness
      ),
      primaryColor: appDarkThemeColor,
      chipTheme: ChipThemeData(
        backgroundColor: Color.lerp(appDarkThemeColor, Colors.grey[900], 0.8),
        selectedColor: appDarkThemeColor,
        secondarySelectedColor:
        Color.lerp(appDarkThemeColor, Colors.grey[700], 0.5),
        labelStyle: GoogleFonts.openSans(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: GoogleFonts.openSans(
          color: Colors.white70,
          fontWeight: FontWeight.w400,
        ),
        shadowColor: Color.lerp(appDarkThemeColor, Colors.white70, 0.4), // Darker shadow
        surfaceTintColor: Color.lerp(appDarkThemeColor, Colors.grey[97], 0.7),
        elevation: 12, // Increased elevation for stronger shadow effect
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.lerp(appDarkThemeColor, Colors.black, 0.7),
        iconTheme: IconThemeData(
            color: Color.lerp(appDarkThemeColor, Colors.white, 0.8)),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: Color.lerp(appDarkThemeColor, Colors.grey[900], 0.7),
        shadowColor: Color.lerp(appDarkThemeColor, Colors.black, 0.3),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.openSans(
          color: Color.lerp(appDarkThemeColor, Colors.white, 0.8),
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.openSans(
          color: Color.lerp(appDarkThemeColor, Colors.white, 0.7),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: GoogleFonts.robotoSlab(
          color: Color.lerp(appDarkThemeColor, Colors.white, 0.9),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.merriweather(
          color: Color.lerp(appDarkThemeColor, Colors.white, 0.8),
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appDarkThemeColor,
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.raleway(
          color: Color.lerp(appDarkThemeColor, Colors.white, 0.7),
          fontWeight: FontWeight.w400,
        ),
        labelStyle: GoogleFonts.raleway(
          color: Color.lerp(appDarkThemeColor, Colors.white, 0.8),
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: appDarkThemeColor,
        foregroundColor: Colors.white,
      ),
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Task Buddy',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyBottomNavigationBar(),
        '/add-update-task': (context) => const AddTaskScreen(),
        '/task-details': (context) => const TaskDetailsScreen(),
      },
    );
  }
}
