import 'package:flutter/material.dart';

class DutyProvider extends ChangeNotifier {
  final List<String> members = [
    "Akash",
    "Arpit",
    "Virat",
    "Dhoni",
  ];

  final List<String> duties = [
    "Dishes",
    "Trash",
    "Sweeping",
    "Bathroom",
  ];

  int week = 0;

  void nextWeek() {
    week++;
    notifyListeners();
  }

  List<Map<String, String>> assignments() {
    final result = <Map<String, String>>[];

    for (int i = 0; i < duties.length; i++) {
      result.add({
        "member": members[(i + week) % members.length],
        "duty": duties[i],
      });
    }

    return result;
  }
}
