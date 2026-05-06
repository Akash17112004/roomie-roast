import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/social_provider.dart';
import '../../theme/theme_helpers.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final complaint = TextEditingController();

  final item = TextEditingController();

  final by = TextEditingController();

  String result = "";

  @override
  void dispose() {
    complaint.dispose();
    item.dispose();
    by.dispose();
    super.dispose();
  }

  Widget sectionTitle(
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        top: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xff7b61ff),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Drama Center 🎭",
        ),
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
                    /// WHEEL CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff7b61ff),
                            Color(0xff9b8cff),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withValues(alpha: .18),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Punishment Wheel 🎡",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xff7b61ff),
                            ),
                            onPressed: () {
                              final list = provider.punishments;

                              setState(() {
                                result = list[Random().nextInt(list.length)];
                              });
                            },
                            child: const Text(
                              "Spin Now",
                            ),
                          ),
                          if (result.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .18),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  result,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// COMPLAINT SECTION
                    sectionTitle(
                      "Complaint Wall",
                      Icons.warning,
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            TextField(
                              controller: complaint,
                              decoration: const InputDecoration(
                                hintText: "Who burned Maggi again?",
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                await provider.addComplaint(
                                  complaint.text,
                                );
                                complaint.clear();
                              },
                              child: const Text(
                                "Post Complaint",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    StreamBuilder<QuerySnapshot>(
                      stream: provider.getComplaints(),
                      builder: (_, snap) {
                        if (!snap.hasData) {
                          return const SizedBox();
                        }

                        if (snap.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "No drama today 😇",
                            ),
                          );
                        }

                        return Column(
                          children: snap.data!.docs.map((e) {
                            final d = e.data() as Map<String, dynamic>;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: context.roomieCardDecoration(
                                radius: 18,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .12),
                                  child: const Icon(
                                    Icons.campaign,
                                    color: Colors.red,
                                  ),
                                ),
                                title: Text(
                                  d["text"],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    /// BORROW TRACKER
                    sectionTitle(
                      "Borrow Tracker",
                      Icons.inventory,
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            TextField(
                              controller: item,
                              decoration: const InputDecoration(
                                hintText: "Borrowed item",
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: by,
                              decoration: const InputDecoration(
                                hintText: "Taken by",
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                await provider.addBorrow(
                                  item.text,
                                  by.text,
                                );

                                item.clear();
                                by.clear();
                              },
                              child: const Text(
                                "Add Entry",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    StreamBuilder<QuerySnapshot>(
                      stream: provider.getBorrowed(),
                      builder: (_, snap) {
                        if (!snap.hasData) {
                          return const SizedBox();
                        }

                        if (snap.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Nothing stolen... yet 👀",
                            ),
                          );
                        }

                        return Column(
                          children: snap.data!.docs.map((e) {
                            final d = e.data() as Map<String, dynamic>;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: context.roomieCardDecoration(
                                radius: 18,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.orange.withValues(alpha: .14),
                                  child: const Icon(
                                    Icons.inventory_2,
                                    color: Colors.orange,
                                  ),
                                ),
                                title: Text(
                                  d["item"],
                                ),
                                subtitle: Text(
                                  "Taken by ${d["by"]}",
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
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
