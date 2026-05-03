import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

import 'providers/auth_provider.dart';
import 'providers/room_provider.dart';
import 'providers/task_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/streak_provider.dart';
import 'providers/social_provider.dart';
import 'providers/fairness_provider.dart';
import 'providers/duty_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/roomie_roast_premium_ui_themes.dart';

class RoomieRoastApp extends StatelessWidget {
  const RoomieRoastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RoomProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AnalyticsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => StreakProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SocialProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => FairnessProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DutyProvider(),
        ),
      ],

      child:
          Consumer<ThemeProvider>(
        builder: (_, theme, __) {
          return MaterialApp(
            debugShowCheckedModeBanner:
                false,

            title: "Roomie Roast",

            theme: theme.theme,

            darkTheme:
                RoomieThemes.darkNeon,

            themeMode:
                theme.mode,

            initialRoute:
                AppRoutes.splash,

            routes:
                AppRoutes.routes,
          );
        },
      ),
    );
  }
}