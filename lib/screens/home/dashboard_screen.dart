import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/room_provider.dart';
import '../../theme/theme_helpers.dart';
import '../../widgets/speak_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static bool _isTaskDone(Map<String, dynamic> data) {
    final raw = data["status"];

    if (raw is bool) {
      return raw;
    }
    if (raw is String) {
      final normalized = raw.trim().toLowerCase();
      return normalized == "done" ||
          normalized == "completed" ||
          normalized == "complete";
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final analytics = Provider.of<AnalyticsProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    const primary = Color(0xff7b61ff);

    final activeRoomId = roomProvider.currentRoomId.isNotEmpty
        ? roomProvider.currentRoomId
        : roomProvider.lastRoomId.isNotEmpty
            ? roomProvider.lastRoomId
            : taskProvider.roomId.isNotEmpty
                ? taskProvider.roomId
                : expenseProvider.roomId;

    if (activeRoomId.isNotEmpty) {
      if (taskProvider.roomId != activeRoomId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          taskProvider.setRoom(activeRoomId);
        });
      }
      if (expenseProvider.roomId != activeRoomId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          expenseProvider.setRoom(activeRoomId);
        });
      }
    }

    if (activeRoomId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Room Dashboard"),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: context.roomieBackgroundGradient,
          ),
          child: const Center(
            child: Text(
              "Join or create a room first to see dashboard data.",
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Dashboard"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: context.roomieBackgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: context.roomiePagePadding,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.roomieContentMaxWidth,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7b61ff),
                          Color(0xff9f7bff),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: .25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Room Analytics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Track chaos, chores & cash flow",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _glassCard(
                    context: context,
                    child: Column(
                      children: [
                        const Text(
                          "Room Mood Meter",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          analytics.currentMood,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: analytics.moodIndex.toDouble(),
                          min: 0,
                          max: 2,
                          divisions: 2,
                          activeColor: primary,
                          onChanged: (v) {
                            analytics.setMood(v.toInt());
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('tasks')
                        .snapshots(),
                    builder: (_, taskSnap) {
                      if (taskSnap.hasError) {
                        return _glassCard(
                          context: context,
                          child: Text(
                            "Could not load chores: ${taskSnap.error}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        );
                      }

                      int totalTasks = 0;
                      int doneTasks = 0;

                      if (taskSnap.hasData) {
                        final allDocs = taskSnap.data!.docs;
                        final roomDocs = allDocs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final dataRoomId = (data["roomId"] ?? "").toString();
                          final parentRoomId =
                              doc.reference.parent.parent?.id ?? "";
                          return dataRoomId == activeRoomId ||
                              parentRoomId == activeRoomId;
                        }).toList();

                        final effectiveDocs =
                            roomDocs.isNotEmpty ? roomDocs : allDocs;

                        totalTasks = effectiveDocs.length;
                        for (var doc in effectiveDocs) {
                          final data = doc.data() as Map<String, dynamic>;
                          if (data["status"] == "done") {
                            doneTasks++;
                          }
                        }
                      }

                      final pending = totalTasks - doneTasks;

                      return _glassCard(
                        context: context,
                        child: Column(
                          children: [
                            const Text(
                              "Chore Progress",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: context.roomieChartHeight,
                              child: BarChart(
                                BarChartData(
                                  maxY: totalTasks == 0
                                      ? 5
                                      : totalTasks.toDouble() + 1,
                                  borderData: FlBorderData(show: false),
                                  gridData: const FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    leftTitles: const AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return const Text("All");
                                            case 1:
                                              return const Text("Done");
                                            case 2:
                                              return const Text("Left");
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ),
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                          toY: totalTasks.toDouble(),
                                          width: 18,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.deepPurple,
                                              Colors.purpleAccent,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                          toY: doneTasks.toDouble(),
                                          width: 18,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.green,
                                              Colors.lightGreen,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 2,
                                      barRods: [
                                        BarChartRodData(
                                          toY: pending.toDouble(),
                                          width: 18,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [Colors.red, Colors.orange],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _tinyStat(
                                  context: context,
                                  label: "All",
                                  value: totalTasks.toString(),
                                  color: Colors.deepPurple,
                                ),
                                _tinyStat(
                                  context: context,
                                  label: "Done",
                                  value: doneTasks.toString(),
                                  color: Colors.green,
                                ),
                                _tinyStat(
                                  context: context,
                                  label: "Left",
                                  value: pending.toString(),
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Completed $doneTasks / $totalTasks tasks",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: expenseProvider.getExpenses(),
                    builder: (_, snap) {
                      double total = 0;
                      double returnedTotal = 0;
                      double pendingReturnTotal = 0;
                      int returnedCount = 0;
                      int pendingReturnCount = 0;

                      if (snap.hasData) {
                        for (var doc in snap.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final amount =
                              ((data["amount"] ?? 0) as num).toDouble();
                          final isReturned = data["isReturned"] == true;

                          total += amount;
                          if (isReturned) {
                            returnedTotal += amount;
                            returnedCount++;
                          } else {
                            pendingReturnTotal += amount;
                            pendingReturnCount++;
                          }
                        }
                      }

                      return _glassCard(
                        context: context,
                        child: Column(
                          children: [
                            const Text(
                              "Expense Radar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: context.roomieChartHeight,
                              child: PieChart(
                                PieChartData(
                                  centerSpaceRadius: 45,
                                  sectionsSpace: 3,
                                  sections: [
                                    PieChartSectionData(
                                      value: returnedTotal == 0
                                          ? 0.01
                                          : returnedTotal,
                                      color: primary,
                                      radius: 65,
                                      title:
                                          "Returned\nRs ${returnedTotal.toStringAsFixed(0)}",
                                      titleStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    PieChartSectionData(
                                      value: pendingReturnTotal == 0
                                          ? 0.01
                                          : pendingReturnTotal,
                                      color: Colors.orange.shade300,
                                      radius: 58,
                                      title:
                                          "Pending\nRs ${pendingReturnTotal.toStringAsFixed(0)}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "Total Spend Rs ${total.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _tinyStat(
                                  context: context,
                                  label: "Returned",
                                  value: returnedCount.toString(),
                                  color: primary,
                                ),
                                _tinyStat(
                                  context: context,
                                  label: "Pending",
                                  value: pendingReturnCount.toString(),
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _AiInsightCard(
                    taskProvider: taskProvider,
                    expenseProvider: expenseProvider,
                    analytics: analytics,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _glassCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: context.roomieCardDecoration(),
      child: child,
    );
  }

  static Widget _tinyStat({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  final TaskProvider taskProvider;
  final ExpenseProvider expenseProvider;
  final AnalyticsProvider analytics;

  const _AiInsightCard({
    required this.taskProvider,
    required this.expenseProvider,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: taskProvider.getTasks(),
      builder: (_, taskSnap) {
        final roomProvider = Provider.of<RoomProvider>(context, listen: false);
        final activeRoomId = roomProvider.currentRoomId.isNotEmpty
            ? roomProvider.currentRoomId
            : roomProvider.lastRoomId.isNotEmpty
                ? roomProvider.lastRoomId
                : taskProvider.roomId;

        final taskDocs = (taskSnap.data?.docs ?? []).where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final dataRoomId = (data["roomId"] ?? "").toString();
          final parentRoomId = doc.reference.parent.parent?.id ?? "";
          return dataRoomId == activeRoomId || parentRoomId == activeRoomId;
        }).toList();
        final totalTasks = taskDocs.length;
        final completedTasks = taskDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return DashboardScreen._isTaskDone(data);
        }).length;
        final pendingTasks = totalTasks - completedTasks;

        return StreamBuilder<QuerySnapshot>(
          stream: expenseProvider.getExpenses(),
          builder: (_, expenseSnap) {
            final expenseDocs = expenseSnap.data?.docs ?? [];
            double totalExpense = 0;

            for (var doc in expenseDocs) {
              final data = doc.data() as Map<String, dynamic>;
              totalExpense += ((data["amount"] ?? 0) as num).toDouble();
            }

            final fallbackInsight = analytics.insight(
              totalExpense,
              pendingTasks,
            );
            final insight = analytics.displayInsight(
              totalTasks: totalTasks,
              pendingTasks: pendingTasks,
              completedTasks: completedTasks,
              fallbackInsight: fallbackInsight,
            );

            return DashboardScreen._glassCard(
              context: context,
              child: Row(
                children: [
                  const Text(
                    "AI",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI Room Insight",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          insight,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (analytics.aiError != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            analytics.aiError!,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SpeakButton(
                    text: insight,
                    tooltip: "Speak insight",
                  ),
                  IconButton.filledTonal(
                    tooltip: analytics.hasAiConfigured
                        ? "Generate free AI insight"
                        : "Free AI unavailable",
                    onPressed: analytics.isGeneratingAiInsight ||
                            !analytics.hasAiConfigured
                        ? null
                        : () {
                            analytics.refreshAiInsight(
                              totalTasks: totalTasks,
                              pendingTasks: pendingTasks,
                              completedTasks: completedTasks,
                              totalExpense: totalExpense,
                            );
                          },
                    icon: analytics.isGeneratingAiInsight
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.auto_awesome),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
