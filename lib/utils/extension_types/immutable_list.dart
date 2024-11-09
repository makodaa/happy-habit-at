/// An immutable zero-cost wrapper around lists which should be passed
///   to children widgets. This ensures that the list is not modified
///   in other parts of the code except where it is created.
extension type const ImmutableList<T>(List<T> _inner) implements Iterable<T> {
  T operator [](int index) => _inner[index];
}
