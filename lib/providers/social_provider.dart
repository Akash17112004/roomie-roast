import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SocialProvider
    extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String roomId = "";

  void setRoom(String id) {
    if (roomId == id) return;

    roomId = id;
    notifyListeners();
  }

  Stream<QuerySnapshot>
      getComplaints() {
    if (roomId.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection(
            'complaints')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  Future<void> addComplaint(
    String text,
  ) async {
    if (roomId.isEmpty ||
        text.trim().isEmpty) {
      return;
    }

    final id = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection(
            'complaints')
        .doc()
        .id;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection(
            'complaints')
        .doc(id)
        .set({
      'id': id,
      'text': text.trim(),
      'resolved': false,
      'createdAt':
          Timestamp.now(),
    });
  }

  Stream<QuerySnapshot>
      getBorrowed() {
    if (roomId.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection(
            'borrowed')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  Future<void> addBorrow(
    String item,
    String by,
  ) async {
    if (roomId.isEmpty ||
        item.trim().isEmpty ||
        by.trim().isEmpty) {
      return;
    }

    final id = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection(
            'borrowed')
        .doc()
        .id;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection(
            'borrowed')
        .doc(id)
        .set({
      'id': id,
      'item': item.trim(),
      'by': by.trim(),
      'createdAt':
          Timestamp.now(),
    });
  }

  final List<String>
      punishments = [
    "Buy snacks for everyone 🍟",
    "Wash dishes today 🍽️",
    "Make chai for all ☕",
    "Take out trash 🗑️",
    "Silent mode for 1 hour 🤐",
    "Clean bathroom heroically 🚿",
  ];
}