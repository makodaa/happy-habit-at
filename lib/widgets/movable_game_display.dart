import "dart:math" as math;

import "package:flutter/material.dart" hide Decoration;
import "package:happy_habit_at/constants/decoration_icons.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/constants/tile_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/providers/habitat_decoration.dart";
import "package:happy_habit_at/providers/modify_habitat_state.dart";
import "package:happy_habit_at/providers/placement.dart";
import "package:happy_habit_at/providers/room.dart";
import "package:happy_habit_at/utils/type_aliases.dart";
import "package:provider/provider.dart";

class MovableGameDisplay extends StatefulWidget {
  const MovableGameDisplay({super.key});

  @override
  State<MovableGameDisplay> createState() => _MovableGameDisplayState();
}

class _MovableGameDisplayState extends State<MovableGameDisplay> {
  /// This is under the assumption that the tile is a square.
  static const double tileSize = 36.0;

  static const double rotatedTileWidth = tileSize * math.sqrt2;
  static const double rotatedTileHeight = rotatedTileWidth / 2.0;

  late final AppState appState;
  late final ModifyHabitatState modifyHabitatState;
  late Room activeRoom;

  /// This is for any of the decorations that are being moved.
  ///   Potentially dangerous, as [movingDecoration] and [petIsLocked] must be in sync
  ///   to be mutually exclusive.

  // These are the fields related to the moving decoration.
  HabitatDecoration? movingDecoration;
  Offset temporaryDecorationOffset = Offset.zero;
  IntVector decorationPosition = (0, 0);
  IntVector temporaryDecorationTileVector = (0, 0);
  IntVector temporaryDecorationDraggingTileVector = (0, 0);
  bool decorationIsFlipped = false;
  int? placementId;
  // end of moving decoration fields

  /// This is true if the decoration is new (i.e. a placement does not exist yet.)
  bool decorationIsNew = false;

  /// This is the screen offset of the pet.
  Offset temporaryPetOffset = Offset.zero;

  /// This is the tile of the pet according to the current drag.
  IntVector temporaryPetDraggingTileVector = (0, 0);

  /// This is the offset of the pet according to the current lock/unlock session.
  IntVector temporaryPetTileVector = (0, 0);

  /// Represents whether the pet is "locked" or not.
  ///   It is locked when it is not the one being moved.
  ///   i.e [petIsLocked] is false if the pet is being moved.
  bool petIsLocked = true;

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

    appState = context.read<AppState>();
    modifyHabitatState = context.read<ModifyHabitatState>() //
      ..addListener(() {
        print((modifyHabitatState.movingDecoration, movingDecoration));
        if (modifyHabitatState.movingDecoration == null) {
          movingDecoration = null;
          temporaryDecorationOffset = Offset.zero;
          temporaryDecorationTileVector = (0, 0);
          decorationPosition = (0, 0);
          decorationIsNew = false;

          return;
        }

        if (modifyHabitatState.movingDecoration != movingDecoration) {
          movingDecoration = modifyHabitatState.movingDecoration;
          temporaryDecorationOffset = Offset.zero;
          temporaryDecorationTileVector = (0, 0);
          decorationPosition = (
            appState.activeRoom.value.size - 1,
            appState.activeRoom.value.size - 1,
          );
          decorationIsNew = modifyHabitatState.decorationIsNew!;

          /// If pet is locked:
          ///   If it is not null: do nothing.
          ///   If it is null: do nothing.
          /// If pet is not locked:
          ///   If it is not null: lock pet.
          ///   If it is null: do nothing.

          if (!petIsLocked) {
            petIsLocked = movingDecoration != null;
          }
        }

        if (context case StatefulElement element) {
          element.markNeedsBuild();
        }
      });

    activeRoom = appState.activeRoom.value;
    appState.activeRoom.addListener(_changeRoom);
    appState.activeRoom.value.addListener(_listener);
  }

  @override
  void dispose() {
    activeRoom.removeListener(_listener);
    appState.activeRoom.removeListener(_changeRoom);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Stack(
        children: <Widget>[
          if (movingDecoration != null || !petIsLocked)
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: _movableTileControls(),
              ),
            ),
          ..._floorTileWidgets(constraints),
          for (Placement placement in appState.readPlacements(appState.activeRoom.value.id))
            if (placement case Placement(:(int, int) tileCoordinate))
              if (_screenPositionFromFloorTile(tileCoordinate, constraints)
                  case (double nx, double ny))
                Positioned(
                  top: ny,
                  left: nx,
                  child: Image.asset(
                    width: 48,
                    height: 48,
                    decorationIcons[placement.decorationId]!.imagePath,
                  ),
                ),
          if (_petWidget(constraints) case Widget widget) widget,
          if (_movingFurnitureWidget(constraints) case Widget widget) widget,
        ],
      ),
    );
  }

  Widget _movableTileControls() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Colors.green[300],
            ),
            onPressed: () async {
              if (!petIsLocked) {
                petPosition += temporaryPetTileVector;

                temporaryPetOffset = Offset.zero;
                temporaryPetTileVector = (0, 0);
                temporaryPetDraggingTileVector = (0, 0);

                petIsLocked = true;

                if (context case StatefulElement element) {
                  element.markNeedsBuild();
                }
              } else if (movingDecoration case HabitatDecoration movingDecoration) {
                decorationPosition += temporaryDecorationTileVector;

                temporaryDecorationOffset = Offset.zero;
                temporaryDecorationTileVector = (0, 0);
                temporaryDecorationDraggingTileVector = (0, 0);

                temporaryDecorationOffset = Offset.zero;

                if (decorationIsNew) {
                  await appState.createPlacement(
                    roomId: appState.activeRoom.value.id,
                    decorationId: movingDecoration.id,
                    tileCoordinate: decorationPosition,
                    isFlipped: decorationIsFlipped,
                  );
                } else {
                  await appState.updatePlacement(
                    roomId: appState.activeRoom.value.id,
                    placementId: placementId!,
                    decorationId: movingDecoration.id,
                    tileCoordinate: decorationPosition,
                    isFlipped: decorationIsFlipped,
                  );
                }

                this.movingDecoration = null;

                if (context case StatefulElement element) {
                  element.markNeedsBuild();
                }
              } else {
                throw Exception("Invalid state.");
              }
            },
            icon: Icon(Icons.check),
          ),
          const SizedBox(width: 24.0),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[400],
            ),
            onPressed: () {
              /// We flip the decoration / pet.

              if (!petIsLocked) {
                setState(() {
                  petIsFlipped ^= true;
                });
              } else if (movingDecoration != null) {
                setState(() {
                  decorationIsFlipped ^= true;
                });
              } else {
                throw Exception("Invalid state.");
              }
            },
            icon: Icon(Icons.flip),
          ),
          const SizedBox(width: 24.0),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Colors.red[300],
            ),
            onPressed: () {
              /// We cancel the movement.

              if (!petIsLocked) {
                setState(() {
                  temporaryPetOffset = Offset.zero;
                  temporaryPetTileVector = (0, 0);
                  temporaryPetDraggingTileVector = (0, 0);
                  petIsLocked = true;
                });
              } else if (movingDecoration != null) {
                setState(() {
                  temporaryDecorationOffset = Offset.zero;
                  temporaryDecorationTileVector = (0, 0);
                  temporaryDecorationDraggingTileVector = (0, 0);
                  movingDecoration = null;
                });
              } else {
                throw Exception("Invalid state.");
              }
            },
            icon: Icon(Icons.close),
          ),
        ],
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
      petPosition + offset + temporaryPetDraggingTileVector + temporaryPetTileVector,
      constraints,
    );
    bool isFlipped = imageIsFacingLeft ^ petIsFlipped;

    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        behavior: petIsLocked ? HitTestBehavior.translucent : HitTestBehavior.deferToChild,
        onTap: () {
          setState(() {
            petIsLocked ^= true;
          });
        },
        onPanEnd: (DragEndDetails details) {
          if (petIsLocked) {
            return;
          }

          setState(() {
            /// Commit the temporary offset.
            temporaryPetTileVector += temporaryPetDraggingTileVector;

            /// Reset the temporary offsets.
            temporaryPetOffset = Offset.zero;
            temporaryPetDraggingTileVector = (0, 0);
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          if (petIsLocked) {
            return;
          }

          temporaryPetOffset += details.delta;

          /// We get the current screen offset of the pet
          ///   (Where it is currently on the screen).
          IntVector tileAdjustment = _floorTilePositionFromRelativeOffset(temporaryPetOffset.pair);
          if ((tileAdjustment + petPosition).exceeds((0, 0), (activeRoom.size, activeRoom.size))) {
            return;
          }

          setState(() {
            temporaryPetDraggingTileVector = tileAdjustment;
          });
        },
        child: Transform.translate(
          offset: isFlipped ? Offset(dxF, dyF) : Offset(dx, dy),
          child: Transform.flip(
            flipX: isFlipped,
            child: Image(
              image: AssetImage(
                path,
              ),
              width: width,
              height: height,
              color: petIsLocked ? null : Colors.blue,
              colorBlendMode: petIsLocked ? null : BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _movingFurnitureWidget(BoxConstraints constraints) {
    String? decorationId = movingDecoration?.id;
    if (decorationId == null) {
      return null;
    }

    var DecorationIcon(
      :String name,
      :String description,
      :String imagePath,
      :int salePrice,
      :int resalePrice,
      :int happinessBuff,
      :int energyBuff,
      :bool isFacingLeft,
    ) = decorationIcons[decorationId]!;

    var (double x, double y) = _screenPositionFromFloorTile(
      decorationPosition + temporaryDecorationTileVector + temporaryDecorationDraggingTileVector,
      constraints,
    );
    bool isFlipped = isFacingLeft ^ decorationIsFlipped;

    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        onTap: () {
          // setState(() {
          //   petIsLocked ^= true;
          // });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            /// Commit the temporary offset.
            temporaryDecorationTileVector += temporaryDecorationDraggingTileVector;

            /// Reset the temporary offsets.
            temporaryDecorationOffset = Offset.zero;
            temporaryDecorationDraggingTileVector = (0, 0);
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          temporaryDecorationOffset += details.delta;

          /// We get the current screen offset of the Decoration
          ///   (Where it is currently on the screen).
          IntVector tileAdjustment = _floorTilePositionFromRelativeOffset(
            temporaryDecorationOffset.pair,
          );

          if ((tileAdjustment + decorationPosition)
              .exceeds((0, 0), (activeRoom.size, activeRoom.size))) {
            return;
          }

          setState(() {
            temporaryDecorationDraggingTileVector = tileAdjustment;
          });
        },
        child: Transform.flip(
          flipX: isFlipped,
          child: Image.asset(
            imagePath,
            width: 48,
            height: 48,
            color: Colors.blue,
            colorBlendMode: BlendMode.srcIn,
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
