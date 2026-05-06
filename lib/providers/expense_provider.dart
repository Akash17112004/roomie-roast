import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String roomId = "";
  Stream<QuerySnapshot>? _expensesStream;

  void setRoom(String id) {
    if (roomId == id) {
      return;
    }

    roomId = id;
    _expensesStream = null;
    notifyListeners();
  }

  Stream<QuerySnapshot> getExpenses() {
    if (roomId.isEmpty) {
      return const Stream.empty();
    }

    return _expensesStream ??= _firestore
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

    final members = await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('members')
        .get();

    final totalMembers = members.docs.isEmpty ? 1 : members.docs.length;

    final splitAmount = amount / totalMembers;

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
      'splitAmount': splitAmount,
      'isReturned': false,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> setExpenseReturned({
    required String expenseId,
    required bool returned,
  }) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('expenses')
        .doc(expenseId)
        .update({
      'isReturned': returned,
      'returnedAt': returned ? Timestamp.now() : null,
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
