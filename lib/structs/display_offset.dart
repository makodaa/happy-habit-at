extension type const DisplayOffset._(
    (
      (double dx, double dy) defaultOffset,
      (double dx, double dy) flippedOffset,
      (int x, int y) baseOffset,
    ) _) {

  const DisplayOffset({
    required (double dx, double dy) defaultOffset,
    required (double dx, double dy) flippedOffset,
    required (int x, int y) baseOffset,
  }): this._((defaultOffset, flippedOffset, baseOffset));

  /// This is an added offset when it is not flipped.
  (double dx, double dy) get defaultOffset => _.$1;

  /// This is the offset when the pet is flipped.
  (double dx, double dy) get flippedOffset => _.$2;

  /// The offset of the icon (in terms of tile coordinates) as default.
  (int x, int y) get baseOffset => _.$3;
}
