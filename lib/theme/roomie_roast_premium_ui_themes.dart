import 'package:flutter/material.dart';

class RoomieThemes {
  static ThemeData base(
    Color seed, {
    Brightness brightness = Brightness.light,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xff161b22) : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? const Color(0xff0d1117) : Colors.grey.shade100,
      appBarTheme: AppBarTheme(
        backgroundColor: seed,
        foregroundColor: isDark ? Colors.black : Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: surfaceColor,
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        color: surfaceColor,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seed,
        foregroundColor: isDark ? Colors.black : Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xff0d1117) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }

  static ThemeData royalPurple = base(
    const Color(0xff7b61ff),
  );

  static ThemeData darkNeon = base(
    const Color(0xff00e5ff),
    brightness: Brightness.dark,
  );

  static ThemeData sunsetOrange = base(
    const Color(0xffff7043),
  );

  static ThemeData mintFresh = base(
    const Color(0xff00c896),
  );
}
