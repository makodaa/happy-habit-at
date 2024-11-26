import "package:flutter/material.dart";
import "package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habit.dart";
import "package:happy_habit_at/structs/completion.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
import "package:happy_habit_at/utils/extensions/monadic_nullable.dart";
import "package:happy_habit_at/utils/extensions/sorted_by.dart";
import "package:provider/provider.dart";

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late final AppState appState = context.read<AppState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          scrolledUnderElevation: 0.0,
          title: const Center(child: Text("More")),
        ),

        /// BODY
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /// Place body widgets here.

                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Activity",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.left,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListenableBuilder(
                    listenable: appState.completions,
                    builder: (BuildContext context, _) {
                      return HeatMapCalendar(
                        textColor: Colors.black,
                        colorMode: ColorMode.color,
                        showColorTip: false,
                        flexible: true,
                        datasets: appState.aggregateCompletions(),
                        colorsets: <int, Color>{
                          1: Colors.green.shade100,
                          2: Colors.green.shade200,
                          3: Colors.green.shade300,
                          4: Colors.green.shade400,
                          5: Colors.green.shade500,
                          6: Colors.green.shade600,
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                ListenableBuilder(
                  listenable: appState.completions,
                  builder: (BuildContext context, _) {
                    int value = appState.completions.length;

                    return ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ColoredBox(
                              color: Colors.green[300]!,
                              child: Center(
                                child: Text(
                                  "$value",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: const Text("Total Completed Habits"),
                      subtitle: Text("You've completed a total of $value habits."),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: appState.completions,
                  builder: (BuildContext context, _) {
                    List<Completion> completions = appState.completions.toList();
                    Map<int, int> counter = <int, int>{};
                    for (Completion completion in completions) {
                      counter
                        ..[completion.habitId] ??= 0
                        ..[completion.habitId] = counter[completion.habitId]! + 1;
                    }
                    int? doneHabits = counter.pairs
                        .toList() //
                        .sortedBy(((int, int) a, (int, int) b) => a.$2 - b.$2)
                        .map(((int, int) p) => p.$1)
                        .toList()
                        .firstOrNull;

                    int? count = doneHabits //
                        .nullableMap((int h) => counter[h]!);
                    String? name = count
                        .nullableMap((int h) => appState.habitOfId(h))
                        .nullableMap((Habit h) => h.name);

                    return ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ColoredBox(
                              color: Colors.green[300]!,
                              child: Center(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: const Text("Most Favorite Habit"),
                      subtitle: count == null || name == null
                          ? const Text("You haven't done any habits yet.")
                          : Text("You've completed '$name' the most at $count times."),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: appState.completions,
                  builder: (BuildContext context, _) {
                    int days = 0;
                    DateTime rightNow = DateTime.now();
                    DateTime today = DateTime(rightNow.year, rightNow.month, rightNow.day);
                    while (appState.completionsAtDate(today).isNotEmpty) {
                      days += 1;
                      today = today.subtract(const Duration(days: 1));
                    }

                    return ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ColoredBox(
                              color: Colors.green[300]!,
                              child: Center(
                                child: Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: const Text("Current Streak"),
                      subtitle: Text("Your current streak is $days days"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
