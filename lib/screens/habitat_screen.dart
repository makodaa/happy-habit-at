import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/widgets/currency_display.dart";
import "package:happy_habit_at/widgets/game_display.dart";
import "package:provider/provider.dart";

class HabitatScreen extends StatefulWidget {
  const HabitatScreen({super.key});

  @override
  State<HabitatScreen> createState() => _HabitatScreenState();
}

class _HabitatScreenState extends State<HabitatScreen> {
  late final AppState appState;
  late Room activeRoom;

  @override
  void initState() {
    super.initState();

    appState = context.read<AppState>();
    activeRoom = appState.activeRoom.value;

    appState.activeRoom.addListener(_changeRoom);
    appState.activeRoom.value.addListener(_listener);
  }

  @override
  void dispose() {
    appState.activeRoom.removeListener(_changeRoom);
    appState.activeRoom.value.removeListener(_listener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ColoredBox(
          color: const Color(0xFF41B06E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                scrolledUnderElevation: 0.0,
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                title: Center(
                  child: Text(activeRoom.name),
                ),
              ),
              const Expanded(
                child: GameDisplay(),
              ),
            ],
          ),
        ),
        const Positioned(
          top: 56.0,
          right: 8.0,
          child: UserCurrencyDisplay(color: Colors.white),
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
                  context.go("/habitat/edit");
                },
                child: const Icon(
                  Icons.build,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
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

  /// This should be attached to the [AppState]'s [AppState.activeRoom] [ValueNotifier].
  void _changeRoom() {
    if (appState.activeRoom.value != activeRoom) {
      activeRoom.removeListener(_listener);
      activeRoom = appState.activeRoom.value..addListener(_listener);
    }
  }

  /// This should be attached to the active room of type [Room].
  void _listener() {
    setState(() {});
  }
}
