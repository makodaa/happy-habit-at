import "dart:math" as math;

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
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
                child: GamePanel(),
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

class GamePanel extends StatefulWidget {
  const GamePanel({super.key});

  @override
  State<GamePanel> createState() => _GamePanelState();
}

typedef Vector = (double, double);
typedef IntVector = (int, int);

class _GamePanelState extends State<GamePanel> {
  /// This is under the assumption that the tile is a square.
  static const double tileSize = 36.0;

  static const double rotatedTileWidth = tileSize * math.sqrt2;
  static const double rotatedTileHeight = rotatedTileWidth / 2.0;

  static const int tileCount = 7;

  late final FocusNode focusNode = FocusNode();
  late final List<ValueNotifier<Offset>> floorOffsets = <ValueNotifier<Offset>>[
    for ((int, int) _ in tileCount.times(tileCount)) ValueNotifier<Offset>(Offset.zero),
  ];

  Offset petOffset = Offset(0, 0);
  IntVector petPosition = (0, 0);
  bool isPetFacingLeft = false;

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

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: <Widget>[
            ..._floorTileWidgets(constraints),
            _petWidget(constraints),
          ],
        ),
      ),
    );
  }

  List<Widget> _floorTileWidgets(BoxConstraints constraints) {
    return <Widget>[
      for (var (int y, int x) in tileCount.times(tileCount))
        if (_screenPositionFromFloorTile((x, y), constraints) case (double nx, double ny))
          Positioned(
            top: ny,
            left: nx,
            child: ListenableBuilder(
              listenable: floorOffsets[y * tileCount + x],
              builder: (BuildContext context, Widget? child) {
                return AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  offset: floorOffsets[y * tileCount + x].value,
                  child: child,
                );
              },
              child: Transform.scale(
                scale: 1.62,
                child: Image.asset(
                  "assets/images/tiles/grass_dirt/grass_dirt_1.png",
                  width: rotatedTileWidth,
                ),
              ),
            ),
          ),
    ];
  }

  Widget _petWidget(BoxConstraints constraints) {
    var PetIcon(
      :String path,
      dimensions: (double width, double height),
      defaultOffset: (double dx, double dy),
      flippedOffset: (double dxF, double dyF),
      baseOffset: IntVector offset,
      :bool imageIsFacingLeft,
    ) = petIcons["dog"]!;

    var (double x, double y) = _screenPositionFromFloorTile(petPosition + offset, constraints);
    bool isFlipped = imageIsFacingLeft ^ isPetFacingLeft;

    return Positioned(
      top: y,
      left: x,
      child: Transform.translate(
        offset: isFlipped ? Offset(dxF, dyF) : Offset(dx, dy),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTap: () {
            setState(() {
              isPetFacingLeft ^= true;
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            petOffset += details.delta;

            IntVector tilePosition = petPosition;
            tilePosition = _floorTilePositionFromRelativeOffset(petOffset.pair);

            /// If this current delta results in the pet exceeding the tile bounds,
            ///   disregard this delta.
            if (tilePosition.exceeds((0, 0), (tileCount, tileCount))) {
              petOffset -= details.delta;
              return;
            }

            tilePosition = tilePosition.clamp((0, 0), (tileCount - 1, tileCount - 1));
            if (tilePosition != petPosition) {
              setState(() {
                petPosition = tilePosition;
              });
            }
          },
          child: Transform.flip(
            flipX: isFlipped,
            child: Image(
              image: AssetImage(path),
              width: width,
              height: height,
            ),
          ),
        ),
      ),
    );
  }

  IntVector _floorTilePositionFromRelativeOffset(Vector relativeOffset) {
    var (double x, double y) = relativeOffset;
    var (double nx, double ny) = (
      x / rotatedTileWidth + y / rotatedTileHeight,
      -x / rotatedTileWidth + y / rotatedTileHeight,
    );

    return (nx.floor(), ny.floor());
  }

  Vector _screenPositionFromFloorTile(IntVector position, BoxConstraints constraints) {
    double middleOffset = (constraints.maxWidth - tileSize) / 2;
    double topOffset = constraints.maxHeight / 2;

    var (int x, int y) = position;
    var (double nx, double ny) = (
      x * (0.5 * rotatedTileWidth) + y * (-0.5 * rotatedTileWidth) + middleOffset,
      x * (0.5 * rotatedTileHeight) + y * (0.5 * rotatedTileHeight) + topOffset,
    );

    return (nx, ny);
  }
}

extension on int {
  Iterable<(int, int)> times(int right) sync* {
    for (int y = 0; y < this; ++y) {
      for (int x = 0; x < right; ++x) {
        yield (y, x);
      }
    }
  }
}

extension on Offset {
  Vector get pair => (dx, dy);
}

extension on IntVector {
  IntVector clamp(IntVector min, IntVector max) {
    return (
      math.max(min.$1, math.min(max.$1, this.$1)),
      math.max(min.$2, math.min(max.$2, this.$2)),
    );
  }

  bool exceeds(IntVector min, IntVector max) {
    return this.$1 < min.$1 || this.$1 >= max.$1 || this.$2 < min.$2 || this.$2 >= max.$2;
  }

  IntVector operator +(IntVector other) => (this.$1 + other.$1, this.$2 + other.$2);
}
