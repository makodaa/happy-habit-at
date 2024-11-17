import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/utils/extension_types/dated_habit.dart";
import "package:happy_habit_at/utils/extension_types/listenable_immutable_list.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumEaseInOut());

  ListenableImmutableList<Habit>? habits;

  @override
  void initState() {
    super.initState();

    AppState state = context.read<AppState>();

    habits = state.habits..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /// APPBAR
            AppBar(
              title: const Text("Today"),
              elevation: 1.0,
              shadowColor: Colors.black,
            ),

            /// BODY
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _displayedHabits(),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: FloatingActionButton(
            onPressed: () => context.goNamed("createHabit"),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Column _displayedHabits() {
    print((habits: habits));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _horizontalCalendar(),
        const SizedBox(height: 16.0),
        if (habits == null) ...<Widget>[
          const Center(
            child: CircularProgressIndicator(),
          ),
        ] else if (habits case ListenableImmutableList<Habit> habits) ...<Widget>[
          if (habits.isEmpty)
            Center(
              child: Text("You have no habits for today!"),
            ),
          if (habits.undatedHabits case Iterable<Habit> undatedHabits
              when undatedHabits.isNotEmpty) ...<Widget>[
            const Text(
              "Undated",
            ),
            const SizedBox(height: 4.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <ListTile>[
                for (Habit habit in undatedHabits) _habitTile(habit),
              ],
            ),
          ],
          if (habits.datedHabits.where((DatedHabit h) => h.time!.hour.isWithin(0, 12)).toList()
              case List<Habit> capturedHabits //
              when capturedHabits.isNotEmpty) ...<Widget>[
            const Text("Morning"),
            const SizedBox(height: 4.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <ListTile>[
                for (Habit habit in capturedHabits) _habitTile(habit),
              ],
            ),
          ],
          if (habits.datedHabits.where((DatedHabit h) => h.time!.hour.isWithin(12, 18)).toList()
              case List<Habit> capturedHabits //
              when capturedHabits.isNotEmpty) ...<Widget>[
            const Text("Afternoon"),
            const SizedBox(height: 4.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <ListTile>[
                for (Habit habit in capturedHabits) _habitTile(habit),
              ],
            ),
          ],
          if (habits.datedHabits.where((DatedHabit h) => h.time!.hour.isWithin(18, 24)).toList()
              case List<Habit> capturedHabits //
              when capturedHabits.isNotEmpty) ...<Widget>[
            const Text("Evening"),
            const SizedBox(height: 4.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <ListTile>[
                for (Habit habit in capturedHabits) _habitTile(habit),
              ],
            ),
          ],
        ],
      ],
    );
  }

  ListTile _habitTile(Habit habit) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(habit.habitName),
      subtitle: habit.habitGoal != null ? Text(habit.habitGoal!) : null,
      onTap: () async {
        await _showModal(habit);
      },
    );
  }

  ColoredBox _horizontalCalendar() {
    return ColoredBox(
      color: Colors.lightBlue.shade300,
      child: SizedBox(
        height: 64,
        child: Center(child: Text("To Implement: Horizontal Calendar")),
      ),
    );
  }

  Future<void> _showModal(Habit habit) async {
    await showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints.expand(),
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  habit.habitName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 16.0),
                if (habit.habitDescription case String description) ...<Widget>[
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(description),
                  SizedBox(height: 16.0),
                ],
                if (habit.habitGoal case String goal) ...<Widget>[
                  Text(
                    "Goal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(goal),
                  SizedBox(height: 16.0),
                ],
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          context.read<AppState>().deleteHabit(habitId: habit.habitId);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Delete Habit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "View Habit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Complete Habit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension on ListenableImmutableList<Habit> {
  Iterable<DatedHabit> get datedHabits sync* {
    for (Habit habit in this) {
      if (habit.time != null) {
        yield DatedHabit(habit);
      }
    }
  }

  Iterable<Habit> get undatedHabits sync* {
    for (Habit habit in this) {
      if (habit.time == null) {
        yield habit;
      }
    }
  }
}

extension on int {
  bool isWithin(int start, int end) => start <= this && this < end;
}
