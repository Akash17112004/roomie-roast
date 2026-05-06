import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  String lastRoomId = "";
  String lastRoomCode = "";
  String currentRoomId = "";

  void setRoom(String id) {
    if (currentRoomId == id) {
      return;
    }

    currentRoomId = id;
    notifyListeners();
  }

  String _memberName(
    User user, [
    String? preferredName,
  ]) {
    final cleanPreferred = preferredName?.trim();

    if (cleanPreferred != null && cleanPreferred.isNotEmpty) {
      return cleanPreferred;
    }

    final displayName = user.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return user.email?.split('@').first ?? "Roommate";
  }

  String generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';

    final random = Random();

    return List.generate(
      6,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<String?> createRoom(
    String roomName,
    String memberName,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser!;

      final uid = user.uid;

      final cleanRoomName = roomName.trim();

      if (cleanRoomName.isEmpty) {
        return "Enter room name";
      }

      if (memberName.trim().isEmpty) {
        return "Enter your name";
      }

      final roomId = _firestore.collection('rooms').doc().id;

      final roomCode = generateCode().toUpperCase();

      lastRoomId = roomId;
      lastRoomCode = roomCode;
      currentRoomId = roomId;

      await _firestore.collection('rooms').doc(roomId).set({
        'roomId': roomId,
        'roomName': cleanRoomName,
        'roomCode': roomCode,
        'createdBy': uid,
        'createdAt': Timestamp.now(),
      });

      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('members')
          .doc(uid)
          .set({
        'uid': uid,
        'name': _memberName(user, memberName),
        'email': user.email,
        'score': 0,
        'joinedAt': Timestamp.now(),
      });

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> joinRoom(
    String code,
    String memberName,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser!;

      final uid = user.uid;

      final cleanCode = code.trim().toUpperCase();

      if (cleanCode.isEmpty) {
        return "Enter room code";
      }

      if (memberName.trim().isEmpty) {
        return "Enter your name";
      }

      final query = await _firestore
          .collection('rooms')
          .where(
            'roomCode',
            isEqualTo: cleanCode,
          )
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return "Invalid Room Code";
      }

      final roomDoc = query.docs.first;

      final roomId = roomDoc.id;

      lastRoomId = roomId;
      currentRoomId = roomId;
      lastRoomCode = cleanCode;

      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('members')
          .doc(uid)
          .set(
        {
          'uid': uid,
          'name': _memberName(user, memberName),
          'email': user.email,
          'score': 0,
          'joinedAt': Timestamp.now(),
        },
        SetOptions(
          merge: true,
        ),
      );

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getMembers() {
    final roomId = currentRoomId.isNotEmpty ? currentRoomId : lastRoomId;

    if (roomId.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('members')
        .orderBy('joinedAt')
        .snapshots();
  }

  Future<void> addScoreToCurrentUser(
    int points,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    final roomId = currentRoomId.isNotEmpty ? currentRoomId : lastRoomId;

    if (user == null || roomId.isEmpty) {
      return;
    }

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('members')
        .doc(user.uid)
        .set(
      {
        'uid': user.uid,
        'name': _memberName(user),
        'email': user.email,
        'score': FieldValue.increment(points),
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}
