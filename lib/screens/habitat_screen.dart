import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/room.dart";
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
  late Room activeRoom;
  bool hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!hasInitialized) {
      appState = context.read<AppState>();
      activeRoom = appState.activeRoom.value;

      appState.activeRoom.addListener(_changeRoom);
      appState.activeRoom.value.addListener(_listener);

      hasInitialized = true;
    }
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
          color: Color(0xFF41B06E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                title: Center(
                  child: Text(activeRoom.name),
                ),
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
              ValueListenableBuilder<int>(
                valueListenable: appState.currency,
                builder: (BuildContext context, int value, Widget? child) {
                  NumberFormat formatter = NumberFormat("#,##0", "en_US");

                  return Text(
                    formatter.format(value),
                    style: TextStyle(color: Colors.white),
                  );
                },
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
