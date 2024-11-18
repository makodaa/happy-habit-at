import "package:flutter/material.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:meta/meta.dart";

/// A wrapper type around [Habit] that ensures that the [time] property is not null.
///   This is dangerous as it defies the purpose of the nullable type, and should be used sparingly.
extension type TimedHabit(Habit self) implements Habit {
  @redeclare
  TimeOfDay get time => self.time!;
}
