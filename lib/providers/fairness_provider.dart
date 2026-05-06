import 'package:flutter/material.dart';

class FairnessProvider extends ChangeNotifier {
  final Map<String, int> scores = {
    "Akash": 0,
    "Arpit": 0,
    "Virat": 0,
    "Dhoni": 0,
  };

  void completeTask(String name) {
    scores[name] = (scores[name] ?? 0) + 10;
    notifyListeners();
  }

  void paidExpense(String name) {
    scores[name] = (scores[name] ?? 0) + 6;
    notifyListeners();
  }

  void streakBonus(String name) {
    scores[name] = (scores[name] ?? 0) + 3;
    notifyListeners();
  }

  void complaint(String name) {
    scores[name] = (scores[name] ?? 0) - 8;
    notifyListeners();
  }

  void skippedDuty(String name) {
    scores[name] = (scores[name] ?? 0) - 5;
    notifyListeners();
  }

  String rankTitle(int score) {
    if (score >= 90) {
      return "House Hero";
    }
    if (score >= 70) {
      return "Chore Warrior";
    }
    if (score >= 50) {
      return "Dust Diplomat";
    }
    if (score >= 30) {
      return "Barely Present";
    }
    return "Sofa Goblin";
  }

  double ratingForScore(int score) {
    if (score >= 90) {
      return 5.0;
    }
    if (score >= 70) {
      return 4.5;
    }
    if (score >= 50) {
      return 4.0;
    }
    if (score >= 30) {
      return 3.5;
    }
    if (score >= 10) {
      return 3.0;
    }
    return 2.5;
  }

  List<Map<String, dynamic>> leaderboard() {
    final list = scores.entries
        .map(
          (entry) => {
            "name": entry.key,
            "score": entry.value,
            "title": rankTitle(entry.value),
            "rating": ratingForScore(entry.value),
          },
        )
        .toList();

    list.sort(
      (a, b) => (b["score"] as int).compareTo(
        a["score"] as int,
      ),
    );

    return list;
  }
}
