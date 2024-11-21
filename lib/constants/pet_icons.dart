// TODO(makodaa): What is pet model?

typedef PetIcon = ({
  /// The asset path of the pet icon.
  String path,

  /// Pet model
  String model,

  /// The width and height of the pet image icon.
  (double width, double height) dimensions,

  /// This is an added offset when it is not flipped.
  (double dx, double dy) defaultOffset,

  /// This is the offset when the pet is flipped.
  (double dx, double dy) flippedOffset,

  /// The offset of the pet icon (in terms of tile coordinates) as default.
  (int x, int y) baseOffset,

  /// Whether the asset icon is facing left.
  bool imageIsFacingLeft,
});

const Map<String, PetIcon> petIcons = <String, PetIcon>{
  "dog": (
    path: "assets/images/pets/dog.png",
    model: "",
    dimensions: (48.0, 48.0),
    defaultOffset: (2.0, 8.0),
    flippedOffset: (-6.0, 8.0),
    baseOffset: (-1, -1),
    imageIsFacingLeft: true,
  ),
};
