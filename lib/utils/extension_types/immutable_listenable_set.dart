import "package:flutter/material.dart";
import "package:happy_habit_at/utils/data_types/listenable_set.dart";

extension type const ImmutableListenableSet<T>(ListenableSet<T> _inner)
    implements Iterable<T>, ChangeNotifier {
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

extension ImmutableListenableSetExtension<T> on ListenableSet<T> {
  ImmutableListenableSet<T> get immutable => ImmutableListenableSet<T>(this);
}
