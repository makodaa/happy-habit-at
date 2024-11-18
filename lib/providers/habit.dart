import "package:flutter/material.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

// CREATE TABLE IF NOT EXISTS habit (
//   habit_id INTEGER PRIMARY KEY AUTOINCREMENT,
//   habit_name TEXT NOT NULL,
//   habit_description TEXT,
//   habit_goal TEXT,
//   habit_icon INTEGER NOT NULL,
//   habit_days_of_the_week INTEGER NOT NULL,
//   habit_hour INTEGER,
//   habit_minute INTEGER,
//   habit_color_index INTEGER
// );
class Habit extends ChangeNotifier {
  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.goal,
    required this.icon,
    required List<DaysOfTheWeek> daysOfTheWeek,
    required this.time,
    required this.colorIndex,
  }) : _daysOfTheWeek = daysOfTheWeek;

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
      "habit_color_index": int? colorIndex,
    } = map;

    return Habit(
      id: habitId,
      name: habitName,
      description: habitDescription,
      goal: habitGoal,
      icon: habitIcon,
      daysOfTheWeek: DaysOfTheWeek.fromBitValues(daysOfTheWeek),
      time: hour == null && minute == null ? null : TimeOfDay(hour: hour ?? 0, minute: minute ?? 0),
      colorIndex: colorIndex,
    );
  }

  final int id;
  String name;
  String? description;
  String? goal;
  int icon;
  List<DaysOfTheWeek> _daysOfTheWeek;
  ImmutableList<DaysOfTheWeek> get daysOfTheWeek => ImmutableList<DaysOfTheWeek>(_daysOfTheWeek);
  TimeOfDay? time;
  int? colorIndex;

  void updateHabit({
    required String name,
    required String? description,
    required String? goal,
    required int icon,
    required List<DaysOfTheWeek> daysOfTheWeek,
    required TimeOfDay? time,
    required int? colorIndex,
  }) {
    this.name = name;
    this.description = description;
    this.goal = goal;
    this.icon = icon;
    _daysOfTheWeek = daysOfTheWeek;
    this.time = time;
    this.colorIndex = colorIndex;
    notifyListeners();
  }
}
