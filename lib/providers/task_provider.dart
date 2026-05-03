import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String roomId = "";
  bool isLoading = false;

  void setRoom(String id) {
    roomId = id;
    notifyListeners();
  }

  Stream<QuerySnapshot> getTasks() {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addTask(String title) async {
    final taskId = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc()
        .id;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(taskId)
        .set({
      'taskId': taskId,
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