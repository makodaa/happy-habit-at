import "dart:async";

import "package:flutter/material.dart" hide Decoration;
import "package:go_router/go_router.dart";
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habitat_decoration.dart";
import "package:happy_habit_at/providers/modify_habitat_state.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/utils/extension_types/ids.dart";
import "package:happy_habit_at/widgets/currency_display.dart";
import "package:happy_habit_at/widgets/movable_game_display.dart";
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
    return ChangeNotifierProvider<ModifyHabitatState>.value(
      value: modifyHabitatState,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ColoredBox(
                  color: const Color(0xFF41B06E),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _appBar(),
                      const Expanded(
                        child: MovableGameDisplay(),
                      ),
                    ],
                  ),
                ),

                _currencyDisplay(),

                /// Floating Action Buttons
                _floatingActionButtons(context),
              ],
            ),
          ),
          const InventoryPanel(),
        ],
      ),
    );
  }

  Widget _appBar() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AppBar(
          scrolledUnderElevation: 0.0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          title: Center(
            child: SizedBox(
              width: constraints.maxWidth * 0.75,
              child: TextField(
                /// Textfield with a white underline and white colored text.
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                ),
                decoration: const InputDecoration(
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

  Widget _floatingActionButtons(BuildContext context) {
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
        child: const Icon(
          Icons.build,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _currencyDisplay() {
    return const Positioned(
      top: 56.0,
      right: 8.0,
      child: UserCurrencyDisplay(color: Colors.white),
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
    AppState appState = context.read<AppState>();

    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text("Your Inventory"),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              controller: AnimatedScrollController(animationFactory: const ChromiumImpulse()),
              scrollDirection: Axis.horizontal,
              child: ListenableBuilder(
                listenable: appState.ownedDecorations,
                builder: (BuildContext context, _) {
                  return Row(
                    children: <Widget>[
                      for (DecorationId id in appState.ownedDecorations)
                        if (appState.decorationOf(id) case HabitatDecoration ownedDecoration)
                          ListenableBuilder(
                            listenable: ownedDecoration,
                            builder: (BuildContext context, Widget? child) {
                              return GestureDetector(
                                onTap: () {
                                  if (ownedDecoration.quantityOwned > 0) {
                                    context.read<ModifyHabitatState>()
                                      ..decorationIsNew = true
                                      ..movingDecoration = ownedDecoration;
                                  }
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: 92.0,
                                      height: 92.0,
                                      margin: const EdgeInsets.all(4.0),
                                      color: Colors.blue.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          decorationIcons[ownedDecoration.id]!.imagePath,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.0,
                                      right: 0.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Container(
                                          width: 24.0,
                                          height: 24.0,
                                          color: Colors.red[300],
                                          child: Center(
                                            child: Text(
                                              "${ownedDecoration.quantityOwned}",
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
