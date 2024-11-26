import "package:happy_habit_at/structs/display_offset.dart";

typedef PetIcon = ({
  /// The asset imagePath of the pet icon.
  String imagePath,

  /// The name of the pet.
  String name,

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
    name: "Dog",
    imagePath: "assets/images/pets/dog.png",
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
    name: "Cat",
    imagePath: "assets/images/pets/cat.png",
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
    name: "Buffalo",
    imagePath: "assets/images/pets/buffalo.png",
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
    name: "Cow",
    imagePath: "assets/images/pets/cow.png",
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
    name: "Bunny",
    imagePath: "assets/images/pets/bunny.png",
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
    name: "Deer",
    imagePath: "assets/images/pets/deer.png",
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
