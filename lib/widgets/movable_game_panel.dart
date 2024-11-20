import "dart:math" as math;

import "package:flutter/material.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/constants/tile_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:provider/provider.dart";

typedef Vector = (double, double);
typedef IntVector = (int, int);

class MovableGamePanel extends StatefulWidget {
  const MovableGamePanel({super.key});

  @override
  State<MovableGamePanel> createState() => _MovableGamePanelState();
}

class _MovableGamePanelState extends State<MovableGamePanel> {
  /// This is under the assumption that the tile is a square.
  static const double tileSize = 36.0;

  static const double rotatedTileWidth = tileSize * math.sqrt2;
  static const double rotatedTileHeight = rotatedTileWidth / 2.0;

  late final AppState appState;
  late Room activeRoom;

  bool hasInitialized = false;

  /// This is the screen offset of the pet.
  Offset temporaryPetOffset = Offset.zero;
  IntVector temporaryPetTileOffset = (0, 0);

  /// This is the position of the pet in the tile grid.
  IntVector get petPosition => activeRoom.petPosition;
  set petPosition(IntVector value) {
    activeRoom.petPosition = value;
  }

  bool get petIsFlipped => activeRoom.petIsFlipped;
  set petIsFlipped(bool value) {
    activeRoom.petIsFlipped = value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    activeRoom.removeListener(_listener);
    appState.activeRoom.removeListener(_changeRoom);

    super.dispose();
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

    return <Widget>[
      for (var (int y, int x) in room.size.times(room.size))
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

    var (double x, double y) = _screenPositionFromFloorTile(
      petPosition + offset + temporaryPetTileOffset,
      constraints,
    );
    bool isFlipped = imageIsFacingLeft ^ petIsFlipped;

    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            petIsFlipped ^= true;
          });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            /// Commit the temporary offset.
            petPosition += temporaryPetTileOffset;

            /// Reset the temporary offsets.
            temporaryPetOffset = Offset.zero;
            temporaryPetTileOffset = (0, 0);
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          temporaryPetOffset += details.delta;

          /// We get the current screen offset of the pet
          ///   (Where it is currently on the screen).
          IntVector tileAdjustment = _floorTilePositionFromRelativeOffset(temporaryPetOffset.pair);
          if ((tileAdjustment + petPosition).exceeds((0, 0), (activeRoom.size, activeRoom.size))) {
            return;
          }

          setState(() {
            temporaryPetTileOffset = tileAdjustment;
          });
        },
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
      ),
    );
  }

  IntVector _floorTilePositionFromRelativeOffset(Vector offset) {
    var (double x, double y) = offset;

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

  /// This should be attached to the active room of type [Room].
  void _changeRoom() {
    if (appState.activeRoom.value != activeRoom) {
      activeRoom.removeListener(_listener);
      activeRoom = appState.activeRoom.value..addListener(_listener);
    }
  }

  /// This should be attached to the [AppState]'s [AppState.activeRoom] [ValueNotifier].
  void _listener() {
    setState(() {});
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
  bool exceeds(IntVector min, IntVector max) {
    return this.$1 < min.$1 || this.$1 >= max.$1 || this.$2 < min.$2 || this.$2 >= max.$2;
  }

  IntVector operator +(IntVector other) => (this.$1 + other.$1, this.$2 + other.$2);
}
