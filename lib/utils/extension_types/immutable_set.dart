extension type const ImmutableSet<T>(Set<T> _inner) implements Iterable<T> {
  Set<T> difference(Set<Object?> other) {
    return _inner.difference(other);
  }

  Set<T> intersection(Set<Object?> other) {
    return _inner.intersection(other);
  }

  T? lookup(Object? object) {
    return _inner.lookup(object);
  }

  Set<T> union(Set<T> other) {
    return _inner.union(other);
  }
}

extension ImmutableSetExtension<T> on Set<T> {
  ImmutableSet<T> get immutable => ImmutableSet<T>(this);
}
