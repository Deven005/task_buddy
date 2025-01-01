import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_buddy/main.dart';

part 'app_settings_provider.g.dart';

@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  Map<String, dynamic> build() {
    return {
      'themeMode': utils.getIsDarkThemePreference() == true
          ? ThemeMode.dark
          : ThemeMode.light,
      'appLightThemeColor': utils.getAppLightThemeColorPreference(),
      'appDarkThemeColor': utils.getAppDarkThemeColorPreference(),
      'isNotificationEnabled': utils.getIsNotificationEnabledPreference(),
      'selectedSortBy': utils.getSelectedSortByPreference(),
    };
  }

  /// Toggles between light and dark app modes.
  Future<void> toggleTheme() async {
    final isDark = state['themeMode'] == ThemeMode.light ? true : false;
    await utils.saveIsDarkThemePreference(isDark);
    state = {...state, 'themeMode': isDark ? ThemeMode.dark : ThemeMode.light};
  }

  /// Updates the app's light primary color.
  Future<void> updateLightThemeColor(Color color) async {
    await utils.saveAppLightThemeColorPreference(color);
    state = {...state, 'appLightThemeColor': color};
  }

  /// Updates the app's dark primary color.
  Future<void> updateDarkThemeColor(Color color) async {
    await utils.saveAppDarkThemeColorPreference(color);
    state = {...state, 'appDarkThemeColor': color};
  }

  /// Toggles between notification app modes.
  Future<void> toggleNotificationEnable(bool isEnable) async {
    await utils.saveIsNotificationEnabledPreference(isEnable);
    state = {...state, 'isNotificationEnabled': isEnable};
  }

  /// Updates the app's Sort By.
  Future<void> updateSelectedSortBY(String sortBy) async {
    try {
      await utils.saveSelectedSortByPreference(sortBy);
      state = {...state, 'selectedSortBy': sortBy};
    } catch (e) {
      rethrow;
    }
  }
}
