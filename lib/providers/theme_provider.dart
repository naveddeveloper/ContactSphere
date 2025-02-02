import 'package:contactsphere/utils/theme_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Variables
  ThemeMode _themeMode = ThemeMode.system;
  
  // Getter
  ThemeMode get themeMode => _themeMode;

  // Constructor
  ThemeProvider(){
    _initalizeTheme();
  }

  // Methods
  // Intialize the theme
  Future<void> _initalizeTheme() async {
    bool isDark = await ThemePreferences.getTheme();
    if (_themeMode != (isDark ? ThemeMode.dark : ThemeMode.light)) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  // Toggle between dark and light theme
  void toggleTheme() {
    // Only update if the theme mode is different
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      ThemePreferences.setTheme(false);  // Save light mode preference
    } else {
      _themeMode = ThemeMode.dark;
      ThemePreferences.setTheme(true);  // Save dark mode preference
    }
    notifyListeners();
  }

  // Set the theme mode explicitly
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {  // Only update if it's different
      _themeMode = mode;
      ThemePreferences.setTheme(_themeMode == ThemeMode.dark);
      notifyListeners();
    }
  }
}