// lib/screens/room/room_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/room_provider.dart';

class RoomSetupScreen extends StatefulWidget {
  const RoomSetupScreen({super.key});

  @override
  State<RoomSetupScreen> createState() =>
      _RoomSetupScreenState();
}

class _RoomSetupScreenState
    extends State<RoomSetupScreen> {
  final createController =
      TextEditingController();

  final joinController =
      TextEditingController();

  @override
  void dispose() {
    createController.dispose();
    joinController.dispose();
    super.dispose();
  }

  Future<void> createRoom() async {
    final provider =
        Provider.of<RoomProvider>(
      context,
      listen: false,
    );

    final roomName =
        createController.text.trim();

    if (roomName.isEmpty) {
      snack("Enter room name");
      return;
    }

    final error =
        await provider.createRoom(
      roomName,
    );

    if (!mounted) return;

    if (error != null) {
      snack(error);
      return;
    }

    showRoomCreatedDialog(
      provider.lastRoomCode,
      provider.lastRoomId,
    );
  }

  Future<void> joinRoom() async {
    final provider =
        Provider.of<RoomProvider>(
      context,
      listen: false,
    );

    final code =
        joinController.text
            .trim()
            .toUpperCase();

    if (code.isEmpty) {
      snack("Enter room code");
      return;
    }

    final error =
        await provider.joinRoom(
      code,
    );

    if (!mounted) return;

    if (error != null) {
      snack(error);
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: provider.lastRoomId,
    );
  }

  void snack(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void showRoomCreatedDialog(
    String code,
    String roomId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          AlertDialog(
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  22),
        ),
        title: const Text(
          "Room Created 🎉",
        ),
        content: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Text(
              "Share this code with your roommates",
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 14,
              ),
              decoration:
                  BoxDecoration(
                color: const Color(
                    0xff7b61ff),
                borderRadius:
                    BorderRadius.circular(
                        16),
              ),
              child: Text(
                code,
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing:
                      4,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: code,
                ),
              );

              snack(
                  "Code copied");
            },
            icon: const Icon(
              Icons.copy,
            ),
            label:
                const Text(
              "Copy",
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Share.share(
                "Join my Roomie Roast room!\nCode: $code",
              );
            },
            icon: const Icon(
              Icons.share,
            ),
            label:
                const Text(
              "Share",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context);

              Navigator.pushReplacementNamed(
                context,
                '/home',
                arguments:
                    roomId,
              );
            },
            child: const Text(
              "Enter Room",
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
                24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black12,
            offset:
                Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            subtitle,
            style:
                TextStyle(
              color: Colors
                  .grey.shade600,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    final provider =
        Provider.of<RoomProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Room Setup",
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(
          gradient:
              LinearGradient(
            colors: [
              Color(
                  0xff7b61ff),
              Color(
                  0xff9d50ff),
            ],
            begin:
                Alignment.topLeft,
            end: Alignment
                .bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(
                    16),
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),

                const Text(
                  "🏠 Roomie Roast",
                  style:
                      TextStyle(
                    color: Colors
                        .white,
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "Create a room or join the chaos.",
                  style:
                      TextStyle(
                    color: Colors
                        .white70,
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                buildCard(
                  title:
                      "Create Room 🚀",
                  subtitle:
                      "Start a new shared room",
                  child: Column(
                    children: [
                      TextField(
                        controller:
                            createController,
                        decoration:
                            const InputDecoration(
                          hintText:
                              "Room name",
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      ElevatedButton(
                        onPressed:
                            provider
                                    .isLoading
                                ? null
                                : createRoom,
                        child:
                            const Text(
                          "Create",
                        ),
                      ),
                    ],
                  ),
                ),

                buildCard(
                  title:
                      "Join Room 🔑",
                  subtitle:
                      "Enter room code",
                  child: Column(
                    children: [
                      TextField(
                        controller:
                            joinController,
                        textCapitalization:
                            TextCapitalization
                                .characters,
                        decoration:
                            const InputDecoration(
                          hintText:
                              "ABC123",
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      ElevatedButton(
                        onPressed:
                            provider
                                    .isLoading
                                ? null
                                : joinRoom,
                        child:
                            const Text(
                          "Join",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}