import "package:flutter/foundation.dart";
import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/global/shared_preferences.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/providers/habitat_decoration.dart";
import "package:happy_habit_at/providers/placement.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/services/database_service.dart";
import "package:happy_habit_at/structs/completion.dart";
import "package:happy_habit_at/utils/data_types/listenable_list.dart";
import "package:happy_habit_at/utils/extension_types/immutable_listenable_list.dart";
import "package:happy_habit_at/utils/type_aliases.dart";

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

  final ListenableList<Completion> _completions = ListenableList<Completion>();
  ImmutableListenableList<Completion> get completions => _completions.immutable;

  final ListenableList<Placement> _placements = ListenableList<Placement>();
  ImmutableListenableList<Placement> get placements => _placements.immutable;

  final ListenableList<HabitatDecoration> _decorations = ListenableList<HabitatDecoration>();
  ImmutableListenableList<HabitatDecoration> get decorations => _decorations.immutable;

  late final ValueNotifier<int> currency;
  late final ValueNotifier<Room> activeRoom;

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

    for (Map<String, Object?> completionMap in await _database.readActivities()) {
      _completions.add(Completion.fromMap(completionMap));
    }

    for (Map<String, Object?> placementMap in await _database.readPlacements()) {
      _placements.add(Placement.fromMap(placementMap));
    }

    for (Map<String, Object?> decorationMap in await _database.readDecorations()) {
      _decorations.add(HabitatDecoration.fromMap(decorationMap));
    }

    /// Initialize the last active room.
    int? lastRoomId = sharedPreferences.getInt("last_open_room");
    if (lastRoomId == null) {
      /// Initialize new room.
      activeRoom = ValueNotifier<Room>(_rooms.first);
      await sharedPreferences.setInt("last_open_room", activeRoom.value.id);
    } else {
      /// Reload last room.
      activeRoom = ValueNotifier<Room>(_rooms.singleWhere((Room room) => room.id == lastRoomId));
    }

    /// Initialize the currency.
    int? currency = sharedPreferences.getInt("currency");
    if (currency == null) {
      /// Initialize
      this.currency = ValueNotifier<int>(0);
      await sharedPreferences.setInt("currency", 0);
    } else {
      this.currency = ValueNotifier<int>(currency);
    }
    this.currency.addListener(() async {
      await sharedPreferences.setInt("currency", this.currency.value);
    });

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

  Future<void> completeHabit({
    required int habitId,
    required int confidenceLevel,
    required DateTime dateTime,
  }) async {
    int? id = await _database.createActivity(
      dateTime: dateTime.millisecondsSinceEpoch,
      habitId: habitId,
    );

    if (id case int id) {
      _completions.add(
        Completion(
          id: id,
          habitId: habitId,
          dateTime: dateTime,
        ),
      );
    }
  }

  Future<void> createPlacement({
    required int roomId,
    required String decorationId,
    required IntVector tileCoordinate,
    required bool isFlipped,
  }) async {
    int? placementId = await _database.createPlacement(
      roomId: roomId,
      decorationId: decorationId,
      tileCoordinate: tileCoordinate,
      isFlipped: isFlipped,
    );

    if (placementId case int placementId) {
      _placements.add(
        Placement(
          placementId: placementId,
          roomId: roomId,
          decorationId: decorationId,
          tileCoordinate: tileCoordinate,
          isFlipped: isFlipped,
        ),
      );
    }
  }

  // READ
  Habit habitOfId(int habitId) {
    return _habits.singleWhere((Habit habit) => habit.id == habitId);
  }

  bool isCompleted(int habitId, DateTime date) {
    return _completions.any(
      (Completion completion) =>
          completion.habitId == habitId &&
          completion.dateTime.year == date.year &&
          completion.dateTime.month == date.month &&
          completion.dateTime.day == date.day,
    );
  }

  Completion? completionOfId(int habitId, DateTime date) {
    if (isCompleted(habitId, date)) {
      return _completions.firstWhere(
        (Completion completion) =>
            completion.habitId == habitId &&
            completion.dateTime.year == date.year &&
            completion.dateTime.month == date.month &&
            completion.dateTime.day == date.day,
      );
    }
    return null;
  }

  Map<DateTime, int> aggregateCompletions() {
    Map<DateTime, int> completionsMap = <DateTime, int>{};

    for (Completion completion in _completions) {
      completionsMap[completion.dateTime] = (completionsMap[completion.dateTime] ?? 0) + 1;
    }

    return completionsMap;
  }

  int? quantityOf(String decorationId) {
    return _decorations
        .where((HabitatDecoration decoration) => decoration.id == decorationId)
        .firstOrNull
        ?.quantityOwned;
  }

  Iterable<HabitatDecoration> ownedDecorations() {
    return _decorations.where((HabitatDecoration decoration) => decoration.quantityOwned > 0);
  }

  
  Iterable<Placement> readPlacements(int roomId) {
    return _placements.where((Placement placement) => placement.roomId == roomId);
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

  /// In committing the habitat changes, it will override the data of [activeRoom] in the database.
  Future<void> commitRoomChanges() async {
    await _database.updateRoom(
      id: activeRoom.value.id,
      name: activeRoom.value.name,
      size: activeRoom.value.size,
      tileId: activeRoom.value.tileId,
      petId: activeRoom.value.petId,
      petHunger: activeRoom.value.petHunger,
      petHappiness: activeRoom.value.petHappiness,
      petEnergy: activeRoom.value.petEnergy,
      petPosition: activeRoom.value.petPosition,
      petIsFlipped: activeRoom.value.petIsFlipped,
    );
  }

  Future<void> updatePlacement({
    required int placementId,
    required int roomId,
    required String decorationId,
    required IntVector tileCoordinate,
    required bool isFlipped,
  }) async {
    _placements.singleWhere((Placement placement) => placement.placementId == placementId)
      ..decorationId = decorationId
      ..isFlipped = isFlipped
      ..tileCoordinate = tileCoordinate;

    await _database.updatePlacement(
      placementId: placementId,
      roomId: roomId,
      decorationId: decorationId,
      tileCoordinate: tileCoordinate,
      isFlipped: isFlipped,
    );
  }
  

  // DELETE
  Future<void> deleteHabit({required int habitId}) async {
    if (await _database.deleteHabit(habitId: habitId)) {
      _habits.removeWhere((Habit habit) => habit.id == habitId);
    }
  }

  Future<void> removePlacement({required int placementId}) async {
    if (await _database.deletePlacement(placementId: placementId)) {
      _placements.removeWhere((Placement placement) => placement.placementId == placementId);
    }
  }
}
