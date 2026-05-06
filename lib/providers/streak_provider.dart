import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider extends ChangeNotifier {
  static const _streakKey = 'streak';

  int streak = 0;

  StreakProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    streak = prefs.getInt(_streakKey) ?? 0;
    notifyListeners();
  }

  Future<void> completedTask() async {
    streak++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
    notifyListeners();
  }

  Future<void> reset() async {
    streak = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
    notifyListeners();
  }

  String get badge {
    if (streak >= 10) {
      return "🏆 Legend";
    } else if (streak >= 5) {
      return "⚡ Hustler";
    } else if (streak >= 2) {
      return "🔥 Active";
    }
    return "😴 Sleeping";
  }
}
