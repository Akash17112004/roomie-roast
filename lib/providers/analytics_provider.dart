import 'package:flutter/material.dart';
import '../services/roast_engine.dart';

class AnalyticsProvider
    extends ChangeNotifier {
  int moodIndex = 1;

  final List<String> moods = [
    "😡 Chaos",
    "😐 Normal",
    "😎 Chill",
  ];

  void setMood(int index) {
    moodIndex = index;
    notifyListeners();
  }

  String get currentMood =>
      moods[moodIndex];

  String roastMessage(
    int pendingTasks,
  ) {
    if (pendingTasks == 0) {
      return "This room is cleaner than our life choices.";
    }

    return RoastEngine.roomChaos(
      pendingTasks,
    );
  }

  String insight(
    double totalExpense,
    int tasks,
  ) {
    if (totalExpense >
        5000) {
      return "Budget vanished into snacks and mysterious online orders.";
    }

    if (totalExpense >
        3000) {
      return "High spending week. Wallets request silence.";
    }

    if (tasks == 0) {
      return "Excellent teamwork. Suspiciously efficient.";
    }

    if (tasks > 5) {
      return "Pending chores rising. Dust gaining confidence.";
    }

    return "Moderate activity. Civilization remains intact.";
  }

  List<Map<String, dynamic>>
      leaderboard() {
    return [
      {
        "name": "Akash",
        "score": 92,
        "title":
            "👑 House Hero",
      },
      {
        "name": "Arpit",
        "score": 68,
        "title":
            "⚡ Chore Warrior",
      },
      {
        "name": "Virat",
        "score": 54,
        "title":
            "🧽 Dust Diplomat",
      },
      {
        "name": "Dhoni",
        "score": 31,
        "title":
            "🛋️ Sofa Goblin",
      },
    ];
  }

  String topPerformerRoast() {
    final top =
        leaderboard().first;

    return RoastEngine
        .champion(
      top["name"],
    );
  }

  String lowestPerformerRoast() {
    final low =
        leaderboard().last;

    return RoastEngine.lazy(
      low["name"],
    );
  }
}