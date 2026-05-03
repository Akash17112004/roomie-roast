import 'package:flutter/material.dart';
import '../theme/roomie_roast_premium_ui_themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;

  int currentTheme = 0;

  List<ThemeData> themes = [
    RoomieThemes.royalPurple,
    RoomieThemes.darkNeon,
    RoomieThemes.sunsetOrange,
    RoomieThemes.mintFresh,
  ];

  ThemeData get theme => themes[currentTheme];

  void switchTheme(int index) {
    currentTheme = index;
    notifyListeners();
  }

  void toggleDarkMode() {
    mode =
        mode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

    notifyListeners();
  }
}