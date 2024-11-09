/// An immutable zero-cost wrapper around lists which should be passed
///   to children widgets.
extension type const ImmutableList<T>(List<T> _inner) implements Iterable<T> {
  T operator [](int index) => _inner[index];
}
