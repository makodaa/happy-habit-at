import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/global/shared_preferences.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/providers/services/database_service.dart";
import "package:happy_habit_at/utils/data_types/listenable_list.dart";
import "package:happy_habit_at/utils/extension_types/immutable_listenable_list.dart";

/// Following some pattern online, this class is going to be
///   a holder of [ValueListenable] type objects.
/// Each publicly accessible object shall be:
///   1. Listenable.
///   2. Immutable (By extension types).
class AppState {
  bool _hasInitialized = false;

  DatabaseService _database = DatabaseService();

  final ListenableList<Habit> _habits = ListenableList<Habit>();
  ImmutableListenableList<Habit> get habits => _habits.immutable;

  final ListenableList<Room> _rooms = ListenableList<Room>();
  ImmutableListenableList<Room> get rooms => _rooms.immutable;

  Room? _activeRoom;
  Room get activeRoom => _activeRoom!;

  Future<void> init() async {
    if (_hasInitialized) {
      return;
    }

    // Initialization code here
    await _database.initDB();

    for (Map<String, Object?> habitMap in await _database.readHabits()) {
      _habits.add(Habit.fromMap(habitMap));
    }

    for (Map<String, Object?> roomMap in await _database.readRooms()) {
      _rooms.add(Room.fromMap(roomMap));
    }

    // TODO(water-mizuu): Finish this
    int? lastRoom = sharedPreferences.getInt("last_open_room");

    _hasInitialized = true;
  }

  // CREATE

  Future<void> createHabit({
    required String name,
    required String? description,
    required String? goal,
    required int icon,
    required int daysOfTheWeek,
    required TimeOfDay? time,
    required int? colorIndex,
  }) async {
    int? id = await _database.createHabit(
      name: name,
      description: description,
      goal: goal,
      icon: icon,
      daysOfTheWeek: daysOfTheWeek,
      time: time,
      colorIndex: colorIndex,
    );

    if (id != null) {
      _habits.add(
        Habit(
          id: id,
          name: name,
          description: description,
          goal: goal,
          icon: icon,
          daysOfTheWeek: DaysOfTheWeek.fromBitValues(daysOfTheWeek),
          time: time,
          colorIndex: colorIndex,
        ),
      );
    }
  }

  // READ
  Habit habitOfId(int habitId) {
    return _habits.singleWhere((Habit habit) => habit.id == habitId);
  }

  // UPDATE

  Future<void> updateHabit({
    required int id,
    required String name,
    required String? description,
    required String? goal,
    required int icon,
    required int daysOfTheWeek,
    required TimeOfDay? time,
    required int? colorIndex,
  }) async {
    _habits.singleWhere((Habit habit) => habit.id == id).updateHabit(
          name: name,
          description: description,
          goal: goal,
          icon: icon,
          daysOfTheWeek: DaysOfTheWeek.fromBitValues(daysOfTheWeek),
          time: time,
          colorIndex: colorIndex,
        );

    await _database.updateHabit(
      id: id,
      name: name,
      description: description,
      goal: goal,
      icon: icon,
      daysOfTheWeek: daysOfTheWeek,
      time: time,
      colorIndex: colorIndex,
    );
  }

  // DELETE
  Future<void> deleteHabit({required int habitId}) async {
    if (await _database.deleteHabit(habitId: habitId)) {
      _habits.removeWhere((Habit habit) => habit.id == habitId);
    }
  }
}
