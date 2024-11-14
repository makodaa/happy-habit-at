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
  static const int tileWidth = 32;
  static const int tileHeight = 16;
  static const int width = 8;
  static const int height = 8;

  late final FocusNode focusNode = FocusNode();
  late (int, int) position = (0, 0);

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

  (double, double) diagonalFloorPosition((int, int) position) {
    if (position case (int tileY, int tileX)) {
      tileY *= -1;

      return (
        ((height - tileY - 1) * tileHeight) / 2 +
            (width * tileHeight) / 2 -
            (tileX * tileHeight) / 2,
        (tileWidth * tileX) / 2 + (height * tileHeight) / 2 - (tileY * tileWidth) / 2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double tileYXRatio = tileHeight / tileWidth;

    double actualWidth = width * tileWidth.toDouble();
    double platformWidth = width * tileWidth * math.sqrt1_2;

    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: _move,
      child: ColoredBox(
        color: Colors.blue,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Stack(
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                color: Colors.red,
                child: Transform.scale(
                  scaleY: tileYXRatio * (platformWidth / actualWidth),
                  scaleX: platformWidth / actualWidth,
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      width: width * tileWidth.toDouble(),
                      height: height * tileWidth.toDouble(),
                      color: Colors.green,
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
                    height: tileWidth.toDouble(),
                    width: tileWidth.toDouble(),
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
