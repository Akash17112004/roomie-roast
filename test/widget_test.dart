import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roomie_roast/providers/analytics_provider.dart';
import 'package:roomie_roast/providers/theme_provider.dart';
import 'package:roomie_roast/services/ai_roast_service.dart';
import 'package:roomie_roast/widgets/task_tile.dart';

void main() {
  group('ThemeProvider', () {
    test('toggles between light and dark mode', () {
      final provider = ThemeProvider();

      expect(provider.mode, ThemeMode.light);

      provider.toggleDarkMode();
      expect(provider.mode, ThemeMode.dark);

      provider.toggleDarkMode();
      expect(provider.mode, ThemeMode.light);
    });
  });

  group('AnalyticsProvider', () {
    test('loads an AI insight from the configured service', () async {
      final provider = AnalyticsProvider(
        aiRoastService: _FakeAiRoastService(),
      );

      await provider.refreshAiInsight(
        totalTasks: 4,
        pendingTasks: 2,
        completedTasks: 2,
        totalExpense: 1200,
      );

      expect(provider.aiInsight, 'AI says the sink is losing badly.');
      expect(provider.aiError, isNull);
      expect(provider.isGeneratingAiInsight, isFalse);
    });

    test('ignores provider notices when displaying AI insight', () async {
      final provider = AnalyticsProvider(
        aiRoastService: _FakeNoticeRoastService(),
      );

      await provider.refreshAiInsight(
        totalTasks: 4,
        pendingTasks: 2,
        completedTasks: 2,
        totalExpense: 1200,
      );

      final insight = provider.displayInsight(
        totalTasks: 4,
        pendingTasks: 2,
        completedTasks: 2,
        fallbackInsight: 'Local room insight.',
      );

      expect(insight, 'Local room insight.');
      expect(insight, isNot(contains('IMPORTANT NOTICE')));
    });
  });

  group('TaskTile', () {
    testWidgets('marks a pending task done when the done button is tapped',
        (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              taskId: 'task-dishes',
              title: 'Dishes',
              status: 'pending',
              onDone: () {
                completed = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.done));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('swipe completion does not remove the Dismissible',
        (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              taskId: 'task-laundry',
              title: 'Laundry',
              status: 'pending',
              onDone: () {
                completed = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('Laundry'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.byType(Dismissible), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

class _FakeAiRoastService extends AiRoastService {
  @override
  bool get isConfigured => true;

  @override
  Future<String> generateRoomInsight(AiRoomSnapshot snapshot) async {
    return 'AI says the sink is losing badly.';
  }
}

class _FakeNoticeRoastService extends AiRoastService {
  @override
  bool get isConfigured => true;

  @override
  Future<String> generateRoomInsight(AiRoomSnapshot snapshot) async {
    return '**IMPORTANT NOTICE** The Pollinations legacy text API is being deprecated. Please migrate to enter.pollinations.ai.';
  }
}
