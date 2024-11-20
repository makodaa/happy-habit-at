import "dart:math" as math;

import "package:flutter/material.dart";
import "package:happy_habit_at/constants/pet_icons.dart";

typedef Vector = (double, double);
typedef IntVector = (int, int);

class GameDisplay extends StatefulWidget {
  const GameDisplay({super.key});

  @override
  State<GameDisplay> createState() => _GameDisplayState();
}

class _GameDisplayState extends State<GameDisplay> {
  /// This is under the assumption that the tile is a square.
  static const double tileSize = 36.0;

  static const double rotatedTileWidth = tileSize * math.sqrt2;
  static const double rotatedTileHeight = rotatedTileWidth / 2.0;

  static const int tileCount = 7;

  late final FocusNode focusNode = FocusNode();

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
            child: Transform.scale(
              scale: 1.62,
              child: Image.asset(
                "assets/images/tiles/grass_dirt/grass_dirt_1.png",
                width: rotatedTileWidth,
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
        child: Transform.flip(
          flipX: isFlipped,
          child: Image(
            image: AssetImage(path),
            width: width,
            height: height,
          ),
        ),
      ),
    );
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

extension on IntVector {
  IntVector operator +(IntVector other) => (this.$1 + other.$1, this.$2 + other.$2);
}
