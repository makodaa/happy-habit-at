import "dart:math" as math;

import "package:flutter/material.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/constants/tile_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/utils/type_aliases.dart";
import "package:provider/provider.dart";

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

  late final AppState appState;

  bool hasInitialized = false;
  late Room activeRoom;

  /// This is the screen offset of the pet.
  Offset petOffset = Offset(0, 0);

  IntVector get petPosition => activeRoom.petPosition;
  bool get petIsFlipped => activeRoom.petIsFlipped;

  @override
  void initState() {
    super.initState();
  }

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
    activeRoom.removeListener(_listener);
    appState.activeRoom.removeListener(_changeRoom);

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
            if (_petWidget(constraints) case Widget widget) widget,
          ],
        ),
      ),
    );
  }

  List<Widget> _floorTileWidgets(BoxConstraints constraints) {
    Room room = appState.activeRoom.value;
    int tileCount = room.size;

    return <Widget>[
      for (var (int y, int x) in tileCount.times(tileCount))
        if (_screenPositionFromFloorTile((x, y), constraints) case (double nx, double ny))
          Positioned(
            top: ny,
            left: nx,
            child: Transform.scale(
              scale: 1.62,
              child: Image.asset(
                tileIcons[room.tileId]!.path,
                width: rotatedTileWidth,
              ),
            ),
          ),
    ];
  }

  Widget? _petWidget(BoxConstraints constraints) {
    PetIcon? petIcon = petIcons[appState.activeRoom.value.petId];
    if (petIcon == null) {
      return null;
    }

    var PetIcon(
      :String path,
      dimensions: (double width, double height),
      defaultOffset: (double dx, double dy),
      flippedOffset: (double dxF, double dyF),
      baseOffset: IntVector offset,
      :bool imageIsFacingLeft,
    ) = petIcon;
    var (double x, double y) = _screenPositionFromFloorTile(petPosition + offset, constraints);
    bool isFlipped = imageIsFacingLeft ^ petIsFlipped;

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

  void _changeRoom() {
    if (appState.activeRoom.value != activeRoom) {
      activeRoom.removeListener(_listener);
      activeRoom = appState.activeRoom.value..addListener(_listener);
    }
  }

  void _listener() {
    if (context case StatefulElement element) {
      element.markNeedsBuild();
    }
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
