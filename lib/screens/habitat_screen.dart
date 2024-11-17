// ignore_for_file: always_specify_types

import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";

class HabitatScreen extends StatefulWidget {
  const HabitatScreen({super.key});

  @override
  State<HabitatScreen> createState() => _HabitatScreenState();
}

class _HabitatScreenState extends State<HabitatScreen> {
  late int currency = 1434;
  late String habitatName = "Keane's Habitat";
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
                title: const Text("Habitat Page"),
              ),
              Expanded(
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GamePanel(),
                ),
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
                NumberFormat("#,##0", "en_US").format(currency),
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
                onPressed: () {},
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

class GamePanel extends StatefulWidget {
  const GamePanel({super.key});

  @override
  State<GamePanel> createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  late final FocusNode focusNode = FocusNode();
  late (int y, int x) position = (0, 0);

  @override
  void initState() {
    super.initState();

    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  /// This is under the assumption that the tile is a square.
  static const tileWidth = 64.0 * math.sqrt1_2;
  static const rotatedTileWidth = 64.0;
  static const rotatedTileHeight = rotatedTileWidth / 2.0;
  static const iHat = (y: 1.0 * rotatedTileHeight * 0.5, x: 0.5 * rotatedTileWidth);
  static const jHat = (y: -1.0 * rotatedTileHeight * 0.5, x: 0.5 * rotatedTileWidth);

  (double, double) diagonalFloorPosition((int, int) position) {
    var (y: a, x: c) = iHat;
    var (y: b, x: d) = jHat;
    var (y, x) = position;

    return (a * y + b * x, c * y + d * x);
  }

  (int, int) diagonalCeilPosition((double, double) position) {
    var (y: a, x: c) = iHat;
    var (y: b, x: d) = jHat;
    var (y, x) = position;

    return ((a * y + c * x).round(), (b * y + d * x).round());
  }

  @override
  Widget build(BuildContext context) {
    print(diagonalFloorPosition((3, 1)));
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: _move,
      child: ColoredBox(
        color: Colors.blue,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Stack(
            children: <Widget>[
              for (int y = 0; y < 8; y++)
                for (int x = 0; x < 8; x++)
                  if (diagonalFloorPosition((y, x)) case (double ny, double nx))
                    Positioned(
                      top: ny,
                      left: nx,
                      child: Transform.scale(
                        scaleY: 0.5,
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Container(
                            width: tileWidth,
                            height: tileWidth,
                            color: (x + y) % 2 == 0 ? Colors.brown : Colors.yellow,
                          ),
                        ),
                      ),
                    ),
              if (diagonalFloorPosition(position) case (double y, double x)) //
                Positioned(
                  top: y,
                  left: x,
                  child: Image(
                    image: AssetImage("assets/images/dog.png"),
                    height: 32.0,
                    width: 32.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _move(KeyEvent event) {
    if (event is KeyDownEvent) {
      return;
    }

    setState(() {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          position = (position.$1, position.$2 + 1);
        case LogicalKeyboardKey.arrowDown:
          position = (position.$1, position.$2 - 1);
        case LogicalKeyboardKey.arrowLeft:
          position = (position.$1 - 1, position.$2);
        case LogicalKeyboardKey.arrowRight:
          position = (position.$1 + 1, position.$2);
      }

      // if (position case (int y, int x)) {
      //   position = (y.clamp(0, 7), x.clamp(0, 7));
      // }

      print(position);
    });
  }
}
