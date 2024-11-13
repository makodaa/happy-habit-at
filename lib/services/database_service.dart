// ignore_for_file: unnecessary_lambdas

import "dart:async";

import "package:flutter/foundation.dart";
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
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("""
            CREATE TABLE IF NOT EXISTS habit (
              habit_id INTEGER PRIMARY KEY AUTOINCREMENT,
              habit_name TEXT NOT NULL,
              habit_description TEXT NOT NULL,
              habit_goal TEXT NOT NULL,
              habit_icon INTEGER NOT NULL,
              habit_days_of_the_week INTEGER NOT NULL,
              habit_hour INTEGER,
              habit_minute INTEGER
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
              placement_plane INTEGER NOT NULL
            );
          """);
        },
      );

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

  /// Close the database when done
  Future<void> closeDB() async {
    await _database?.close();
  }
}
