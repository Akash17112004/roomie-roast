import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    final taskId =
        _firestore.collection('rooms').doc(roomId).collection('tasks').doc().id;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(taskId)
        .set({
      'taskId': taskId,
      'roomId': roomId,
      'title': title,
      'status': 'pending',
      'assignedTo': 'Anyone',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> markDone(String taskId) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'status': 'done',
    });
  }
}
