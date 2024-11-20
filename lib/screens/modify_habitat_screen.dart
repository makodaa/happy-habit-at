import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/widgets/movable_game_panel.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class ModifyHabitatScreen extends StatefulWidget {
  const ModifyHabitatScreen({super.key});

  @override
  State<ModifyHabitatScreen> createState() => _ModifyHabitatScreenState();
}

class _ModifyHabitatScreenState extends State<ModifyHabitatScreen> {
  bool hasInitialized = false;
  late final AppState appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!hasInitialized) {
      appState = context.read<AppState>();
      hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              ColoredBox(
                color: Colors.green.shade500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    AppBar(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      title: const Text("Habitat Page"),
                      automaticallyImplyLeading: false,
                    ),
                    Expanded(
                      child: MovableGamePanel(),
                    ),
                  ],
                ),
              ),

              /// User currency
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

              /// Floating Action Buttons
              Positioned(
                bottom: 12.0,
                right: 12.0,
                child: FloatingActionButton(
                  heroTag: "enterCustomizationButton",
                  backgroundColor: Colors.blue.shade200,
                  onPressed: () {
                    unawaited(appState.commitRoomChanges());
                    context.go("/habitat");
                  },
                  child: Icon(
                    Icons.build,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        InventoryPanel(),
      ],
    );
  }
}

class InventoryPanel extends StatelessWidget {
  const InventoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      color: Colors.white,
      child: Text("Hi"),
    );
  }
}
