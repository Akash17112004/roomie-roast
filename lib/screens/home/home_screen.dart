import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../../services/roast_engine.dart';
import '../../services/notification_service.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/room_provider.dart';
import '../../providers/streak_provider.dart';
import '../../providers/social_provider.dart';
import '../../providers/fairness_provider.dart';

import '../../widgets/task_tile.dart';
import '../../widgets/speak_button.dart';

import 'expense_screen.dart';
import 'dashboard_screen.dart';
import 'leaderboard_screen.dart';
import 'social_screen.dart';
import 'fairness_screen.dart';
import '../../providers/theme_provider.dart';
import '../../theme/theme_helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController taskController = TextEditingController();

  late ConfettiController _confetti;

  bool notificationShown = false;

  @override
  void initState() {
    super.initState();

    _confetti = ConfettiController(
      duration: const Duration(
        seconds: 2,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as String?;
    final roomProvider = Provider.of<RoomProvider>(
      context,
      listen: false,
    );
    final fallbackRoomId = roomProvider.currentRoomId.isNotEmpty
        ? roomProvider.currentRoomId
        : roomProvider.lastRoomId;
    final targetRoomId =
        args ?? (fallbackRoomId.isNotEmpty ? fallbackRoomId : null);

    if (targetRoomId != null) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).setRoom(targetRoomId);

      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      ).setRoom(targetRoomId);

      Provider.of<SocialProvider>(
        context,
        listen: false,
      ).setRoom(targetRoomId);

      roomProvider.setRoom(targetRoomId);
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    taskController.dispose();
    super.dispose();
  }

  Future<void> _showAddTaskDialog(
    BuildContext context,
    TaskProvider provider,
  ) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Add Chore",
        ),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(
            hintText: "Task title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final text = taskController.text.trim();

              if (text.isEmpty) {
                return;
              }

              await provider.addTask(
                text,
              );

              taskController.clear();

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Add",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(
      context,
    );

    final taskProvider = Provider.of<TaskProvider>(
      context,
    );

    final analytics = Provider.of<AnalyticsProvider>(
      context,
    );

    final themeProvider = Provider.of<ThemeProvider>(
      context,
    );

    final currentUserName = auth.user?.displayName ??
        auth.user?.email?.split('@').first ??
        "Roommate";

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Roomie Roast",
        ),
        actions: [
          IconButton(
            tooltip: isDark ? "Switch to light mode" : "Switch to dark mode",
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: themeProvider.toggleDarkMode,
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              await auth.logout();

              if (mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff7b61ff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.home_work,
                    color: Colors.white,
                    size: 44,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Roomie Roast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.palette),
              title: const Text("Themes"),
              children: [
                ListTile(
                  title: const Text("Royal Purple"),
                  onTap: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).switchTheme(0);
                  },
                ),
                ListTile(
                  title: const Text("Dark Neon"),
                  onTap: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).switchTheme(1);
                  },
                ),
                ListTile(
                  title: const Text("Sunset Orange"),
                  onTap: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).switchTheme(2);
                  },
                ),
                ListTile(
                  title: const Text("Mint Fresh"),
                  onTap: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).switchTheme(3);
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.payments,
              ),
              title: const Text(
                "Expenses",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExpenseScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.bar_chart,
              ),
              title: const Text(
                "Dashboard",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.emoji_events,
              ),
              title: const Text(
                "Leaderboard",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeaderboardScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.groups,
              ),
              title: const Text(
                "Drama Center",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SocialScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.balance,
              ),
              title: const Text(
                "Fairness Engine",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FairnessScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(
                "Logout",
              ),
              onTap: () async {
                await auth.logout();

                if (mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(
          context,
          taskProvider,
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: taskProvider.getTasks(),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data!.docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final dataRoomId = (data["roomId"] ?? "").toString();
                          final parentRoomId =
                              doc.reference.parent.parent?.id ?? "";
                          return dataRoomId == taskProvider.roomId ||
                              parentRoomId == taskProvider.roomId;
                        }).toList();
                        final completedTasks = docs.where((doc) {
                          final task = doc.data() as Map<String, dynamic>;
                          return task["status"] == "done";
                        }).length;
                        final pendingTasks = docs.length - completedTasks;

                        final roast = analytics.displayInsight(
                          totalTasks: docs.length,
                          pendingTasks: pendingTasks,
                          completedTasks: completedTasks,
                        );

                        if (pendingTasks > 5 && !notificationShown) {
                          notificationShown = true;

                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              NotificationService.showRoast(
                                RoastEngine.roomChaos(
                                  pendingTasks,
                                ),
                              );
                            },
                          );
                        }

                        return Column(
                          children: [
                            Consumer<StreakProvider>(
                              builder: (_, streak, __) {
                                return Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.fromLTRB(
                                    context.isCompactWidth ? 12 : 16,
                                    context.isCompactWidth ? 12 : 16,
                                    context.isCompactWidth ? 12 : 16,
                                    6,
                                  ),
                                  padding: EdgeInsets.all(
                                    context.isCompactWidth ? 14 : 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.orange.withValues(alpha: 0.24)
                                        : Colors.orange.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    "Streak: ${streak.streak} ${streak.badge}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(
                                context.isCompactWidth ? 12 : 16,
                                6,
                                context.isCompactWidth ? 12 : 16,
                                12,
                              ),
                              padding: EdgeInsets.all(
                                context.isCompactWidth ? 14 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.22)
                                    : const Color(0xff7b61ff)
                                        .withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      roast,
                                      maxLines: context.isCompactWidth ? 3 : 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SpeakButton(
                                    text: roast,
                                    tooltip: "Speak roast",
                                  ),
                                  IconButton(
                                    tooltip: analytics.hasAiConfigured
                                        ? "Generate free AI roast"
                                        : "Free AI unavailable",
                                    onPressed: analytics
                                                .isGeneratingAiInsight ||
                                            !analytics.hasAiConfigured
                                        ? null
                                        : () {
                                            analytics.refreshAiInsight(
                                              totalTasks: docs.length,
                                              pendingTasks: pendingTasks,
                                              completedTasks: completedTasks,
                                              totalExpense: 0,
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
                                        : const Icon(Icons.bolt),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: docs.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No chores yet 🧹",
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: docs.length,
                                      itemBuilder: (_, i) {
                                        final task = docs[i].data()
                                            as Map<String, dynamic>;
                                        final taskId =
                                            task["taskId"] as String? ??
                                                docs[i].id;

                                        return TaskTile(
                                          taskId: taskId,
                                          title: task["title"],
                                          status: task["status"],
                                          onDone: () async {
                                            final streakProvider =
                                                Provider.of<StreakProvider>(
                                              context,
                                              listen: false,
                                            );
                                            final fairnessProvider =
                                                Provider.of<FairnessProvider>(
                                              context,
                                              listen: false,
                                            );
                                            final roomProvider =
                                                Provider.of<RoomProvider>(
                                              context,
                                              listen: false,
                                            );

                                            _confetti.play();

                                            await taskProvider.markDone(
                                              taskId,
                                            );

                                            await streakProvider
                                                .completedTask();

                                            fairnessProvider.completeTask(
                                              currentUserName,
                                            );

                                            await roomProvider
                                                .addScoreToCurrentUser(
                                              10,
                                            );

                                            await NotificationService.showRoast(
                                              RoastEngine.completed(
                                                currentUserName,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}
