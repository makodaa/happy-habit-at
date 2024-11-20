import "package:flutter/material.dart";
import "package:happy_habit_at/utils/data_types/listenable_list.dart";

/// An immutable zero-cost wrapper around the [ListenableList] which should be passed
///   to children widgets. This retains the notifiers of the list, while preventing mutations.
extension type const ImmutableListenableList<T>(ListenableList<T> _inner)
    implements Iterable<T>, ChangeNotifier {
  @pragma("vm:prefer-inline")
  T operator [](int index) => _inner[index];
}

extension ImmutableListGenerator<T> on ListenableList<T> {
  @pragma("vm:prefer-inline")
  ImmutableListenableList<T> get immutable => ImmutableListenableList<T>(this);
}
