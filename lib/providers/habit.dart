import "package:flutter/material.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";

// CREATE TABLE IF NOT EXISTS habit (
//   habit_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   habit_name TEXT NOT NULL,
//   habit_description TEXT,
//   habit_goal TEXT,
//   habit_icon INTEGER NOT NULL,
//   habit_days_of_the_week INTEGER NOT NULL,
//   habit_hour INTEGER,
//   habit_minute INTEGER
// );
class Habit extends ChangeNotifier {
  Habit({
    required this.habitId,
    required this.habitName,
    required this.habitDescription,
    required this.habitGoal,
    required this.habitIcon,
    required this.daysOfTheWeek,
    required this.time,
  });

  // ignore: prefer_constructors_over_static_methods
  static Habit fromMap(Map<String, dynamic> map) {
    var {
      "habit_id": int habitId,
      "habit_name": String habitName,
      "habit_description": String? habitDescription,
      "habit_goal": String? habitGoal,
      "habit_icon": int habitIcon,
      "habit_days_of_the_week": int daysOfTheWeek,
      "habit_hour": int? hour,
      "habit_minute": int? minute,
    } = map;

    return Habit(
      habitId: habitId,
      habitName: habitName,
      habitDescription: habitDescription,
      habitGoal: habitGoal,
      habitIcon: habitIcon,
      daysOfTheWeek: DaysOfTheWeek.fromBitValues(daysOfTheWeek),
      time: hour == null && minute == null ? null : TimeOfDay(hour: hour ?? 0, minute: minute ?? 0),
    );
  }

  final int habitId;
  String habitName;
  String? habitDescription;
  String? habitGoal;
  int habitIcon;
  final List<DaysOfTheWeek> daysOfTheWeek;
  TimeOfDay? time;

  Map<String, dynamic> toMap() {
    int daysOfTheWeek = this
        .daysOfTheWeek
        .map((DaysOfTheWeek day) => day.bitValue)
        .fold(0, (int acc, int day) => acc | day);

    return <String, dynamic>{
      "habit_id": habitId,
      "habit_name": habitName,
      "habit_description": habitDescription,
      "habit_goal": habitGoal,
      "habit_icon": habitIcon,
      "habit_days_of_the_week": daysOfTheWeek,
      "habit_hour": time?.hour,
      "habit_minute": time?.minute,
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
