import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineSyncService {
  OfflineSyncService._();

  static final OfflineSyncService instance = OfflineSyncService._();
  static const _queueKey = 'offline_action_queue_v1';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isFlushing = false;

  Future<void> init() async {
    _connectivitySub ??=
        _connectivity.onConnectivityChanged.listen((results) async {
      if (_isOnline(results)) {
        await flushQueue();
      }
    });

    await flushQueue();
  }

  void dispose() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  Future<void> addTask({
    required String roomId,
    required String taskId,
    required String title,
  }) async {
    final action = {
      'type': 'task_add',
      'roomId': roomId,
      'taskId': taskId,
      'title': title,
    };

    final ok = await _applyAction(action);
    if (!ok) {
      await _enqueue(action);
    }
  }

  Future<void> markTaskDone({
    required String roomId,
    required String taskId,
  }) async {
    final action = {
      'type': 'task_done',
      'roomId': roomId,
      'taskId': taskId,
    };

    final ok = await _applyAction(action);
    if (!ok) {
      await _enqueue(action);
    }
  }

  Future<void> addExpense({
    required String roomId,
    required String expenseId,
    required String title,
    required double amount,
    required String paidBy,
  }) async {
    final action = {
      'type': 'expense_add',
      'roomId': roomId,
      'expenseId': expenseId,
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
    };

    final ok = await _applyAction(action);
    if (!ok) {
      await _enqueue(action);
    }
  }

  Future<void> setExpenseReturned({
    required String roomId,
    required String expenseId,
    required bool returned,
  }) async {
    final action = {
      'type': 'expense_returned',
      'roomId': roomId,
      'expenseId': expenseId,
      'returned': returned,
    };

    final ok = await _applyAction(action);
    if (!ok) {
      await _enqueue(action);
    }
  }

  Future<void> flushQueue() async {
    if (_isFlushing) {
      return;
    }

    _isFlushing = true;
    try {
      final queue = await _readQueue();
      if (queue.isEmpty) {
        return;
      }

      final remaining = <Map<String, dynamic>>[];
      for (final action in queue) {
        final ok = await _applyAction(action);
        if (!ok) {
          remaining.add(action);
        }
      }

      await _writeQueue(remaining);
    } finally {
      _isFlushing = false;
    }
  }

  Future<bool> _applyAction(Map<String, dynamic> action) async {
    final type = action['type'] as String?;

    try {
      switch (type) {
        case 'task_add':
          await _applyTaskAdd(action);
          return true;
        case 'task_done':
          await _applyTaskDone(action);
          return true;
        case 'expense_add':
          await _applyExpenseAdd(action);
          return true;
        case 'expense_returned':
          await _applyExpenseReturned(action);
          return true;
        default:
          return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('OfflineSync apply failed for $type: $e');
      }
      return false;
    }
  }

  Future<void> _applyTaskAdd(Map<String, dynamic> action) async {
    final roomId = action['roomId'] as String;
    final taskId = action['taskId'] as String;
    final title = action['title'] as String;

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
    }, SetOptions(merge: true));
  }

  Future<void> _applyTaskDone(Map<String, dynamic> action) async {
    final roomId = action['roomId'] as String;
    final taskId = action['taskId'] as String;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(taskId)
        .set({
      'status': 'done',
    }, SetOptions(merge: true));
  }

  Future<void> _applyExpenseAdd(Map<String, dynamic> action) async {
    final roomId = action['roomId'] as String;
    final expenseId = action['expenseId'] as String;
    final title = action['title'] as String;
    final amount = (action['amount'] as num).toDouble();
    final paidBy = action['paidBy'] as String;

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
        .doc(expenseId)
        .set({
      'expenseId': expenseId,
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
      'members': totalMembers,
      'splitAmount': splitAmount,
      'isReturned': false,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> _applyExpenseReturned(Map<String, dynamic> action) async {
    final roomId = action['roomId'] as String;
    final expenseId = action['expenseId'] as String;
    final returned = action['returned'] as bool;

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('expenses')
        .doc(expenseId)
        .set({
      'isReturned': returned,
      'returnedAt': returned ? Timestamp.now() : null,
    }, SetOptions(merge: true));
  }

  Future<void> _enqueue(Map<String, dynamic> action) async {
    final queue = await _readQueue();
    queue.add({
      ...action,
      'queuedAt': DateTime.now().toIso8601String(),
    });
    await _writeQueue(queue);
  }

  Future<List<Map<String, dynamic>>> _readQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_queueKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry('$k', v)))
        .toList();
  }

  Future<void> _writeQueue(List<Map<String, dynamic>> queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_queueKey, jsonEncode(queue));
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return !results.contains(ConnectivityResult.none);
  }
}
