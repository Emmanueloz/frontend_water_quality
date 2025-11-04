// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeProvider(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _saveThemeToHive();
  }

  Future<void> _saveThemeToHive() async {
    final value = _themeMode.toString(); // "ThemeMode.dark" o "ThemeMode.light"
    await LocalStorageService.save(StorageKey.themeMode, value);
  }

  static Future<ThemeProvider> initialize() async {
    final storedValue = await LocalStorageService.get(StorageKey.themeMode);
    ThemeMode mode;

    if (storedValue == null) {
      mode = ThemeMode.light;
    } else if (storedValue.contains('dark')) {
      mode = ThemeMode.dark;
    } else if (storedValue.contains('light')) {
      mode = ThemeMode.light;
    } else {
      mode = ThemeMode.system;
    }

    return ThemeProvider(mode);
  }
}
