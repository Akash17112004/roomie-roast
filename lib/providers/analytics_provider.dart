import 'package:flutter/material.dart';

import '../services/ai_roast_service.dart';
import '../services/roast_engine.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AiRoastService _aiRoastService;

  AnalyticsProvider({
    AiRoastService? aiRoastService,
  }) : _aiRoastService = aiRoastService ?? AiRoastService();

  int moodIndex = 1;
  bool isGeneratingAiInsight = false;
  String? aiInsight;
  String? aiError;
  String? _aiInsightSnapshotKey;

  bool get hasAiConfigured => _aiRoastService.isConfigured;

  final List<String> moods = [
    "😡 Chaos",
    "😐 Normal",
    "😎 Chill",
  ];

  void setMood(int index) {
    moodIndex = index;
    notifyListeners();
  }

  String get currentMood => moods[moodIndex];

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

  String displayInsight({
    required int totalTasks,
    required int pendingTasks,
    required int completedTasks,
    String? fallbackInsight,
  }) {
    final currentSnapshotKey = _snapshotKey(
      totalTasks: totalTasks,
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
    );

    if (aiInsight != null &&
        _aiInsightSnapshotKey == currentSnapshotKey &&
        !_isProviderNotice(aiInsight!)) {
      return aiInsight!;
    }

    return fallbackInsight ??
        roastMessage(
          pendingTasks,
        );
  }

  String insight(
    double totalExpense,
    int tasks,
  ) {
    if (totalExpense > 5000) {
      return "Budget vanished into snacks and mysterious online orders.";
    }

    if (totalExpense > 3000) {
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

  Future<void> refreshAiInsight({
    required int totalTasks,
    required int pendingTasks,
    required int completedTasks,
    required double totalExpense,
  }) async {
    isGeneratingAiInsight = true;
    aiError = null;
    final snapshotKey = _snapshotKey(
      totalTasks: totalTasks,
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
    );
    notifyListeners();

    try {
      aiInsight = await _aiRoastService.generateRoomInsight(
        AiRoomSnapshot(
          totalTasks: totalTasks,
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
          totalExpense: totalExpense,
          mood: currentMood,
        ),
      );
      _aiInsightSnapshotKey = snapshotKey;
    } on AiRoastException catch (e) {
      aiError = e.message;
      aiInsight = null;
      _aiInsightSnapshotKey = null;
    } finally {
      isGeneratingAiInsight = false;
      notifyListeners();
    }
  }

  String _snapshotKey({
    required int totalTasks,
    required int pendingTasks,
    required int completedTasks,
  }) {
    return '$totalTasks:$pendingTasks:$completedTasks:$moodIndex';
  }

  bool _isProviderNotice(String content) {
    final normalized = content.toLowerCase();

    return normalized.contains('important notice') ||
        normalized.contains('legacy text api') ||
        normalized.contains('being deprecated') ||
        normalized.contains('please migrate') ||
        normalized.contains('enter.pollinations.ai');
  }

  List<Map<String, dynamic>> leaderboard() {
    return [
      {
        "name": "Akash",
        "score": 92,
        "title": "👑 House Hero",
      },
      {
        "name": "Arpit",
        "score": 68,
        "title": "⚡ Chore Warrior",
      },
      {
        "name": "Virat",
        "score": 54,
        "title": "🧽 Dust Diplomat",
      },
      {
        "name": "Dhoni",
        "score": 31,
        "title": "🛋️ Sofa Specialist",
      },
    ];
  }

  String topPerformerRoast() {
    final top = leaderboard().first;

    return RoastEngine.champion(
      top["name"],
    );
  }

  String lowestPerformerRoast() {
    final low = leaderboard().last;

    return RoastEngine.lazy(
      low["name"],
    );
  }
}
