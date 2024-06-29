import 'package:flutter/material.dart';
import 'package:geminichatapp/themes/dark_theme.dart';
import 'package:geminichatapp/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightmode.copyWith(
    textTheme: lightmode.textTheme.copyWith(
      bodyLarge: lightmode.textTheme.bodyLarge?.copyWith(
        fontFamily: 'Raleway',
      ),
    ),
  );

  ThemeProvider() {
    updateThemeFromSystem();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? lightmode : darkmode;
  }

  void updateThemeFromSystem() {
    final Brightness systemBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    _themeData = systemBrightness == Brightness.dark ? darkmode : lightmode;
    notifyListeners();
  }
}
