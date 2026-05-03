import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/analytics_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final expenseProvider =
        Provider.of<ExpenseProvider>(context);
    final analytics =
        Provider.of<AnalyticsProvider>(context);

    final primary = const Color(0xff7b61ff);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Dashboard"),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
              Colors.pink.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              /// HEADER CARD
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
                  borderRadius:
                      BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🏠 Room Analytics",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
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

              /// MOOD METER
              _glassCard(
                child: Column(
                  children: [
                    const Text(
                      "🎭 Room Mood Meter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      analytics.currentMood,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Slider(
                      value: analytics.moodIndex
                          .toDouble(),
                      min: 0,
                      max: 2,
                      divisions: 2,
                      activeColor: primary,
                      onChanged: (v) {
                        analytics.setMood(
                          v.toInt(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// TASK CHART
              StreamBuilder<QuerySnapshot>(
                stream: taskProvider.getTasks(),
                builder: (_, taskSnap) {
                  int totalTasks = 0;
                  int doneTasks = 0;

                  if (taskSnap.hasData) {
                    totalTasks =
                        taskSnap.data!.docs.length;

                    for (var doc
                        in taskSnap.data!.docs) {
                      final data =
                          doc.data()
                              as Map<String,
                                  dynamic>;

                      if (data["status"] ==
                          "done") {
                        doneTasks++;
                      }
                    }
                  }

                  final pending =
                      totalTasks - doneTasks;

                  return _glassCard(
                    child: Column(
                      children: [
                        const Text(
                          "🧹 Chore Progress",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        SizedBox(
                          height: 220,
                          child: BarChart(
                            BarChartData(
                              maxY:
                                  totalTasks == 0
                                      ? 5
                                      : totalTasks
                                              .toDouble() +
                                          1,

                              borderData:
                                  FlBorderData(
                                      show:
                                          false),

                              gridData:
                                  FlGridData(
                                      show:
                                          false),

                              titlesData:
                                  FlTitlesData(
                                topTitles:
                                    AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                          showTitles:
                                              false),
                                ),
                                rightTitles:
                                    AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                          showTitles:
                                              false),
                                ),
                                leftTitles:
                                    AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                    showTitles:
                                        true,
                                    reservedSize:
                                        28,
                                  ),
                                ),
                                bottomTitles:
                                    AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                    showTitles:
                                        true,
                                    getTitlesWidget:
                                        (value,
                                            meta) {
                                      switch (value
                                          .toInt()) {
                                        case 0:
                                          return const Text(
                                              "All");
                                        case 1:
                                          return const Text(
                                              "Done");
                                        case 2:
                                          return const Text(
                                              "Left");
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
                                      toY: totalTasks
                                          .toDouble(),
                                      width: 18,
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                      gradient:
                                          const LinearGradient(
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
                                      toY: doneTasks
                                          .toDouble(),
                                      width: 18,
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                      gradient:
                                          const LinearGradient(
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
                                      toY: pending
                                          .toDouble(),
                                      width: 18,
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                      gradient:
                                          const LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.orange,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Completed $doneTasks / $totalTasks tasks",
                          style: TextStyle(
                            color:
                                Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// EXPENSE CHART
              StreamBuilder<QuerySnapshot>(
                stream:
                    expenseProvider.getExpenses(),
                builder: (_, snap) {
                  double total = 0;

                  if (snap.hasData) {
                    for (var doc
                        in snap.data!.docs) {
                      final data =
                          doc.data()
                              as Map<String,
                                  dynamic>;

                      total +=
                          (data["amount"] ??
                                  0) *
                              1.0;
                    }
                  }

                  return _glassCard(
                    child: Column(
                      children: [
                        const Text(
                          "💸 Expense Radar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius:
                                  45,
                              sectionsSpace: 3,
                              sections: [
                                PieChartSectionData(
                                  value:
                                      total == 0
                                          ? 1
                                          : total,
                                  color: primary,
                                  radius: 65,
                                  title:
                                      "₹${total.toStringAsFixed(0)}",
                                  titleStyle:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 40,
                                  color: Colors
                                      .purple
                                      .shade100,
                                  radius: 58,
                                  title:
                                      "Room",
                                ),
                              ],
                            ),
                          ),
                        ),

                        Text(
                          "Total Spend ₹${total.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// INSIGHT BOX
              _glassCard(
                child: Row(
                  children: [
                    const Text(
                      "🤖",
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        analytics.insight(
                          1500,
                          2,
                        ),
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _glassCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.75),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}