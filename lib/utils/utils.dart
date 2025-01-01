import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_buddy/main.dart';

import '../service/notification/notification_service.dart';
import 'database/database_helper.dart';

class Utils {
  String hiveAppSettingsBoxName = 'app-settings';

  initRun() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;
    await Hive.initFlutter();
    await Hive.openBox(hiveAppSettingsBoxName);
    // Initialize notifications
    await NotificationService.initialize();
  }

  logOutUser() async {
    (await Hive.openBox(hiveAppSettingsBoxName)).clear();
    await DatabaseHelper.instance.deleteDatabaseFile();
    utils.showSnackBar('Logout / Data delete is done!');
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy h:mm a')
        .format(dateTime.toLocal()); // Example: Sep 15, 2024 3:45 PM
  }

  String getDuration({required DateTime startTime, required DateTime endTime}) {
    final duration = endTime.difference(startTime);
    final days = duration.inDays;
    final hours = duration.inHours % 24; // Hours remaining after full days
    final minutes =
        duration.inMinutes % 60; // Minutes remaining after full hours

    // Building the result string based on available units
    String result = '';

    if (days > 0) result += '$days day${days > 1 ? 's' : ''} ';
    if (hours > 0 || days > 0) result += '$hours hour${hours > 1 ? 's' : ''} ';
    result += '$minutes minute${minutes > 1 ? 's' : ''}';

    return result;
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      // To make it more prominent
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      // Centering the SnackBar
      elevation: 10, // Adding a subtle shadow for better visibility
    ));
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Map priority to numerical values for sorting
  int priorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0; // Fallback for unexpected values
    }
  }

  Future<void> saveIsDarkThemePreference(bool isDarkTheme) async {
    await Hive.box(hiveAppSettingsBoxName).put('isDarkTheme', isDarkTheme);
  }

  bool getIsDarkThemePreference() {
    return Hive.box(hiveAppSettingsBoxName)
        .get('isDarkTheme', defaultValue: false);
  }

  Future<void> saveAppLightThemeColorPreference(Color lightColor) async {
    final box = await Hive.openBox(hiveAppSettingsBoxName);
    // Save RGBA components for Light Theme
    await box.put('appLightThemeColorR', lightColor.r.toInt());
    await box.put('appLightThemeColorG', lightColor.g.toInt());
    await box.put('appLightThemeColorB', lightColor.b.toInt());
    await box.put('appLightThemeColorA', lightColor.a.toInt());
  }

  Future<void> saveAppDarkThemeColorPreference(Color darkColor) async {
    final box = await Hive.openBox(hiveAppSettingsBoxName);

    // Save RGBA components for Dark Theme
    await box.put('appDarkThemeColorR', darkColor.r.toInt());
    await box.put('appDarkThemeColorG', darkColor.g.toInt());
    await box.put('appDarkThemeColorB', darkColor.b.toInt());
    await box.put('appDarkThemeColorA', darkColor.a.toInt());
  }

  Color getAppLightThemeColorPreference() {
    final box = Hive.box(hiveAppSettingsBoxName);
    // Retrieve the RGBA components for Light Theme (default: blue)
    int r = box.get('appLightThemeColorR', defaultValue: 0); // Blue color
    int g = box.get('appLightThemeColorG', defaultValue: 0);
    int b = box.get('appLightThemeColorB', defaultValue: 255); // Full blue
    int a = box.get('appLightThemeColorA', defaultValue: 255); // Fully opaque

    // Rebuild the color from the RGBA components
    return Color.fromARGB(a, r, g, b);
  }

  Color getAppDarkThemeColorPreference() {
    final box = Hive.box(hiveAppSettingsBoxName);
    // Retrieve the RGBA components for Dark Theme (default: black)
    int r = box.get('appDarkThemeColorR', defaultValue: 0); // Black color
    int g = box.get('appDarkThemeColorG', defaultValue: 0);
    int b = box.get('appDarkThemeColorB', defaultValue: 0); // Full black
    int a = box.get('appDarkThemeColorA', defaultValue: 255); // Fully opaque

    // Rebuild the color from the RGBA components
    return Color.fromARGB(a, r, g, b);
  }

  Future<void> saveIsNotificationEnabledPreference(bool isEnabled) async {
    await Hive.box(hiveAppSettingsBoxName)
        .put('isNotificationEnabled', isEnabled);
    await NotificationService().updateNotificationPermission(isEnabled);
  }

  bool getIsNotificationEnabledPreference() {
    return Hive.box(hiveAppSettingsBoxName)
        .get('isNotificationEnabled', defaultValue: true);
  }

  Future<void> saveSelectedSortByPreference(String selectedSortBy) async {
    await Hive.box(hiveAppSettingsBoxName)
        .put('selectedSortBy', selectedSortBy);
  }

  String getSelectedSortByPreference() {
    return Hive.box(hiveAppSettingsBoxName)
        .get('selectedSortBy', defaultValue: "title");
  }
}

extension CapitalizeFirstLetter on String {
  String get capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
