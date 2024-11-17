import "package:flutter/material.dart";
import "package:happy_habit_at/providers/habit.dart";

/// A wrapper type around [Habit] that ensures that the [timeOfDay] property is not null.
///   This is dangerous as it defies the purpose of the nullable type, and should be used sparingly.
extension type DatedHabit(Habit self) implements Habit {
  TimeOfDay get timeOfDay => self.time!;
}
