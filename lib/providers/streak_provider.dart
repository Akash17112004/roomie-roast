import 'package:flutter/material.dart';

class StreakProvider
    extends ChangeNotifier {
  int streak = 0;

  void completedTask() {
    streak++;
    notifyListeners();
  }

  void reset() {
    streak = 0;
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