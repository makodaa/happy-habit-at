import "package:flutter/foundation.dart";
import "package:happy_habit_at/screens/create_habit_screen.dart";

// CREATE TABLE IF NOT EXISTS habit (
//   habit_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   habit_name TEXT NOT NULL,
//   habit_description TEXT NOT NULL,
//   habit_goal TEXT NOT NULL,
//   habit_icon INTEGER NOT NULL
// );
class Habit extends ChangeNotifier {
  Habit({
    required this.habitId,
    required this.habitName,
    required this.habitDescription,
    required this.habitGoal,
    required this.habitIcon,
    required this.date,
    required this.time,
  });

  Habit.fromMap(Map<String, dynamic> map) {
    var {
      "habit_id": int habitId,
      "habit_name": String habitName,
      "habit_description": String habitDescription,
      "habit_goal": String habitGoal,
      "habit_icon": int habitIcon,
    } = map;

    // TODO(water-mizuu): Add validation for fields.

    this.habitId = habitId;
    this.habitName = habitName;
    this.habitDescription = habitDescription;
    this.habitGoal = habitGoal;
    this.habitIcon = habitIcon;
  }

  late final int habitId;
  late final List<DaysOfTheWeek> date;
  late ({int minutes,int seconds}) time;
  late String habitName;
  late String habitDescription;
  late String habitGoal;
  late int habitIcon;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "habit_id": habitId,
      "habit_name": habitName,
      "habit_description": habitDescription,
      "habit_goal": habitGoal,
      "habit_icon": habitIcon,
    };
  }

  void updateHabit({
    String? habitName,
    String? habitDescription,
    String? habitGoal,
    int? habitIcon,
  }) {
    this.habitName = habitName ?? this.habitName;
    this.habitDescription = habitDescription ?? this.habitDescription;
    this.habitGoal = habitGoal ?? this.habitGoal;
    this.habitIcon = habitIcon ?? this.habitIcon;
    notifyListeners();
  }
}
