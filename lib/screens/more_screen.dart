import "package:flutter/material.dart";
import "package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart";
import "package:happy_habit_at/providers/app_state.dart";
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
                      showColorTip: false,
                      flexible: true,
                      datasets: <DateTime, int>{
                        ...appState.aggregateCompletions(),
                        DateTime(2024, 11, 10): 2,
                        DateTime(2024, 11, 9): 1,
                      },
                      colorsets: <int, Color>{
                        1: Colors.green,
                      },
                    );
                  },
                ),
              ),
              const Center(
                child: Text("Hi"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
