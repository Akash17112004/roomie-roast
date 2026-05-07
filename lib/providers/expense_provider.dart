import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/offline_sync_service.dart';

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
    if (roomId.isEmpty) {
      return;
    }

    final id = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('expenses')
        .doc()
        .id;

    await OfflineSyncService.instance.addExpense(
      roomId: roomId,
      expenseId: id,
      title: title.trim(),
      amount: amount,
      paidBy: paidBy.trim(),
    );
  }

  Future<void> setExpenseReturned({
    required String expenseId,
    required bool returned,
  }) async {
    if (roomId.isEmpty || expenseId.trim().isEmpty) {
      return;
    }

    await OfflineSyncService.instance.setExpenseReturned(
      roomId: roomId,
      expenseId: expenseId.trim(),
      returned: returned,
    );
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
