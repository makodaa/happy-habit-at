// ignore_for_file: unnecessary_lambdas

import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/constants/food_icons.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/utils/extension_types/ids.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
import "package:happy_habit_at/utils/type_aliases.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

// ignore: always_specify_types
const tables = (
  habit: "habit",
  room: "room",
  decoration: "decoration",
  food: "food",
  pet: "pet",
  activity: "activity",
  placement: "placement",
);

/// SQLite Database Service
class DatabaseService {
  factory DatabaseService() => _instance;

  DatabaseService._internal();
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();

  // SQLite Database instance
  Database? _database;

  // Initialization of the database
  Future<void> initDB() async {
    if (_database != null) {
      return;
    }

    try {
      String path = join(await getDatabasesPath(), "app_database.db");
      _database = await openDatabase(
        path,
        version: 28,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          /// Drop all tables.
          if (kDebugMode) {
            print("Upgraded database. Removing all tables.");
          }
          await db.execute("""
            DROP TABLE IF EXISTS habit;
            DROP TABLE IF EXISTS decoration;
            DROP TABLE IF EXISTS furniture;
            DROP TABLE IF EXISTS food;
            DROP TABLE IF EXISTS pet;
            DROP TABLE IF EXISTS activity;
            DROP TABLE IF EXISTS room;
            DROP TABLE IF EXISTS placement;
            DROP TABLE IF EXISTS regularity;
            DROP TABLE IF EXISTS time;
          """);
        },
      );

      if (_database case Database database) {
        List<void> existingTables = await database.query(
          "sqlite_master",
          where: "type = ? AND name NOT LIKE ? AND name NOT LIKE ?",
          whereArgs: <String>["table", "sqlite_%", "android_%"],
        );

        print(existingTables);

        if (existingTables case []) {
          /// [habit] represents the different habits the user adds to the system.
          await database.execute("""
          CREATE TABLE IF NOT EXISTS habit (
            habit_id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_name TEXT NOT NULL,
            habit_description TEXT,
            habit_goal TEXT,
            habit_icon INTEGER NOT NULL,
            habit_days_of_the_week INTEGER NOT NULL,
            habit_hour INTEGER,
            habit_minute INTEGER,
            habit_color_index INTEGER
          );""");

          /// [room] represents the rooms that the user can create.
          ///   [room_tile_id] references the program constant defined in constants/tile_icons
          await database.execute("""
          CREATE TABLE IF NOT EXISTS room (
            room_id INTEGER PRIMARY KEY AUTOINCREMENT,
            room_name TEXT NOT NULL,
            room_size INTEGER NOT NULL,
            room_tile_id TEXT NOT NULL,
            pet_id INTEGER NOT NULL,
            pet_hunger INTEGER NOT NULL,
            pet_happiness INTEGER NOT NULL,
            pet_energy INTEGER NOT NULL,
            pet_x INTEGER NOT NULL,
            pet_y INTEGER NOT NULL,
            pet_is_flipped INTEGER NOT NULL
          );""");

          /// [decoration] represents the statistics of the decorations owned by the user.
          await database.execute("""
          CREATE TABLE IF NOT EXISTS decoration (
            decoration_id TEXT PRIMARY KEY,
            quantity_owned INTEGER NOT NULL,
            happiness_buff REAL NOT NULL,
            energy_buff REAL NOT NULL
          );""");

          /// [placement] represents each decoration placement
          await database.execute("""
          CREATE TABLE IF NOT EXISTS placement (
            placement_id INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id INTEGER NOT NULL REFERENCES room(room_id),
            decoration_id TEXT NOT NULL REFERENCES decoration(decoration_id),
            x_coordinate INTEGER NOT NULL,
            y_coordinate INTEGER NOT NULL,
            is_flipped INTEGER NOT NULL
          );""");

          /// [food] represents the statistics of the foods owned by the user.
          await database.execute("""
          CREATE TABLE IF NOT EXISTS food (
            food_id TEXT PRIMARY KEY,
            quantity_owned INTEGER NOT NULL
          );""");

          /// [pet] represents the stat of each pet.
          await database.execute("""
          CREATE TABLE IF NOT EXISTS pet (
            pet_id TEXT PRIMARY KEY,
            is_owned INTEGER NOT NULL,
            room_id INTEGER REFERENCES room(room_id)
          );""");

          /// Each row of [activity] represents a completed habit for a specific day.
          await database.execute("""
          CREATE TABLE IF NOT EXISTS activity (
            activity_id INTEGER PRIMARY KEY AUTOINCREMENT,
            date_time INTEGER NOT NULL,
            habit_id INTEGER NOT NULL REFERENCES habit(habit_id)
          );""");
        }

        /// If pets are not yet initialized, we initialize them.
        if ((await database.query(tables.pet)).length != petIcons.length) {
          for (PetId id in petIcons.keys) {
            await database.insert(
              "pet",
              <String, Object?>{
                "pet_id": id,
                "is_owned": 0,
                "room_id": null,
              },
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
            //TODO: check update
            await database.update(
              "pet",
              <String, Object?>{
                "is_owned": 1,
              },
              where: "pet_id = ?",
              whereArgs: <Object?>["1"],
            );
          }
        }

        /// If there are no rooms, we create a default one.
        if (await database.query(tables.room) case []) {
          PetId initialPet;

          List<Map<String, Object?>> ownedPets = await database.rawQuery(
            "SELECT pet_id FROM pet WHERE is_owned = 1",
          );

          if (ownedPets.isNotEmpty) {
            initialPet = PetId(ownedPets.first["pet_id"]! as String);
          } else {
            initialPet = petIcons.keys.first;

            /// We mark this initial pet as owned.
            ///   (Needs cleanup later. Possibly delimitation nalang ng app).

            int rowsAffected = await database.update(
              "pet",
              <String, Object?>{
                "is_owned": 1,
              },
              where: "pet_id = ?",
              whereArgs: <Object?>[initialPet],
            );

            if (kDebugMode) {
              print(
                "Set the pet [$initialPet] to owned as there are no owned pets.",
              );
              print(
                "In the recent transaction, there has been $rowsAffected rows affected.",
              );
            }
          }

          /// Ensure that we have a pet.
          if (kDebugMode) {
            print(
              "There are no rooms. Creating a default room with pet $initialPet.",
            );
          }

          await database.insert("room", <String, Object?>{
            "room_name": "Your First Room",
            "room_size": 5,
            "room_tile_id": "grass_dirt",
            "pet_id": "dog",
            "pet_hunger": 0,
            "pet_happiness": 100,
            "pet_energy": 100,
            "pet_x": 0,
            "pet_y": 0,
            "pet_is_flipped": 0,
          });
        }

        if ((await database.query(tables.decoration)).length != decorationIcons.length) {
          await database.delete(tables.decoration);
          for (var (DecorationId id, DecorationIcon decoration) in decorationIcons.pairs) {
            await database.insert(
              tables.decoration,
              <String, Object?>{
                "decoration_id": id,
                "quantity_owned": 0,
                "happiness_buff": decoration.happinessBuff,
                "energy_buff": decoration.energyBuff,
              },
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        }

        if ((await database.query(tables.food)).length != foodIcons.length) {
          await database.delete(tables.food);

          for (var (String id, FoodIcon _) in foodIcons.pairs) {
            await database.insert(
              tables.food,
              <String, Object?>{
                "food_id": id,
                "quantity_owned": 1,
              },
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        }

        if (kDebugMode) {
          String query = "SELECT name FROM sqlite_master WHERE type='table' "
              "AND name NOT LIKE 'sqlite_%'";

          unawaited(
            database.rawQuery(query).then(
              (List<Map<String, Object?>> value) {
                for (var {"name": String table as String} in value) {
                  database.query(table).then((List<Map<String, Object?>> value) {
                    print((table, value));
                  });
                }
                print("The database initialized with the following tables:");
                print(value);
              },
            ),
          );
        }
      }
    } on Object catch (e) {
      print("Error initializing database: $e");
    }
  }

  // CRUD operations

  // CREATE
  Future<int?> createHabit({
    required String name,
    required String? description,
    required String? goal,
    required int? icon,
    required int daysOfTheWeek,
    required TimeOfDay? time,
    required int? colorIndex,
  }) async {
    if (_database case Database database) {
      int id = await database.insert("habit", <String, Object?>{
        "habit_name": name,
        "habit_description": description,
        "habit_goal": goal,
        "habit_icon": icon,
        "habit_days_of_the_week": daysOfTheWeek,
        "habit_hour": time?.hour,
        "habit_minute": time?.minute,
        "habit_color_index": colorIndex,
      });

      if (kDebugMode) {
        print("Habit created: $name with id $id");
        print("The current habits are: ");
        print(await habitDebugDisplay());
      }

      return id;
    }

    return null;
  }

  Future<int?> createRoom({
    required String name,
    required int size,
    required String tileId,
    required int petId,
    required int petHunger,
    required int petHappiness,
    required int petEnergy,
    required (int, int) petPosition,
    required bool petIsFlipped,
  }) async {
    if (_database case Database database) {
      int id = await database.insert("room", <String, Object?>{
        "room_name": name,
        "pet_id": petId,
        "pet_hunger": petHunger,
        "pet_happiness": petHappiness,
        "pet_energy": petEnergy,
        "pet_x": petPosition.$1,
        "pet_y": petPosition.$2,
        "pet_is_flipped": petIsFlipped ? 1 : 0,
      });

      if (kDebugMode) {
        print("Room created: $name with id $id");
        print("The current rooms are: ");
        print(await roomDebugDisplay());
      }
    }
    return null;
  }

  Future<int?> createActivity({
    required int dateTime,
    required int habitId,
  }) async {
    if (_database case Database database) {
      int id = await database.insert("activity", <String, Object?>{
        "date_time": dateTime,
        "habit_id": habitId,
      });

      if (kDebugMode) {
        print("Activity created: $id");
      }

      return id;
    }

    return null;
  }

  Future<int?> createPlacement({
    required int roomId,
    required DecorationId decorationId,
    required IntVector tileCoordinate,
    required bool isFlipped,
  }) async {
    // placement_id INTEGER PRIMARY KEY AUTOINCREMENT,
    // room_id INTEGER NOT NULL REFERENCES room(room_id),
    // decoration_id TEXT NOT NULL REFERENCES decoration(decoration_id),
    // x_coordinate INTEGER NOT NULL,
    // y_coordinate INTEGER NOT NULL,
    // is_flipped INTEGER NOT NULL
    if (_database case Database database) {
      return database.insert(
        "placement",
        <String, Object?>{
          "room_id": roomId,
          "decoration_id": decorationId,
          "x_coordinate": tileCoordinate.$1,
          "y_coordinate": tileCoordinate.$2,
          "is_flipped": isFlipped ? 1 : 0,
        },
      );
    }

    return null;
  }

  // READ
  Future<List<Map<String, Object?>>> readHabits() async {
    if (_database case Database database) {
      return database.query("habit");
    }

    return <Map<String, Object?>>[];
  }

  Future<List<Map<String, Object?>>> readRooms() async {
    if (_database case Database database) {
      return database.query("room");
    }

    return <Map<String, Object?>>[];
  }

  Future<List<Map<String, Object?>>> readActivities() async {
    if (_database case Database database) {
      return database.query("activity");
    }

    return <Map<String, Object?>>[];
  }

  Future<List<Map<String, Object?>>> readPlacements() async {
    if (_database case Database database) {
      return database.query("placement");
    }

    return <Map<String, Object?>>[];
  }

  Future<List<Map<String, Object?>>> readDecorations() async {
    if (_database case Database database) {
      return database.query("decoration");
    }

    return <Map<String, Object?>>[];
  }

  Future<List<Map<String, Object?>>> readFoods() async {
    if (_database case Database database) {
      return database.query("food");
    }

    return <Map<String, Object?>>[];
  }

  Future<List<Map<String, Object?>>> readPets() async {
    if (_database case Database database) {
      return database.query("pet");
    }
    return <Map<String, Object?>>[];
  }

  // UPDATE
  Future<int?> updateHabit({
    required int id,
    required String name,
    required String? description,
    required String? goal,
    required int icon,
    required int daysOfTheWeek,
    required TimeOfDay? time,
    required int? colorIndex,
  }) async {
    if (_database case Database database) {
      try {
        await database.update(
          "habit",
          <String, Object?>{
            "habit_name": name,
            "habit_description": description,
            "habit_goal": goal,
            "habit_icon": icon,
            "habit_days_of_the_week": daysOfTheWeek,
            "habit_hour": time?.hour,
            "habit_minute": time?.minute,
            "habit_color_index": colorIndex,
          },
          where: "habit_id = ?",
          whereArgs: <int>[id],
        );

        if (kDebugMode) {
          print("Habit updated: $name with id $id");
          print("The current habits are: ");
          print(await habitDebugDisplay());
        }
      } on Object catch (e) {
        print("Error updating habit: $e");
      }
    }

    return null;
  }

  Future<int?> updateRoom({
    required int id,
    required String name,
    required int size,
    required String tileId,
    required PetId petId,
    required int petHunger,
    required int petHappiness,
    required int petEnergy,
    required (int, int) petPosition,
    required bool petIsFlipped,
  }) async {
    if (_database case Database database) {
      try {
        await database.update(
          "room",
          <String, Object?>{
            "room_name": name,
            "room_size": size,
            "room_tile_id": tileId,
            "pet_id": petId,
            "pet_hunger": petHunger,
            "pet_happiness": petHappiness,
            "pet_energy": petEnergy,
            "pet_x": petPosition.$1,
            "pet_y": petPosition.$2,
            "pet_is_flipped": petIsFlipped ? 1 : 0,
          },
          where: "room_id = ?",
          whereArgs: <int>[id],
        );

        if (kDebugMode) {
          print("Habit updated: $name with id $id");
          print("The current habits are: ");
          print(await roomDebugDisplay());
        }
      } on Object catch (e) {
        print("Error updating habit: $e");
      }
    }

    return null;
  }

  Future<void> updatePlacement({
    required int placementId,
    required int roomId,
    required DecorationId decorationId,
    required IntVector tileCoordinate,
    required bool isFlipped,
  }) async {
    if (_database case Database database) {
      await database.update(
        "placement",
        <String, Object?>{
          "room_id": roomId,
          "decoration_id": decorationId,
          "x_coordinate": tileCoordinate.$1,
          "y_coordinate": tileCoordinate.$2,
          "is_flipped": isFlipped ? 1 : 0,
        },
        where: "placement_id = ?",
        whereArgs: <int>[placementId],
      );
    }
  }

  // decoration_id TEXT PRIMARY KEY,
  // quantity_owned INTEGER NOT NULL,
  // happiness_buff REAL NOT NULL,
  // energy_buff REAL NOT NULL
  Future<void> updateDecoration({
    required DecorationId decorationId,
    required int quantityOwned,
    required double happinessBuff,
    required double energyBuff,
  }) async {
    if (_database case Database database) {
      await database.update(
        "decoration",
        <String, Object?>{
          "quantity_owned": quantityOwned,
          "happiness_buff": happinessBuff,
          "energy_buff": energyBuff,
        },
        where: "decoration_id = ?",
        whereArgs: <Object?>[decorationId],
      );
    }
  }

  Future<void> updatePet({
    required PetId petId,
    required int isOwned,
  }) async {
    if (_database case Database database) {
      await database.update(
        "pet",
        <String, Object?>{"is_owned": isOwned},
        where: "pet_id = ?",
        whereArgs: <Object?>[petId],
      );
    }
  }

  // DELETE
  Future<bool> deleteHabit({required int habitId}) async {
    if (_database case Database database) {
      await database.delete(
        "activity",
        where: "habit_id = ?",
        whereArgs: <int>[habitId],
      );

      await database.delete(
        "habit",
        where: "habit_id = ?",
        whereArgs: <int>[habitId],
      );

      return true;
    }

    return false;
  }

  Future<bool> deletePlacement({required int placementId}) async {
    if (_database case Database database) {
      await database.delete(
        "placement",
        where: "placement_id = ?",
        whereArgs: <int>[placementId],
      );

      return true;
    }

    return false;
  }

  /// Close the database when done
  Future<void> closeDB() async {
    await _database?.close();
  }

  // Minor operations:
  Future<String?> habitDebugDisplay() async =>
      _database?.query("habit").then((List<Map<String, Object?>> o) => o.join("\n"));

  Future<String?> roomDebugDisplay() async =>
      _database?.query("room").then((List<Map<String, Object?>> o) => o.join("\n"));
}
