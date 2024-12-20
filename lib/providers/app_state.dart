import "package:flutter/foundation.dart";
import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/constants/expansion_rules.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/global/shared_preferences.dart";
import "package:happy_habit_at/providers/food.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/providers/habitat_decoration.dart";
import "package:happy_habit_at/providers/pet.dart";
import "package:happy_habit_at/providers/placement.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/services/database_service.dart";
import "package:happy_habit_at/structs/completion.dart";
import "package:happy_habit_at/utils/data_types/listenable_list.dart";
import "package:happy_habit_at/utils/data_types/listenable_set.dart";
import "package:happy_habit_at/utils/extension_types/ids.dart";
import "package:happy_habit_at/utils/extension_types/immutable_listenable_list.dart";
import "package:happy_habit_at/utils/extension_types/immutable_listenable_set.dart";
import "package:happy_habit_at/utils/type_aliases.dart";

/// Following some pattern online, this class is going to be
///   a holder of [ValueListenable] type objects.
/// Each publicly accessible object shall be:
///   1. Listenable.
///   2. Immutable (By extension types).
class AppState {
  bool _hasInitialized = false;

  final DatabaseService _database = DatabaseService();

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

  final ListenableSet<DecorationId> _ownedDecorations = ListenableSet<DecorationId>();
  ImmutableListenableSet<DecorationId> get ownedDecorations => _ownedDecorations.immutable;

  final ListenableList<Pet> _pets = ListenableList<Pet>();
  ImmutableListenableList<Pet> get pets => _pets.immutable;

  final ListenableSet<PetId> _ownedPets = ListenableSet<PetId>();
  ImmutableListenableSet<PetId> get ownedPets => _ownedPets.immutable;

  final ListenableList<Food> _foods = ListenableList<Food>();
  ImmutableListenableList<Food> get foods => _foods.immutable;

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
      if (!decorationIcons.keys.any((DecorationId id) => id == placementMap["decoration_id"])) {
        if (kDebugMode) {
          print("Placement ${placementMap["placement_id"]} has an invalid decoration id.");
          print("Therefore, it will be removed.");
        }

        await _database.deletePlacement(placementId: placementMap["placement_id"]! as int);
      }
      _placements.add(Placement.fromMap(placementMap));
    }

    for (Map<String, Object?> decorationMap in await _database.readDecorations()) {
      _decorations.add(HabitatDecoration.fromMap(decorationMap));
    }

    for (HabitatDecoration decoration in _decorations) {
      if (decoration.quantityOwned > 0) {
        _ownedDecorations.add(decoration.id);
      }
    }

    for (Map<String, Object?> foodMap in await _database.readFoods()) {
      _foods.add(Food.fromMap(foodMap));
    }

    for (Map<String, Object?> pet in await _database.readPets()) {
      _pets.add(Pet.fromMap(pet));
    }

    for (Pet pet in _pets) {
      if (pet.isOwned != 0) {
        _ownedPets.add(pet.id);
      }
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
    // this.currency.value += 100000;

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
    required DecorationId decorationId,
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
      /// We reduce the quantity of the owned decoration.
      HabitatDecoration decoration = _decorations.singleWhere(
        (HabitatDecoration d) => d.id == decorationId,
      );
      decoration.quantityOwned--;
      if (decoration.quantityOwned <= 0) {
        _ownedDecorations.remove(decoration.id);
      }

      await _database.updateDecoration(
        decorationId: decorationId,
        quantityOwned: decoration.quantityOwned,
        happinessBuff: decoration.happinessBuff,
        energyBuff: decoration.energyBuff,
      );

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

  List<Habit> completionsAtDate(DateTime date) {
    return _completions
        .where(
          (Completion completion) =>
              completion.dateTime.year == date.year &&
              completion.dateTime.month == date.month &&
              completion.dateTime.day == date.day,
        )
        .map((Completion p) => p.habitId)
        .map((int p) => _habits.firstWhere((Habit h) => h.id == p))
        .toList();
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
      DateTime date = completion.dateTime.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      completionsMap[date] = (completionsMap[date] ?? 0) + 1;
    }

    return completionsMap;
  }

  int? quantityOfDecoration(DecorationId decorationId) {
    return _decorations
        .where((HabitatDecoration decoration) => decoration.id == decorationId)
        .firstOrNull
        ?.quantityOwned;
  }

  int? quantityOfFood(String foodId) {
    return _foods //
        .where((Food food) => food.id == foodId)
        .firstOrNull
        ?.quantityOwned;
  }

  Iterable<Placement> readPlacements(int roomId) {
    return _placements.where((Placement placement) => placement.roomId == roomId);
  }

  HabitatDecoration decorationOf(DecorationId decorationId) {
    return _decorations
        .singleWhere((HabitatDecoration decoration) => decoration.id == decorationId);
  }

  int placementsOfDecoration(DecorationId decorationId) {
    return _placements
        .where((Placement placement) => placement.decorationId == decorationId)
        .length;
  }

  List<PetId> get notOwnedPets {
    return petIcons.entries
        .where((MapEntry<PetId, PetIcon> entry) => !_ownedPets.contains(entry.key))
        .map((MapEntry<PetId, PetIcon> entry) => entry.key)
        .toList();
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
    required DecorationId decorationId,
    required IntVector tileCoordinate,
    required bool isFlipped,
  }) async {
    _placements.singleWhere((Placement placement) => placement.placementId == placementId)
      ..decorationId = decorationId
      ..isFlipped = isFlipped
      ..tileCoordinate = tileCoordinate;

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _placements.notifyListeners();

    await _database.updatePlacement(
      placementId: placementId,
      roomId: roomId,
      decorationId: decorationId,
      tileCoordinate: tileCoordinate,
      isFlipped: isFlipped,
    );
  }

  Future<void> buyDecoration(DecorationId decorationId) async {
    DecorationIcon decoration = decorationIcons[decorationId]!;
    HabitatDecoration decorationInfo = _decorations.singleWhere(
      (HabitatDecoration d) => d.id == decorationId,
    );

    if (currency.value < decoration.salePrice) {
      return;
    }
    decorationInfo.quantityOwned++;
    if (!_ownedDecorations.any((DecorationId id) => id == decorationId) &&
        decorationInfo.quantityOwned > 0) {
      _ownedDecorations.add(decorationInfo.id);
    }

    await _database.updateDecoration(
      decorationId: decorationId,
      quantityOwned: decorationInfo.quantityOwned,
      happinessBuff: decorationInfo.happinessBuff,
      energyBuff: decorationInfo.energyBuff,
    );

    currency.value -= decoration.salePrice;
  }

  Future<void> ownPet(PetId petId) async {
    ///

    _ownedPets.add(petId);
    await _database.updatePet(petId: petId, isOwned: 1);
    currency.value -= 150;
  }

  Future<void> sellDecoration(DecorationId decorationId) async {
    assert(ownedDecorations.any((DecorationId id) => id == decorationId));
    DecorationIcon decoration = decorationIcons[decorationId]!;
    HabitatDecoration decorationInfo = _decorations.singleWhere(
      (HabitatDecoration d) => d.id == decorationId,
    );

    if (decorationInfo.quantityOwned <= 0) {
      return;
    }

    decorationInfo.quantityOwned--;
    if (_ownedDecorations.any((DecorationId id) => id == decorationId) &&
        decorationInfo.quantityOwned <= 0) {
      _ownedDecorations.remove(decorationInfo.id);
    }

    await _database.updateDecoration(
      decorationId: decorationId,
      quantityOwned: decorationInfo.quantityOwned,
      happinessBuff: decorationInfo.happinessBuff,
      energyBuff: decorationInfo.energyBuff,
    );

    currency.value += decoration.resalePrice;
  }

  Future<void> buyExpansion(int roomId) async {
    Room room = _rooms.singleWhere((Room room) => room.id == roomId);
    if (expansionRules[room.size] case (:int cost, size: _)) {
      if (currency.value < cost) {
        return;
      }

      currency.value -= cost;

      await expandRoom(roomId);
    }
  }

  Future<void> expandRoom(int roomId) async {
    Room room = _rooms.singleWhere((Room room) => room.id == roomId);
    ({int cost, int size})? expansionRule = expansionRules[room.size];
    if (expansionRule == null) {
      return;
    }
    room.size = expansionRule.size;

    room.updateRoom(
      name: room.name,
      size: room.size,
      tileId: room.tileId,
      petId: room.petId,
      petHunger: room.petHunger,
      petHappiness: room.petHappiness,
      petEnergy: room.petEnergy,
      petPosition: room.petPosition,
      petIsFlipped: room.petIsFlipped,
    );

    await _database.updateRoom(
      id: room.id,
      name: room.name,
      size: room.size,
      tileId: room.tileId,
      petId: room.petId,
      petHunger: room.petHunger,
      petHappiness: room.petHappiness,
      petEnergy: room.petEnergy,
      petPosition: room.petPosition,
      petIsFlipped: room.petIsFlipped,
    );
  }

  // DELETE
  Future<void> deleteHabit({required int habitId}) async {
    if (await _database.deleteHabit(habitId: habitId)) {
      _habits.removeWhere((Habit habit) => habit.id == habitId);
    }
  }

  Future<void> deletePlacement({required int placementId}) async {
    if (await _database.deletePlacement(placementId: placementId)) {
      Placement placementToRemove = _placements.firstWhere(
        (Placement placement) => placement.placementId == placementId,
      );
      _placements.remove(placementToRemove);

      HabitatDecoration decoration = _decorations.singleWhere(
        (HabitatDecoration d) => d.id == placementToRemove.decorationId,
      );
      decoration.quantityOwned++;
      if (decoration.quantityOwned > 0) {
        _ownedDecorations.add(decoration.id);
      }

      await _database.updateDecoration(
        decorationId: placementToRemove.decorationId,
        quantityOwned: decoration.quantityOwned,
        happinessBuff: decoration.happinessBuff,
        energyBuff: decoration.energyBuff,
      );
    }
  }
}
