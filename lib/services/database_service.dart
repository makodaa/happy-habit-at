// ignore_for_file: unnecessary_lambdas

import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

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
        version: 4,
        onUpgrade: (Database db, int oldVersion, int newVersion) {
          /// Drop all tables.
          if (kDebugMode) {
            print("Upgraded database. Removing all tables.");
          }
          db.execute("""
            DROP TABLE IF EXISTS habit;
            DROP TABLE IF EXISTS furniture;
            DROP TABLE IF EXISTS food;
            DROP TABLE IF EXISTS pet;
            DROP TABLE IF EXISTS activity;
            DROP TABLE IF EXISTS room;
            DROP TABLE IF EXISTS placement;
          """);
        },
      );

      await _database?.execute("""
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
        );
        
        CREATE TABLE IF NOT EXISTS furniture (
          furniture_id INTEGER PRIMARY KEY AUTOINCREMENT,
          furniture_name TEXT NOT NULL,
          furniture_description TEXT NOT NULL,
          sale_price INTEGER NOT NULL,
          resale_price INTEGER NOT NULL,
          quantity_owned INTEGER NOT NULL,
          happiness_buff REAL NOT NULL,
          energy_buff REAL NOT NULL,
          placement_plane INTEGER NOT NULL
        );

        CREATE TABLE IF NOT EXISTS food (
          food_id INTEGER PRIMARY KEY AUTOINCREMENT,
          food_name TEXT NOT NULL,
          food_description TEXT NOT NULL,
          sale_price INTEGER NOT NULL,
          quantity_owned INTEGER NOT NULL,
          happiness_buff REAL NOT NULL,
          hunger_buff REAL NOT NULL,
          energy_buff REAL NOT NULL
        );

        CREATE TABLE IF NOT EXISTS pet (
          pet_id INTEGER PRIMARY KEY AUTOINCREMENT,
          pet_name TEXT NOT NULL,
          pet_model TEXT NOT NULL,
          pet_rarity TEXT NOT NULL,
          is_owned INTEGER NOT NULL
        );

        CREATE TABLE IF NOT EXISTS activity (
          activity_id INTEGER PRIMARY KEY AUTOINCREMENT,
          day STRING NOT NULL,
          habits BLOB NOT NULL
        );

        CREATE TABLE IF NOT EXISTS room (
          room_id INTEGER PRIMARY KEY AUTOINCREMENT,
          room_name TEXT NOT NULL,
          pet_id INTEGER NOT NULL,
          pet_hunger INTEGER NOT NULL,
          pet_happiness INTEGER NOT NULL,
          pet_energy INTEGER NOT NULL,
          pet_x INTEGER NOT NULL,
          pet_y INTEGER NOT NULL,
          pet_orientation INTEGER NOT NULL
        );

        CREATE TABLE IF NOT EXISTS placement (
          placement_id INTEGER PRIMARY KEY AUTOINCREMENT,
          room_id INTEGER NOT NULL,
          furniture_id INTEGER NOT NULL,
          x_coordinate INTEGER NOT NULL,
          y_coordinate INTEGER NOT NULL,
          is_facing_left INTEGER NOT NULL
        );
      """);

      if (kDebugMode) {
        String query = "SELECT name FROM sqlite_master WHERE type='table' "
            "AND name NOT LIKE 'sqlite_%'";

        unawaited(
          _database?.rawQuery(query).then(
            (List<Map<String, Object?>> value) {
              print("The database initialized with the following tables:");
              print(value);
            },
          ),
        );
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

  // READ
  Future<List<Map<String, Object?>>> readHabits() async {
    if (_database case Database database) {
      return database.query("habit");
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

  // DELETE
  Future<bool> deleteHabit({required int habitId}) async {
    if (_database case Database database) {
      await database.delete(
        "habit",
        where: "habit_id = ?",
        whereArgs: <int>[habitId],
      );

      if (kDebugMode) {
        print("Habit deleted: $habitId");
        print("The current habits are: ");
        print(await habitDebugDisplay());
      }

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
}
