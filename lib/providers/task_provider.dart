import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/offline_sync_service.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String roomId = "";
  bool isLoading = false;
  Stream<QuerySnapshot>? _tasksStream;

  void setRoom(String id) {
    if (roomId == id) {
      return;
    }

    roomId = id;
    _tasksStream = null;
    notifyListeners();
  }

  Stream<QuerySnapshot> getTasks() {
    if (roomId.isEmpty) {
      return const Stream.empty();
    }

    return _tasksStream ??= _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .snapshots();
  }

  Future<void> addTask(String title) async {
    if (roomId.isEmpty || title.trim().isEmpty) {
      return;
    }

    final taskId =
        _firestore.collection('rooms').doc(roomId).collection('tasks').doc().id;

    await OfflineSyncService.instance.addTask(
      roomId: roomId,
      taskId: taskId,
      title: title.trim(),
    );
  }

  Future<void> markDone(String taskId) async {
    if (roomId.isEmpty || taskId.trim().isEmpty) {
      return;
    }

    await OfflineSyncService.instance.markTaskDone(
      roomId: roomId,
      taskId: taskId.trim(),
    );
  }
}
