import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/speak_button.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  Color rankColor(int i) {
    if (i == 0) return Colors.amber;
    if (i == 1) return Colors.grey;
    if (i == 2) return Colors.orange;
    return Colors.deepPurple;
  }

  IconData rankIcon(int i) {
    if (i == 0) return Icons.emoji_events;
    if (i == 1) return Icons.workspace_premium;
    if (i == 2) return Icons.military_tech;
    return Icons.star;
  }

  String roastLine(int i) {
    if (i == 0) return "Runs the room like royalty ??";
    if (i == 1) return "Very dangerous competitor ?";
    if (i == 2) return "Climbing faster than rent ??";
    return "Still cooking greatness ??";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyticsProvider>(context);

    final data = provider.leaderboard();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hall of Flatmates"),
        actions: [
          if (data.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SpeakButton(
                text:
                    "${data.first["name"]} is leading with ${data.first["score"]} points.",
                tooltip: "Speak leaderboard summary",
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff8f6ff),
              Color(0xffede7ff),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// HEADER CARD
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff7b61ff),
                    Color(0xff9b8cff),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Room Legends Board ??",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final user = data[i];

                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: rankColor(i).withOpacity(.15),
                        child: Icon(
                          rankIcon(i),
                          color: rankColor(i),
                          size: 28,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            "#${i + 1}",
                            style: TextStyle(
                              color: rankColor(i),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              user["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: Text(
                          roastLine(i),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: rankColor(i).withOpacity(.12),
                        ),
                        child: Text(
                          "${user["score"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: rankColor(i),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
