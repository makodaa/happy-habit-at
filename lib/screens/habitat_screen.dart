import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/widgets/game_display.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class HabitatScreen extends StatefulWidget {
  const HabitatScreen({super.key});

  @override
  State<HabitatScreen> createState() => _HabitatScreenState();
}

class _HabitatScreenState extends State<HabitatScreen> {
  late final AppState appState;

  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      appState = context.read<AppState>();

      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ColoredBox(
          color: Colors.green.shade500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                title: Center(child: const Text("Habitat Page")),
              ),
              Expanded(
                child: GameDisplay(),
              ),
            ],
          ),
        ),
        Positioned(
          top: 48.0,
          right: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                NumberFormat("#,##0", "en_US").format(appState.currency.value),
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.circle,
                color: Colors.white,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "enterCustomizationButton",
                backgroundColor: Colors.white,
                onPressed: () {
                  print("Pressed!");
                  context.go("/habitat/edit");
                },
                child: const Icon(
                  Icons.build,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                heroTag: "feedPetButton",
                onPressed: () {},
                child: const Icon(Icons.rice_bowl_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
