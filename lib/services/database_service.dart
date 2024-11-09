import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

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
        onCreate: (Database db, int version) {
          // Run database creation code, e.g., creating tables
        },
      );
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
