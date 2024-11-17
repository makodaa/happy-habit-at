import "package:flutter/material.dart";
import "package:happy_habit_at/utils/data_types/listenable_list.dart";

/// An immutable zero-cost wrapper around the [ListenableList] which should be passed
///   to children widgets. This retains the notifiers of the list, while preventing mutations.
extension type const ListenableImmutableList<T>(ListenableList<T> _inner)
    implements Iterable<T>, ChangeNotifier {
  T operator [](int index) => _inner[index];
}

extension ImmutableListGenerator<T> on ListenableList<T> {
  ListenableImmutableList<T> get immutable => ListenableImmutableList<T>(this);
}
