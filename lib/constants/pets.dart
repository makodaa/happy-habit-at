typedef PetIcon = (
  /// The asset path of the pet icon.
  String path,

  /// The width and height of the pet icon.
  (double width, double height),

  /// This is an added offset when it is not flipped.
  (double dx, double dy) defaultOffset,

  /// This is the offset when the pet is flipped.
  (double dx, double dy) flippedOffset,

  /// The offset of the pet icon (in terms of tile coordinates) as default.
  (int x, int y) baseOffset,

  /// Whether the asset icon is facing left.
  bool isFacingLeft,
);

const List<PetIcon> petIcons = <PetIcon>[
  (
    "assets/images/dog.png",
    (48.0, 48.0),
    (2.0, 8.0),
    (-6.0, 8.0),
    (-1, -1),
    true,
  ),
];
