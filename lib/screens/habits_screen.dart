import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/constants/habit_colors.dart";
import "package:happy_habit_at/constants/habit_icons.dart";
import "package:happy_habit_at/enums/days_of_the_week.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/structs/completion.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";
import "package:happy_habit_at/utils/extension_types/immutable_listenable_list.dart";
import "package:happy_habit_at/utils/extension_types/timed_habit.dart";
import "package:happy_habit_at/utils/extensions/monadic_nullable.dart";
import "package:happy_habit_at/widgets/horizontal_calendar.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late final AnimatedScrollController scrollController =
      AnimatedScrollController(animationFactory: ChromiumImpulse());

  late final AppState appState;
  late final ImmutableListenableList<Habit> habits;
  late DateTime selectedDate = _currentDay();
  double _currentSliderValue = 0;

  int _evaluateReflection(String text) {
    return text.hashCode & 0xfff;
  }

  @override
  void initState() {
    super.initState();

    appState = context.read<AppState>();
    habits = appState.habits..addListener(() => setState(() {}));
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
              title: const Center(child: Text("Habits")),
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

  Widget _displayedHabits() {
    const List<(String title, (int start, int end))> partitions = <(String, (int, int))>[
      ("Morning", (0, 12)),
      ("Afternoon", (12, 18)),
      ("Evening", (18, 24)),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _horizontalCalendar(constraints),
            const SizedBox(height: 16.0),
            if (habits.forDate(selectedDate).isEmpty)
              Center(
                child: Text(
                  "You have no habits for ${selectedDate.isAtSameMomentAs(_currentDay()) ? "today" : "this day"}.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (habits.noTimeHabits(selectedDate) //
                case Iterable<Habit> noTimeHabits //
                when noTimeHabits.isNotEmpty) ...<Widget>[
              const Text("No time set"),
              const SizedBox(height: 4.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (Habit habit in noTimeHabits) _habitTile(habit),
                ],
              ),
            ],
            for (var (String title, (int s, int e)) in partitions)
              if (habits
                      .timedHabits(selectedDate)
                      .where((TimedHabit h) => h.time.hour.isWithin(s, e))
                      .toList()
                  case List<Habit> capturedHabits //
                  when capturedHabits.isNotEmpty) ...<Widget>[
                Text(title),
                const SizedBox(height: 4.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (Habit habit in capturedHabits) _habitTile(habit),
                  ],
                ),
              ],
          ],
        );
      },
    );
  }

  Widget _habitTile(Habit habit) {
    return ListenableBuilder(
      listenable: habit,
      builder: (BuildContext context, Widget? child) {
        if (habit.daysOfTheWeek.isNotEmpty &&
            !habit.daysOfTheWeek.contains(DaysOfTheWeek.values[selectedDate.weekday % 7])) {
          return const SizedBox.shrink();
        }

        DateTime today = _currentDay();
        bool isCompleted = appState.isCompleted(habit.id, selectedDate);
        bool isCompletedBefore = appState.isCompleted(habit.id, selectedDate);
        bool isBeforeToday = selectedDate.isBefore(today);
        bool isAfterToday = selectedDate.isAfter(today);

        int dayDifference = today.difference(selectedDate).inDays.abs();

        String? description = appState
            .completionOfId(habit.id, selectedDate) //
            .nullableMap((Completion c) => c.dateTime.difference(today))
            .nullableMap(_description)
            .nullableMap((String d) => "Completed $d ago");

        DateTime? dateTimeOfHabitTime = habit.time.nullableMap(
          (TimeOfDay t) => DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            t.hour,
            t.minute,
          ),
        );

        /// This should result in 'Due ${description} ago' if the habit was due today.
        String? agoDescription = dateTimeOfHabitTime
            .nullableMap((DateTime p) => _rightNow().difference(p))
            .nullableMap(_description)
            .nullableMap((String p) => "Due $p ago");

        /// This should result in 'In ${description}' if the habit is due today.
        String? fromNowDescription = dateTimeOfHabitTime
            .nullableMap((DateTime p) => p.difference(_rightNow()))
            .nullableMap(_description)
            .nullableMap((String p) => "In $p");

        String trailing = isBeforeToday
            ? "${isCompletedBefore ? "Completed " : ""}"
                "$dayDifference day${dayDifference > 1 ? "s" : ""} ago"
            : isAfterToday
                ? "In $dayDifference day${dayDifference > 1 ? "s" : ""}"
                : isCompleted
                    ? description ?? "Completed"
                    : fromNowDescription.nullableFlatMap(
                          (String p) => p == "In " ? agoDescription : null,
                        ) ??
                        "Within today";

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: habit.colorIndex.nullableMap((int i) => habitColors[i].background),
            child: Icon(habitIcons[habit.icon]),
          ),
          title: Text(habit.name),
          subtitle: habit.goal.nullableMap((String g) => Text(g)),
          trailing: Text(trailing),
          onTap: () async {
            await _showHabitInformationModal(habit);
          },
        );
      },
    );
  }

  Widget _horizontalCalendar(BoxConstraints constraints) {
    DateTime now = _currentDay();

    return HorizontalCalendar(
      initialDate: now,
      selectedDate: selectedDate,
      onTap: (DateTime date) {
        setState(() {
          selectedDate = date;
        });
      },
    );
  }

  Future<void> _showHabitInformationModal(Habit habit) async {
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
                  habit.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 16.0),
                if (habit.description case String description) ...<Widget>[
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(description),
                  SizedBox(height: 16.0),
                ],
                if (habit.goal case String goal) ...<Widget>[
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
                        onPressed: () async {
                          await context.read<AppState>().deleteHabit(habitId: habit.id);
                          if (context.mounted) {
                            context.pop();
                          }
                        },
                        child: Text(
                          "Delete Habit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          /// We need to pop the modal first before navigating
                          context.pop();
                          context.go("/habits/edit-habit/${habit.id}");
                        },
                        child: Text(
                          "View Habit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          bool isCompleted = appState.isCompleted(habit.id, selectedDate);
                          bool isCompletedBefore = appState.isCompleted(habit.id, selectedDate);
                          bool isBeforeToday = selectedDate.isBefore(_currentDay());
                          bool isAfterToday = selectedDate.isAfter(_currentDay());
                          bool isNotToday = isBeforeToday || isAfterToday;

                          return TextButton(
                            onPressed: isNotToday || isCompleted
                                ? null
                                : () async {
                                    if (context.mounted) {
                                      context.pop();
                                    }
                                    await _showCompletionDialog(habit);
                                  },
                            child: Text(
                              isBeforeToday && isCompletedBefore //
                                  ? "Already Completed Before"
                                  : isBeforeToday
                                      ? "Past Habit"
                                      : isAfterToday
                                          ? "Not Yet"
                                          : isCompleted
                                              ? "Already Completed"
                                              : "Complete Habit",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        },
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

  Future<void> _showCompletionDialog(Habit habit) async {
    TextEditingController textEditingController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    if (habit.description case String description) ...<Widget>[
                      Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(description),
                      SizedBox(height: 16.0),
                    ],
                    if (habit.goal case String goal) ...<Widget>[
                      Text(
                        "Goal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(goal),
                      SizedBox(height: 16.0),
                    ],
                    Text(
                      "Confidence of Completion",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Slider(
                      label: _currentSliderValue.round().toString(),
                      value: _currentSliderValue,
                      max: 5,
                      divisions: 5,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text("Any valueable insights or comments?"),
                    SizedBox(
                      height: 4.0,
                    ),
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    if (context.mounted) {
                      appState.currency.value += _evaluateReflection(textEditingController.text);
                      await appState.completeHabit(
                        habitId: habit.id,
                        confidenceLevel: _currentSliderValue.toInt(),
                        dateTime: selectedDate,
                      );

                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );

    textEditingController.dispose();
  }

  static DateTime _currentDay() => DateTime.now().copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
        isUtc: false,
      );

  static DateTime _rightNow() => DateTime.now();

  static String _description(Duration duration) {
    Duration mutable = duration;
    StringBuffer buffer = StringBuffer();

    if (mutable.inDays > 0) {
      buffer.write(" ${mutable.inDays} day${mutable.inDays > 1 ? "s" : ""}");

      mutable -= Duration(days: mutable.inDays);
    }

    if (mutable.inHours > 0) {
      buffer.write(" ${mutable.inHours} hr");

      mutable -= Duration(hours: mutable.inHours);
    }

    if (mutable.inMinutes > 0) {
      int inMinutes = mutable.inMinutes;
      mutable -= Duration(minutes: inMinutes);

      if (mutable.inSeconds > 0) {
        inMinutes += 1;
      }

      buffer.write(" $inMinutes min");
    }

    return buffer.toString().trim();
  }
}

extension on ImmutableListenableList<Habit> {
  Iterable<TimedHabit> timedHabits(DateTime day) sync* {
    for (Habit habit in this) {
      if (habit.time != null &&
          (habit.daysOfTheWeek.isEmpty ||
              habit.daysOfTheWeek.contains(DaysOfTheWeek.values[day.weekday % 7]))) {
        yield TimedHabit(habit);
      }
    }
  }

  Iterable<Habit> noTimeHabits(DateTime day) sync* {
    for (Habit habit in this) {
      if (habit.time == null &&
          (habit.daysOfTheWeek.isEmpty ||
              habit.daysOfTheWeek.contains(DaysOfTheWeek.values[day.weekday % 7]))) {
        yield habit;
      }
    }
  }
}

extension on int {
  bool isWithin(int start, int end) => start <= this && this < end;
}

extension on ImmutableListenableList<Habit> {
  ImmutableList<Habit> forDate(DateTime date) => ImmutableList<Habit>(
        <Habit>[
          for (Habit t in this)
            if (t.daysOfTheWeek.isEmpty ||
                t.daysOfTheWeek.contains(DaysOfTheWeek.values[date.weekday % 7]))
              t,
        ],
      );
}
