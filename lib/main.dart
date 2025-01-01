import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_buddy/providers/app/app_settings_provider.dart';
import 'package:task_buddy/providers/my_bottom_nav_provider.dart';
import 'package:task_buddy/screens/my_bottom_navigation_bar.dart';
import 'package:task_buddy/screens/task/add_task.dart';
import 'package:task_buddy/screens/task/task_details.dart';
import 'package:task_buddy/screens/task/task_list_screen.dart';
import 'package:task_buddy/utils/database/database_helper.dart';
import 'package:task_buddy/utils/my_theme/my_theme.dart';
import 'package:task_buddy/utils/utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late final DatabaseHelper dbHelper;
final Utils utils = Utils();

Future<void> main() async {
  await utils.initRun();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appSettingsNotifierProvider)['themeMode'];
    final appLightThemeColor =
        ref.watch(appSettingsNotifierProvider)['appLightThemeColor'];
    final appDarkThemeColor =
        ref.watch(appSettingsNotifierProvider)['appDarkThemeColor'];

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color.lerp(appLightThemeColor, Colors.white, 0.5),
      colorScheme: ColorScheme.fromSeed(seedColor: appLightThemeColor),
      primaryColor: appLightThemeColor,
      appBarTheme: AppBarTheme(
        backgroundColor: appLightThemeColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardTheme(
        color: Color.lerp(appLightThemeColor, Colors.white, 0.7),
        shadowColor: Color.lerp(appLightThemeColor, Colors.white, 0.7),
        surfaceTintColor: Color.lerp(appLightThemeColor, Colors.white, 0.7),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
            fontSize: 16),
        bodyMedium: TextStyle(
            color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
            fontSize: 14),
        titleLarge: TextStyle(
            color: Color.lerp(appLightThemeColor, Colors.black, 0.7),
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appLightThemeColor, // Set default background color for light theme
        contentTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600), // Text color for light theme
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        iconColor: Colors.white,
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        prefixStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        suffixStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      iconTheme:  IconThemeData(color: appLightThemeColor),
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 10,
          backgroundColor: appLightThemeColor,
          foregroundColor: Colors.white),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: appDarkThemeColor,
      scaffoldBackgroundColor: Color.lerp(appDarkThemeColor, Colors.black, 0.5),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.lerp(appDarkThemeColor, Colors.black, 0.6),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appDarkThemeColor, // Set default background color for dark theme
        contentTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600), // Text color for dark theme
      ),
      cardTheme: CardTheme(
        color: Color.lerp(appDarkThemeColor, Colors.black, 0.7),
        elevation: 10,
        surfaceTintColor: appDarkThemeColor,
        shadowColor: appDarkThemeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        titleLarge: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 10,
        backgroundColor: Colors.black,
        foregroundColor: appDarkThemeColor,
      ),
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
