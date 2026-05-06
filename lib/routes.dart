import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/room/room_setup_screen.dart';
class AppRoutes {
  static const splash = "/";
  static const login = "/login";
  static const signup = "/signup";
  static const home = "/home";
  static const roomSetup = "/room-setup";
  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    home: (_) => const HomeScreen(),
    roomSetup: (_) => const RoomSetupScreen(),
  };
}