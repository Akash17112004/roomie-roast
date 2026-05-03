import 'package:flutter/material.dart';

class RoomieThemes {
  static ThemeData base(Color seed) {
    return ThemeData(
      useMaterial3: true,

      colorScheme:
          ColorScheme.fromSeed(
        seedColor: seed,
      ),

      scaffoldBackgroundColor:
          Colors.grey.shade100,

      appBarTheme: AppBarTheme(
        backgroundColor: seed,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        elevation: 6,
        color: Colors.white,
        shadowColor: Colors.black12,
        margin:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  20),
        ),
      ),

      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor:
              Colors.white,
          minimumSize:
              const Size(
                  double.infinity,
                  54),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                    16),
          ),
        ),
      ),

      floatingActionButtonTheme:
          FloatingActionButtonThemeData(
        backgroundColor: seed,
        foregroundColor:
            Colors.white,
      ),
    );
  }

  static ThemeData royalPurple =
      base(
    const Color(0xff7b61ff),
  );

  static ThemeData darkNeon =
      base(
    const Color(0xff00e5ff),
  ).copyWith(
    scaffoldBackgroundColor:
        Colors.black,
    cardTheme: const CardThemeData(
      color: Color(0xff1c1c1c),
    ),
  );

  static ThemeData sunsetOrange =
      base(
    const Color(0xffff7043),
  );

  static ThemeData mintFresh =
      base(
    const Color(0xff00c896),
  );
}