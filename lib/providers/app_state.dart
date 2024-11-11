import "package:flutter/material.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/services/database_service.dart";

class AppState with ChangeNotifier {
  DatabaseService _database = DatabaseService();

  Future<void> init() async {
    // Initialization code here
    await _database.initDB();
  }

  Future<void> createHabit(Habit habit) async {}
}
