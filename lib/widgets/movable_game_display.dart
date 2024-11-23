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
import "package:happy_habit_at/structs/display_offset.dart";
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
  int? movingPlacementId;
  // end of moving decoration fields

  // These are the fields related to the moving pet.
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
          ...(<(Index, Widget)>[
            ..._placedDecorationWidgets(constraints)
              ..forEach(((Index, Widget) decor) {
                print((decor: decor));
              }),
            if (_petWidget(constraints) case Indexed<Widget> widget when petIsLocked)
              () {
                print((pet: widget));
                return widget;
              }(),
          ]..sort(_compareManhattanDistance))
              .map((Indexed<Widget> p) => p.$2),

          /// If we are moving them, we should prioritize them at the stack.
          if (_petWidget(constraints) case (_, Widget widget) when !petIsLocked) widget,
          if (_movingDecorationWidget(constraints) case Widget widget) widget,
        ],
      ),
    );
  }

  Widget _movableTileControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
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

                setState(() {
                  temporaryPetOffset = Offset.zero;
                  temporaryPetTileVector = (0, 0);
                  temporaryPetDraggingTileVector = (0, 0);

                  petIsLocked = true;
                });
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
                    placementId: movingPlacementId!,
                    decorationId: movingDecoration.id,
                    tileCoordinate: decorationPosition,
                    isFlipped: decorationIsFlipped,
                  );
                }

                setState(() {
                  modifyHabitatState
                    ..movingDecoration = null
                    ..decorationIsNew = null;

                  movingPlacementId = null;
                });
              } else {
                throw Exception("Invalid state.");
              }
            },
            icon: const Icon(Icons.check),
          ),
          const SizedBox(width: 24.0),

          /// Flip the icon.
          IconButton.filled(
            icon: const Icon(Icons.flip),
            style: IconButton.styleFrom(backgroundColor: Colors.grey[400]),
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
          ),

          if (!petIsLocked || movingPlacementId != null) ...<Widget>[
            const SizedBox(width: 24.0),

            /// We cancel the movement.
            IconButton.filled(
              icon: const Icon(Icons.keyboard_return_rounded),
              style: IconButton.styleFrom(backgroundColor: Colors.orange[300]),
              onPressed: () {
                if (!petIsLocked) {
                  setState(() {
                    temporaryPetOffset = Offset.zero;
                    temporaryPetTileVector = (0, 0);
                    temporaryPetDraggingTileVector = (0, 0);
                    petIsLocked = true;
                  });
                } else if (movingDecoration != null) {
                  setState(() {
                    modifyHabitatState
                      ..movingDecoration = null
                      ..decorationIsNew = null;

                    movingPlacementId = null;
                  });
                } else {
                  throw Exception("Invalid state.");
                }
              },
            ),
          ],

          if (movingDecoration != null) ...<Widget>[
            const SizedBox(width: 24.0),

            /// We delete the decoration.
            IconButton.filled(
              icon: const Icon(Icons.close),
              style: IconButton.styleFrom(backgroundColor: Colors.red[300]),
              onPressed: () async {
                if (movingPlacementId case int placementId) {
                  await appState.deletePlacement(placementId: placementId);
                }

                setState(() {
                  modifyHabitatState
                    ..movingDecoration = null
                    ..decorationIsNew = null;

                  movingPlacementId = null;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Iterable<Widget> _floorTileWidgets(BoxConstraints constraints) sync* {
    Room room = appState.activeRoom.value;

    for (var (int y, int x) in room.size.times(room.size)) {
      if (_screenPositionFromFloorTile((x, y), constraints) case (double nx, double ny)) {
        yield Positioned(
          top: ny,
          left: nx,
          child: Transform.scale(
            scale: 1.62,
            child: Image.asset(
              tileIcons[room.tileId]!.path,
              width: rotatedTileWidth,
            ),
          ),
        );
      }
    }
  }

  Iterable<(Index, Widget)> _placedDecorationWidgets(BoxConstraints constraints) sync* {
    for (Placement placement in appState.readPlacements(appState.activeRoom.value.id)) {
      if (placement.placementId == movingPlacementId) {
        continue;
      }

      var Placement(
        :int placementId,
        :String decorationId,
        :IntVector tileCoordinate,
      ) = placement;
      var DecorationIcon(
        :String imagePath,
        :bool isFacingLeft,
        imageDimensions: (double width, double height),
        displayOffset: DisplayOffset(
          baseOffset: IntVector baseOffset,
          defaultOffset: (double dx, double dy),
          flippedOffset: (double fdx, double fdy),
        ),
      ) = decorationIcons[decorationId]!;
      var (double nx, double ny) =
          _screenPositionFromFloorTile(tileCoordinate + baseOffset, constraints);
      bool isFlipped = placement.isFlipped;

      yield (
        tileCoordinate,
        Positioned(
          top: ny + (isFlipped ? fdy : dy),
          left: nx + (isFlipped ? fdx : dx),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                modifyHabitatState
                  ..decorationIsNew = false
                  ..movingDecoration = appState.decorations //
                      .firstWhere((HabitatDecoration d) => d.id == decorationId);

                movingPlacementId = placementId;
                decorationPosition = tileCoordinate;
                decorationIsFlipped = isFlipped;
              });
            },
            child: Transform.flip(
              flipX: placement.isFlipped,
              child: Image.asset(
                width: width,
                height: height,
                imagePath,
              ),
            ),
          ),
        ),
      );
    }
  }

  (Index, Widget)? _petWidget(BoxConstraints constraints) {
    PetIcon? petIcon = petIcons[appState.activeRoom.value.petId];
    if (petIcon == null) {
      return null;
    }

    var PetIcon(
      :String path,
      dimensions: (double width, double height),
      displayOffset: DisplayOffset(
        defaultOffset: (double dx, double dy),
        flippedOffset: (double fdx, double fdy),
        baseOffset: IntVector offset,
      ),
      :bool imageIsFacingLeft,
    ) = petIcon;

    var (double x, double y) = _screenPositionFromFloorTile(
      petPosition + offset + temporaryPetDraggingTileVector + temporaryPetTileVector,
      constraints,
    );
    bool isFlipped = imageIsFacingLeft ^ petIsFlipped;

    return (
      petPosition,
      Positioned(
        top: y + (isFlipped ? fdy : dy),
        left: x + (isFlipped ? fdx : dx),
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
            IntVector tileAdjustment =
                _floorTilePositionFromRelativeOffset(temporaryPetOffset.pair);
            var (IntVector newPoint) = tileAdjustment + //
                temporaryPetTileVector +
                petPosition;
            var (int dx, int dy) = (activeRoom.size, activeRoom.size) - newPoint;

            /// We have crossed the boundary at bottom right.
            if (dx <= 0) {
              tileAdjustment = (tileAdjustment.$1 - (dx.abs() + 1), tileAdjustment.$2);
            } else if (dx > activeRoom.size) {
              tileAdjustment =
                  (tileAdjustment.$1 + (activeRoom.size - dx).abs(), tileAdjustment.$2);
            }

            if (dy <= 0) {
              tileAdjustment = (tileAdjustment.$1, tileAdjustment.$2 - (dy.abs() + 1));
            } else if (dy > activeRoom.size) {
              tileAdjustment =
                  (tileAdjustment.$1, tileAdjustment.$2 + (activeRoom.size - dy).abs());
            }

            setState(() {
              temporaryPetDraggingTileVector = tileAdjustment;
            });
          },
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
      )
    );
  }

  Widget? _movingDecorationWidget(BoxConstraints constraints) {
    String? decorationId = movingDecoration?.id;
    if (decorationId == null) {
      return null;
    }

    var DecorationIcon(
      :String imagePath,
      :int happinessBuff,
      :int energyBuff,
      :bool isFacingLeft,
      imageDimensions: (double width, double height),
      displayOffset: DisplayOffset(
        baseOffset: IntVector baseOffset,
        defaultOffset: (double dx, double dy),
        flippedOffset: (double fdx, double fdy),
      ),
    ) = decorationIcons[decorationId]!;

    var (double x, double y) = _screenPositionFromFloorTile(
      baseOffset +
          decorationPosition +
          temporaryDecorationTileVector +
          temporaryDecorationDraggingTileVector,
      constraints,
    );
    bool isFlipped = isFacingLeft ^ decorationIsFlipped;

    return Positioned(
      top: y + (isFlipped ? fdy : dy),
      left: x + (isFlipped ? fdx : dx),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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

          var (IntVector newPoint) = tileAdjustment + //
              temporaryDecorationTileVector +
              decorationPosition;
          var (int dx, int dy) = (activeRoom.size, activeRoom.size) - newPoint;

          /// We have crossed the boundary at bottom right.
          if (dx <= 0) {
            tileAdjustment = (tileAdjustment.$1 - (dx.abs() + 1), tileAdjustment.$2);
          } else if (dx > activeRoom.size) {
            tileAdjustment = (tileAdjustment.$1 + (activeRoom.size - dx).abs(), tileAdjustment.$2);
          }

          if (dy <= 0) {
            tileAdjustment = (tileAdjustment.$1, tileAdjustment.$2 - (dy.abs() + 1));
          } else if (dy > activeRoom.size) {
            tileAdjustment = (tileAdjustment.$1, tileAdjustment.$2 + (activeRoom.size - dy).abs());
          }

          setState(() {
            temporaryDecorationDraggingTileVector = tileAdjustment;
          });
        },
        child: Transform.flip(
          flipX: isFlipped,
          child: Image.asset(
            imagePath,
            width: width,
            height: height,
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

  int _compareManhattanDistance((Index, Widget) a, (Index, Widget) b) {
    return (a.$1.$1 + a.$1.$2) - (b.$1.$1 + b.$1.$2);
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
  IntVector operator +(IntVector other) => (this.$1 + other.$1, this.$2 + other.$2);
  IntVector operator -(IntVector other) => (this.$1 - other.$1, this.$2 - other.$2);
}
