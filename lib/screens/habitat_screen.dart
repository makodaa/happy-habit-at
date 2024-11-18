import "dart:math" as math;

import "package:flutter/material.dart";
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

typedef Vector = (double, double);
typedef IntVector = (int, int);

class _GamePanelState extends State<GamePanel> {
  /// This is under the assumption that the tile is a square.
  static const double tileSize = 48.0;

  static const double rotatedTileWidth = tileSize * math.sqrt2;
  static const double rotatedTileHeight = rotatedTileWidth / 2.0;

  static const double sheeredTileWidth = rotatedTileWidth / 2;
  static const double sheeredTileHeight = sheeredTileWidth;

  static const int rightTileCount = 4;
  static const int leftTileCount = 4;

  late final FocusNode focusNode = FocusNode();

  Offset wallTileOffset = Offset(0, 0);
  IntVector wallTilePosition = (0, 0);

  Offset petOffset = Offset(0, 0);
  IntVector petPosition = (0, 0);

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
      color: Colors.purple,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: <Widget>[
            ..._rightWallTileWidgets(constraints),
            ..._floorTileWidgets(constraints),
            _petWidget(constraints),
            _purpleWidget(constraints),
            Positioned(
              left: constraints.maxWidth / 2,
              child: Container(height: constraints.maxHeight, width: 1, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _rightWallTileWidgets(BoxConstraints constraints) {
    return <Widget>[
      for (int y = 0; y < 4; ++y)
        for (int x = 0; x < rightTileCount; ++x)

          /// Variables..?
          /// These are variable declarations. :)
          if (_screenPositionFromRightWallTile((x, y), constraints) case (double nx, double ny))
            Positioned(
              top: ny,
              left: nx,
              child: Transform(
                transform: Matrix4.identity()..setEntry(1, 0, 0.5),
                child: Container(
                  width: sheeredTileWidth,
                  height: sheeredTileHeight,
                  color: Colors.blue,
                ),
              ),
            ),
    ];
  }

  List<Widget> _floorTileWidgets(BoxConstraints constraints) {
    return <Widget>[
      for (int y = 0; y < leftTileCount; ++y)
        for (int x = 0; x < rightTileCount; ++x)

          /// Variables..?
          /// These are variable declarations. :)
          if (_screenPositionFromFloorTile((x, y), constraints) case (double nx, double ny))
            Positioned(
              top: ny,
              left: nx,
              child: Transform.scale(
                scaleY: 0.5,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: tileSize,
                    height: tileSize,
                    color: (x + y).isEven ? Colors.brown : Colors.yellow,
                  ),
                ),
              ),
            ),
    ];
  }

  Widget _petWidget(BoxConstraints constraints) {
    var (double x, double y) = _screenPositionFromFloorTile(petPosition - (1, 1), constraints);

    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (DragUpdateDetails details) {
          petOffset += details.delta;

          IntVector tilePosition = petPosition;
          tilePosition = _floorTilePositionFromRelativeOffset(petOffset.pair);
          tilePosition = tilePosition.clamp((0, 0), (rightTileCount - 1, leftTileCount - 1));
          if (tilePosition != petPosition) {
            setState(() {
              petPosition = tilePosition;
            });
          }
        },
        child: Image(
          image: AssetImage("assets/images/dog.png"),
          height: 60.0,
          width: 60.0,
        ),
      ),
    );
  }

  Widget _purpleWidget(BoxConstraints constraints) {
    var (double x, double y) = _screenPositionFromRightWallTile(wallTilePosition, constraints);

    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (DragStartDetails details) {
          wallTileOffset = Offset(0, 0);
        },
        onPanEnd: (DragEndDetails details) {
          wallTileOffset = Offset(0, 0);
        },
        onPanUpdate: (DragUpdateDetails details) {
          Offset invertedOffset = Offset(details.delta.dx, -details.delta.dy);
          wallTileOffset += invertedOffset;

          IntVector tilePosition = wallTilePosition;
          tilePosition = _wallTilePositionFromRelativeOffset(wallTileOffset.pair);
          print(tilePosition);
          if (tilePosition.exceeds((0, 0), (rightTileCount - 1, 3))) {
            wallTileOffset -= invertedOffset;
            return;
          }

          tilePosition = tilePosition.clamp((0, 0), (rightTileCount - 1, 3));
          if (tilePosition != wallTilePosition) {
            setState(() {
              wallTilePosition = tilePosition;
            });
          }
        },
        child: Transform(
          transform: Matrix4.identity()..setEntry(1, 0, 0.5),
          child: Container(
            width: sheeredTileWidth,
            height: sheeredTileHeight,
            color: Colors.purple,
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
    print((middleOffsetFloorTile: middleOffset));

    var (int x, int y) = position;
    var (double nx, double ny) = (
      x * (0.5 * rotatedTileWidth) + y * (-0.5 * rotatedTileWidth) + middleOffset,
      x * (0.5 * rotatedTileHeight) + y * (0.5 * rotatedTileHeight) + topOffset,
    );

    return (nx, ny);
  }

  IntVector _wallTilePositionFromRelativeOffset(Vector relativeOffset) {
    var (double x, double y) = relativeOffset;
    var (double nx, double ny) = (
      x / sheeredTileWidth,
      -0.5 * x / sheeredTileWidth + y / sheeredTileHeight,
    );

    return (nx.floor(), ny.floor());
  }

  Vector _screenPositionFromRightWallTile(IntVector position, BoxConstraints constraints) {
    double middleOffset = constraints.maxWidth / 2;
    double topOffset = constraints.maxHeight / 2 - (27 /* This constant is magical. */);

    var (int x, int y) = position;
    var (double nx, double ny) = (
      x * sheeredTileWidth + middleOffset,
      x * 0.5 * sheeredTileHeight - y * sheeredTileHeight + topOffset,
    );

    return (nx, ny);
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
    return this.$1 < min.$1 || this.$1 > max.$1 || this.$2 < min.$2 || this.$2 > max.$2;
  }

  IntVector operator -(IntVector other) => (this.$1 - other.$1, this.$2 - other.$2);
}
