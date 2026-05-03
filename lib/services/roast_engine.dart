import 'dart:math';

class RoastEngine {
  static final Random _random =
      Random();

  static String randomFrom(
    List<String> list,
  ) {
    return list[
        _random.nextInt(
            list.length)];
  }

  static String pendingTask(
    String name,
    int days,
  ) {
    final lines = [
      "$name ignored chores for $days days. Plate archaeology underway.",
      "$name and responsibility are no longer on speaking terms.",
      "$name saw the mess and chose philosophy instead.",
      "$days days later, $name still studies the dishes from afar.",
    ];

    return randomFrom(lines);
  }

  static String debt(
    String name,
    double amount,
  ) {
    final lines = [
      "$name owes ₹${amount.toStringAsFixed(0)} and emotional closure.",
      "$name has delayed ₹${amount.toStringAsFixed(0)} like a government file.",
      "$name still owes ₹${amount.toStringAsFixed(0)}. Bold strategy.",
    ];

    return randomFrom(lines);
  }

  static String champion(
    String name,
  ) {
    final lines = [
      "$name carried this household harder than the Wi-Fi router.",
      "$name remains the only functioning department.",
      "$name is doing chores while others study invisibility.",
    ];

    return randomFrom(lines);
  }

  static String lazy(
    String name,
  ) {
    final lines = [
      "$name is committed to avoiding effort.",
      "$name moved less than the furniture.",
      "$name contributes mainly vibes.",
    ];

    return randomFrom(lines);
  }

  static String roomChaos(
    int tasks,
  ) {
    final lines = [
      "$tasks pending chores. Civilization fading.",
      "$tasks tasks remain. Dust now has voting rights.",
      "$tasks tasks pending. This room is folklore now.",
      "$tasks unfinished chores. Nature is reclaiming territory.",
    ];

    return randomFrom(lines);
  }

  static String completed(
    String name,
  ) {
    final lines = [
      "$name completed a task. Miracles continue.",
      "$name worked today. Historic footage.",
      "$name touched responsibility and survived.",
    ];

    return randomFrom(lines);
  }
}