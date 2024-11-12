import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/screens/create_habit_screen.dart";

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  //dummy
  List<Habit> habits = [
    Habit(
      habitId: 0,
      habitName: "Read something",
      habitDescription: "Read a few pages of your current book",
      habitGoal: "Read 3 pages",
      habitIcon: 1,
      date: <DaysOfTheWeek>[DaysOfTheWeek.sunday],
      time: (hour: 10, minute: 30),
    ),
    Habit(
      habitId: 1,
      habitName: "Exercise",
      habitDescription: "Do a quick workout session",
      habitGoal: "15 pushups",
      habitIcon: 2,
      date: <DaysOfTheWeek>[
        DaysOfTheWeek.monday,
        DaysOfTheWeek.wednesday,
        DaysOfTheWeek.friday
      ],
      time: (hour: 14, minute: 45),
    ),
    Habit(
      habitId: 2,
      habitName: "Meditate",
      habitDescription: "Relax and meditate",
      habitGoal: "Meditate for 5 minutes",
      habitIcon: 3,
      date: <DaysOfTheWeek>[DaysOfTheWeek.tuesday, DaysOfTheWeek.thursday],
      time: (hour: 17, minute: 00),
    ),
    Habit(
      habitId: 3,
      habitName: "Drink Water",
      habitDescription: "Stay hydrated by drinking water",
      habitGoal: "Drink a glass of water",
      habitIcon: 4,
      date: <DaysOfTheWeek>[
        DaysOfTheWeek.monday,
        DaysOfTheWeek.tuesday,
        DaysOfTheWeek.wednesday,
        DaysOfTheWeek.thursday,
        DaysOfTheWeek.friday
      ],
      time: (hour: 19, minute: 30),
    ),
    Habit(
      habitId: 4,
      habitName: "Practice Coding",
      habitDescription: "Spend time coding and improving skills",
      habitGoal: "Code for 20 minutes",
      habitIcon: 5,
      date: <DaysOfTheWeek>[DaysOfTheWeek.saturday],
      time: (hour: 21, minute: 30),
    ),
  ];
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    const Text(
                      "Past Due",
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: ListView(
                        children: <ListTile>[
                          for (Habit habit in habits)
                            if (habit.time.hour < 12)
                              ListTile(
                                leading: CircleAvatar(),
                                title: Text(habit.habitName),
                                subtitle: Text(habit.habitGoal),
                              ),
                        ],
                      ),
                    ),
                    const Text(
                      "Afternoon",
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: ListView(
                        children: <ListTile>[
                          for (Habit habit in habits)
                            if (12 <= habit.time.hour && habit.time.hour < 18)
                              ListTile(
                                leading: CircleAvatar(),
                                title: Text(habit.habitName),
                                subtitle: Text(habit.habitGoal),
                              ),
                        ],
                      ),
                    ),
                    const Text(
                      "Past Due",
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: ListView(
                        children: <ListTile>[
                          for (Habit habit in habits)
                            if (18 <= habit.time.hour && habit.time.hour < 24)
                              ListTile(
                                leading: CircleAvatar(),
                                title: Text(habit.habitName),
                                subtitle: Text(habit.habitGoal),
                              ),
                        ],
                      ),
                    ),
                  ],
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
}
