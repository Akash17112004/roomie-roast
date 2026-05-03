import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String roomId = "";

  void setRoom(String id) {
    roomId = id;
    notifyListeners();
  }

  Stream<QuerySnapshot> getExpenses() {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('expenses')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String paidBy,
  }) async {
    final id = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('expenses')
        .doc()
        .id;

    final members =
        await _firestore
            .collection('rooms')
            .doc(roomId)
            .collection('members')
            .get();

    final totalMembers =
        members.docs.length == 0
            ? 1
            : members.docs.length;

    final splitAmount =
        amount / totalMembers;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('expenses')
        .doc(id)
        .set({
      'expenseId': id,
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
      'members': totalMembers,
      'splitAmount':
          splitAmount,
      'createdAt':
          Timestamp.now(),
    });
  }

  String whoOwesWhom(
    String paidBy,
    double split,
    int members,
  ) {
    final others = members - 1;

    if (others <= 0) {
      return "Solo expense.";
    }

    return "$others roommates owe $paidBy ₹${(split * others).toStringAsFixed(0)}";
  }
}