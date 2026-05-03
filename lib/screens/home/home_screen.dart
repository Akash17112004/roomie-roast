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
import '../../providers/streak_provider.dart';
import '../../providers/social_provider.dart';
import '../../providers/fairness_provider.dart';

import '../../widgets/task_tile.dart';

import 'expense_screen.dart';
import 'dashboard_screen.dart';
import 'leaderboard_screen.dart';
import 'social_screen.dart';
import 'fairness_screen.dart';
import '../../theme/roomie_roast_premium_ui_themes.dart';
import '../../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final TextEditingController
      taskController =
      TextEditingController();

  late ConfettiController
      _confetti;

  bool notificationShown =
      false;

  @override
  void initState() {
    super.initState();

    _confetti =
        ConfettiController(
      duration:
          const Duration(
        seconds: 2,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)
            ?.settings
            .arguments as String?;

    if (args != null) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).setRoom(args);

      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      ).setRoom(args);

      Provider.of<SocialProvider>(
        context,
        listen: false,
      ).setRoom(args);
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    taskController.dispose();
    super.dispose();
  }

  Future<void>
      _showAddTaskDialog(
    BuildContext context,
    TaskProvider provider,
  ) async {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
        title:
            const Text(
          "Add Chore",
        ),
        content:
            TextField(
          controller:
              taskController,
          decoration:
              const InputDecoration(
            hintText:
                "Task title",
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                () async {
              final text =
                  taskController
                      .text
                      .trim();

              if (text
                  .isEmpty) {
                return;
              }

              await provider
                  .addTask(
                text,
              );

              taskController
                  .clear();

              if (mounted) {
                Navigator.pop(
                    context);
              }
            },
            child:
                const Text(
              "Add",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    final auth =
        Provider.of<AuthProvider>(
      context,
    );

    final taskProvider =
        Provider.of<TaskProvider>(
      context,
    );

    final analytics =
        Provider.of<
            AnalyticsProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          "Roomie Roast",
        ),
        actions: [
          IconButton(
            icon:
                const Icon(
              Icons.logout,
            ),
            onPressed:
                () async {
              await auth
                  .logout();

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
          padding:
              EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration:
                  BoxDecoration(
                color: Color(
                    0xff7b61ff),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                mainAxisAlignment:
                    MainAxisAlignment
                        .end,
                children: [
                  Icon(
                    Icons.home_work,
                    color:
                        Colors.white,
                    size: 44,
                  ),
                  SizedBox(
                      height:
                          10),
                  Text(
                    "Roomie Roast",
                    style:
                        TextStyle(
                      color: Colors
                          .white,
                      fontSize:
                          22,
                      fontWeight:
                          FontWeight
                              .bold,
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
              leading:
                  const Icon(
                Icons.payments,
              ),
              title:
                  const Text(
                "Expenses",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            const ExpenseScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
                  const Icon(
                Icons.bar_chart,
              ),
              title:
                  const Text(
                "Dashboard",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            const DashboardScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
                  const Icon(
                Icons.emoji_events,
              ),
              title:
                  const Text(
                "Leaderboard",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            const LeaderboardScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
                  const Icon(
                Icons.groups,
              ),
              title:
                  const Text(
                "Drama Center",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            const SocialScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
                  const Icon(
                Icons.balance,
              ),
              title:
                  const Text(
                "Fairness Engine",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            const FairnessScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading:
                  const Icon(
                Icons.logout,
              ),
              title:
                  const Text(
                "Logout",
              ),
              onTap: () async {
                await auth
                    .logout();

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

      floatingActionButton:
          FloatingActionButton(
        onPressed: () =>
            _showAddTaskDialog(
          context,
          taskProvider,
        ),
        child:
            const Icon(
          Icons.add,
        ),
      ),

      body: Stack(
        children: [
          Container(
            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  Color(
                      0xfff8f6ff),
                  Color(
                      0xffeef0ff),
                ],
                begin:
                    Alignment
                        .topLeft,
                end: Alignment
                    .bottomRight,
              ),
            ),

            child:
                StreamBuilder<
                    QuerySnapshot>(
              stream:
                  taskProvider
                      .getTasks(),
              builder:
                  (_, snapshot) {
                if (!snapshot
                    .hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final docs =
                    snapshot
                        .data!
                        .docs;

                final roast =
                    analytics
                        .roastMessage(
                  docs.length,
                );

                if (docs.length >
                        5 &&
                    !notificationShown) {
                  notificationShown =
                      true;

                  WidgetsBinding
                      .instance
                      .addPostFrameCallback(
                    (_) {
                      NotificationService
                          .showRoast(
                        RoastEngine
                            .roomChaos(
                          docs.length,
                        ),
                      );
                    },
                  );
                }

                return Column(
                  children: [
                    Consumer<
                        StreakProvider>(
                      builder:
                          (_,
                              streak,
                              __) {
                        return Container(
                          width: double
                              .infinity,
                          margin:
                              const EdgeInsets
                                  .fromLTRB(
                            12,
                            12,
                            12,
                            6,
                          ),
                          padding:
                              const EdgeInsets
                                  .all(
                            14,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .orange
                                .withOpacity(
                                    0.14),
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                          child: Text(
                            "Streak: ${streak.streak} ${streak.badge}",
                            style:
                                const TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),

                    Container(
                      width: double
                          .infinity,
                      margin:
                          const EdgeInsets
                              .fromLTRB(
                        12,
                        6,
                        12,
                        12,
                      ),
                      padding:
                          const EdgeInsets
                              .all(
                        14,
                      ),
                      decoration:
                          BoxDecoration(
                        color: const Color(
                                0xff7b61ff)
                            .withOpacity(
                                0.16),
                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),
                      child: Text(
                        roast,
                        style:
                            const TextStyle(
                          fontSize:
                              16,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                          docs.isEmpty
                              ? const Center(
                                  child:
                                      Text(
                                    "No chores yet 🧹",
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      docs.length,
                                  itemBuilder:
                                      (_,
                                          i) {
                                    final task =
                                        docs[i]
                                                .data()
                                            as Map<String,
                                                dynamic>;

                                    return TaskTile(
                                      title:
                                          task[
                                              "title"],
                                      status:
                                          task[
                                              "status"],
                                      onDone:
                                          () async {
                                        _confetti
                                            .play();

                                        await taskProvider
                                            .markDone(
                                          task[
                                              "taskId"],
                                        );

                                        Provider.of<
                                            StreakProvider>(
                                          context,
                                          listen:
                                              false,
                                        ).completedTask();

                                        Provider.of<
                                            FairnessProvider>(
                                          context,
                                          listen:
                                              false,
                                        ).completeTask(
                                          "Akash",
                                        );

                                        await NotificationService
                                            .showRoast(
                                          RoastEngine.completed(
                                            "Akash",
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

          Align(
            alignment:
                Alignment
                    .topCenter,
            child:
                ConfettiWidget(
              confettiController:
                  _confetti,
              blastDirectionality:
                  BlastDirectionality
                      .explosive,
              shouldLoop:
                  false,
            ),
          ),
        ],
      ),
    );
  }
}