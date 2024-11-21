import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/modify_habitat_state.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/widgets/movable_game_panel.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:scroll_animator/scroll_animator.dart";

class ModifyHabitatScreen extends StatefulWidget {
  const ModifyHabitatScreen({super.key});

  @override
  State<ModifyHabitatScreen> createState() => _ModifyHabitatScreenState();
}

class _ModifyHabitatScreenState extends State<ModifyHabitatScreen> {
  late final TextEditingController roomNameController;

  late final AppState appState;
  late final ModifyHabitatState modifyHabitatState;

  late Room activeRoom;

  @override
  void initState() {
    super.initState();

    appState = context.read<AppState>();
    modifyHabitatState = ModifyHabitatState();
    activeRoom = appState.activeRoom.value;

    roomNameController = TextEditingController(text: activeRoom.name);

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
    return Provider<ModifyHabitatState>.value(
      value: modifyHabitatState,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ColoredBox(
                  color: Color(0xFF41B06E),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _appBar(),
                      Expanded(child: MovableGamePanel()),
                    ],
                  ),
                ),

                _userCurrency(),

                /// Floating Action Buttons
                _floatingActionButtons(context),
              ],
            ),
          ),
          InventoryPanel(),
        ],
      ),
    );
  }

  LayoutBuilder _appBar() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          title: Center(
            child: SizedBox(
              width: constraints.maxWidth * 0.75,
              child: TextField(
                /// Textfield with a white underline and white colored text.
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: roomNameController,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        );
      },
    );
  }

  Positioned _floatingActionButtons(BuildContext context) {
    return Positioned(
      bottom: 12.0,
      right: 12.0,
      child: FloatingActionButton(
        heroTag: "enterCustomizationButton",
        backgroundColor: Colors.blue.shade200,
        onPressed: () {
          appState.activeRoom.value.name = roomNameController.text;
          unawaited(appState.commitRoomChanges());
          context.go("/habitat");
        },
        child: Icon(
          Icons.build,
          color: Colors.white,
        ),
      ),
    );
  }

  Positioned _userCurrency() {
    return Positioned(
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

class InventoryPanel extends StatelessWidget {
  const InventoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Your Inventory"),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              controller: AnimatedScrollController(animationFactory: ChromiumImpulse()),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < 12; ++i) ...<Widget>[
                    Container(
                      width: 64.0,
                      height: 64.0,
                      margin: EdgeInsets.all(4.0),
                      color: Colors.blue.shade200,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
