import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/services/database_service.dart";
import "package:happy_habit_at/utils/data_types/listenable_list.dart";
import "package:happy_habit_at/utils/extension_types/listenable_immutable_list.dart";

/// Following some pattern online, this class is going to be
///   a holder of [ValueListenable] type objects.
/// Each publicly accessible object shall be:
///   1. Listenable.
///   2. Immutable (By extension types).
class AppState {
  bool _hasInitialized = false;

  DatabaseService _database = DatabaseService();

  final ListenableList<Habit> _habits = ListenableList<Habit>();
  ListenableImmutableList<Habit> get habits => ListenableImmutableList<Habit>(_habits);

  Future<void> init() async {
    if (_hasInitialized) {
      return;
    }

    // Initialization code here
    await _database.initDB();

    for (Map<String, Object?> habitMap in await _database.readHabits()) {
      _habits.add(Habit.fromMap(habitMap));
    }

    _hasInitialized = true;
  }

  Future<void> createHabit({
    required String habitName,
    required String? habitDescription,
    required String? habitGoal,
    required int habitIcon,
    required int daysOfTheWeek,
    required TimeOfDay? time,
  }) async {
    int? id = await _database.createHabit(
      habitName: habitName,
      habitDescription: habitDescription,
      habitGoal: habitGoal,
      habitIcon: habitIcon,
      daysOfTheWeek: daysOfTheWeek,
      time: time,
    );

    if (id != null) {
      _habits.add(
        Habit(
          habitId: id,
          habitName: habitName,
          habitDescription: habitDescription,
          habitGoal: habitGoal,
          habitIcon: habitIcon,
          daysOfTheWeek: DaysOfTheWeek.fromBitValues(daysOfTheWeek),
          time: time,
        ),
      );
    }
  }

  Future<void> deleteHabit({required int habitId}) async {
    if (await _database.deleteHabit(habitId: habitId)) {
      _habits.removeWhere((Habit habit) => habit.habitId == habitId);
    }
  }
}
