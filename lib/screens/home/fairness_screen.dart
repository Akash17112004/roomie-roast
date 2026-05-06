import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/analytics_provider.dart';
import '../../providers/duty_provider.dart';
import '../../providers/fairness_provider.dart';
import '../../theme/theme_helpers.dart';
import '../../widgets/speak_button.dart';

class FairnessScreen extends StatelessWidget {
  const FairnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fairness = Provider.of<FairnessProvider>(context);
    final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
    final duty = Provider.of<DutyProvider>(context);
    final board = analytics.leaderboard();

    const primary = Color(0xff7b61ff);
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fairness Engine"),
        centerTitle: true,
        actions: [
          if (board.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SpeakButton(
                text:
                    "${board.first["name"]} is on top of contribution leaderboard with ${board.first["score"]} points.",
                tooltip: "Speak fairness summary",
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: context.roomieBackgroundGradient,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth > context.roomieContentMaxWidth
                    ? context.roomieContentMaxWidth
                    : constraints.maxWidth,
                height: constraints.maxHeight,
                child: ListView(
                  padding: context.roomiePagePadding,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff7b61ff),
                            Color(0xff9f7bff),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: .25),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fairness Engine",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Who carries the house and who hides from dishes",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Contribution Leaderboard",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...board.asMap().entries.map((entry) {
                      final i = entry.key;
                      final e = entry.value;
                      final score = ((e["score"] ?? 0) as num).toInt();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: context.roomieCardDecoration(),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: primary.withValues(alpha: .12),
                            child: Text(
                              "#${i + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ),
                          title: Text(
                            (e["name"] ?? "Roommate").toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${fairness.rankTitle(score)}  |  Rating ${fairness.ratingForScore(score).toStringAsFixed(1)}/5",
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(
                                alpha: isDark ? .16 : .08,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "$score",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    const Text(
                      "Weekly Duty Rotation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...duty.assignments().map(
                          (e) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: context.roomieCardDecoration(),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange.withValues(
                                  alpha: isDark ? .16 : .08,
                                ),
                                child: const Icon(
                                  Icons.cleaning_services,
                                  color: Colors.orange,
                                ),
                              ),
                              title: Text(
                                e["member"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withValues(
                                    alpha: isDark ? .18 : .08,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  e["duty"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff7b61ff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: duty.nextWeek,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Rotate Next Week"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
