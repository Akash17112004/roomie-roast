import 'dart:convert';

import 'package:http/http.dart' as http;

class AiRoomSnapshot {
  final int totalTasks;
  final int pendingTasks;
  final int completedTasks;
  final double totalExpense;
  final String mood;

  const AiRoomSnapshot({
    required this.totalTasks,
    required this.pendingTasks,
    required this.completedTasks,
    required this.totalExpense,
    required this.mood,
  });
}

class AiRoastService {
  static const String _endpoint = String.fromEnvironment(
    'AI_ROAST_ENDPOINT',
    defaultValue:
        'https://v2.jokeapi.dev/joke/Miscellaneous,Pun?type=single&blacklistFlags=nsfw,religious,political,racist,sexist,explicit',
  );

  bool get isConfigured => true;

  Future<String> generateRoomInsight(AiRoomSnapshot snapshot) async {
    try {
      final response = await http
          .get(
            Uri.parse(_endpoint),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = _extractApiError(response.body);
        throw AiRoastException(
          error == null
              ? 'AI API failed with status ${response.statusCode}.'
              : 'AI API failed with status ${response.statusCode}: $error',
        );
      }

      final content = _extractFreeApiText(response.body);

      if (content.isEmpty) {
        throw const AiRoastException(
          'AI API returned an empty insight.',
        );
      }

      return _mergeWithSnapshot(snapshot, content);
    } catch (_) {
      return _offlineInsight(snapshot);
    }
  }

  String? _extractApiError(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final error = data['error'];

      if (error is Map<String, dynamic>) {
        final message = error['message'] as String?;

        if (message != null && message.trim().isNotEmpty) {
          return _shortError(message.trim());
        }
      }

      if (error is String && error.trim().isNotEmpty) {
        return _shortError(error.trim());
      }
    } catch (_) {
      final trimmedBody = body.trim();

      if (trimmedBody.isNotEmpty) {
        return _shortError(trimmedBody);
      }
    }

    return null;
  }

  String _extractFreeApiText(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    if (data['error'] == true) {
      throw const AiRoastException('Free AI endpoint failed.');
    }

    final single = data['joke'];
    if (single is String && single.trim().isNotEmpty) {
      return single.trim();
    }

    final setup = data['setup'];
    final delivery = data['delivery'];
    if (setup is String && delivery is String) {
      final text = '${setup.trim()} ${delivery.trim()}'.trim();
      if (text.isNotEmpty) {
        return text;
      }
    }

    throw const AiRoastException('Free AI endpoint returned no text.');
  }

  String _mergeWithSnapshot(AiRoomSnapshot snapshot, String apiLine) {
    final roomLine = _offlineInsight(snapshot);
    final cleanApiLine = apiLine.replaceAll('\n', ' ').trim();

    if (cleanApiLine.isEmpty) {
      return roomLine;
    }

    final merged = '$roomLine $cleanApiLine';
    return merged.length > 200 ? '${merged.substring(0, 200)}...' : merged;
  }

  String _offlineInsight(AiRoomSnapshot snapshot) {
    if (snapshot.pendingTasks == 0) {
      return 'Chores are done. The room is acting suspiciously employable.';
    }

    if (snapshot.totalExpense > 5000) {
      return 'Expenses are doing cardio while the budget quietly asks for help.';
    }

    if (snapshot.pendingTasks > snapshot.completedTasks) {
      return 'Pending chores have formed a committee and elected dust as chair.';
    }

    return 'Room status: mostly civilized, with just enough chaos for character.';
  }

  String _shortError(String message) {
    return message.length > 180 ? '${message.substring(0, 180)}...' : message;
  }
}

class AiRoastException implements Exception {
  final String message;

  const AiRoastException(this.message);

  @override
  String toString() => message;
}
