import "package:happy_habit_at/structs/display_offset.dart";

typedef PetIcon = ({
  /// The asset path of the pet icon.
  String path,

  /// Pet model
  String model,

  /// The width and height of the pet image icon.
  (double width, double height) dimensions,
  DisplayOffset displayOffset,

  /// Whether the asset icon is facing left.
  bool imageIsFacingLeft,
});

const Map<String, PetIcon> petIcons = <String, PetIcon>{
  "dog": (
    path: "assets/images/pets/dog.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "cat": (
    path: "assets/images/pets/cat.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "buffalo": (
    path: "assets/images/pets/buffalo.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "cow": (
    path: "assets/images/pets/cow.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "bunny": (
    path: "assets/images/pets/bunny.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "deer": (
    path: "assets/images/pets/deer.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "duck": (
    path: "assets/images/pets/duck.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "elephant": (
    path: "assets/images/pets/elephant.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "cottontailrabbit": (
    path: "assets/images/pets/cottontailrabbit.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "giraffe": (
    path: "assets/images/pets/giraffe.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "goat": (
    path: "assets/images/pets/goat.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "horse": (
    path: "assets/images/pets/horse.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "llama": (
    path: "assets/images/pets/llama.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "pig": (
    path: "assets/images/pets/pig.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "penguin": (
    path: "assets/images/pets/penguin.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "sheep": (
    path: "assets/images/pets/sheep.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "reindeer": (
    path: "assets/images/pets/reindeer.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "squirrel": (
    path: "assets/images/pets/squirrel.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "hamster": (
    path: "assets/images/pets/hamster.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "whitebear": (
    path: "assets/images/pets/whitebear.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "bear": (
    path: "assets/images/pets/bear.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
  "zebra": (
    path: "assets/images/pets/zebra.png",
    model: "",
    dimensions: (48.0, 48.0),
    displayOffset: DisplayOffset(
      defaultOffset: (2.0, 8.0),
      flippedOffset: (-6.0, 8.0),
      baseOffset: (-1, -1),
    ),
    imageIsFacingLeft: true,
  ),
};
