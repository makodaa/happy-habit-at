import "package:flutter/material.dart";

/// A [List] implementation that notifies listeners as it is mutated.
class ListenableSet<T> extends Iterable<T> with ChangeNotifier implements Set<T> {
  ListenableSet([Set<T>? inner]) : _inner = inner ?? <T>{};
  ListenableSet.identity() : _inner = Set<T>.identity();

  final Set<T> _inner;

  @override
  int get length => _inner.length;

  @override
  Iterator<T> get iterator => _inner.iterator;

  @override
  String toString() => "ListenableSet($_inner)";

  @override
  bool add(T value) {
    if (_inner.add(value)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void addAll(Iterable<T> elements) {
    int countBefore = _inner.length;
    _inner.addAll(elements);
    if (_inner.length > countBefore) {
      notifyListeners();
    }
  }

  @override
  void clear() {
    if (_inner.isNotEmpty) {
      _inner.clear();
      notifyListeners();
    }
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    return _inner.containsAll(other);
  }

  @override
  Set<T> difference(Set<Object?> other) {
    return _inner.difference(other);
  }

  @override
  Set<T> intersection(Set<Object?> other) {
    return _inner.intersection(other);
  }

  @override
  T? lookup(Object? object) {
    return _inner.lookup(object);
  }

  @override
  bool remove(Object? value) {
    if (_inner.remove(value)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    if (_inner.isNotEmpty) {
      int beforeLength = _inner.length;
      _inner.removeAll(elements);
      if (_inner.length != beforeLength) {
        notifyListeners();
      }
    }
  }

  @override
  void removeWhere(bool Function(T element) test) {
    if (_inner.isNotEmpty) {
      int beforeLength = _inner.length;
      _inner.removeWhere(test);
      if (_inner.length != beforeLength) {
        notifyListeners();
      }
    }
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    if (_inner.isNotEmpty) {
      int beforeLength = _inner.length;
      _inner.retainAll(elements);
      if (_inner.length != beforeLength) {
        notifyListeners();
      }
    }
  }

  @override
  void retainWhere(bool Function(T element) test) {
    if (_inner.isNotEmpty) {
      int beforeLength = _inner.length;
      _inner.retainWhere(test);
      if (_inner.length != beforeLength) {
        notifyListeners();
      }
    }
  }

  @override
  Set<T> union(Set<T> other) {
    return _inner.union(other);
  }

  @override
  Set<R> cast<R>() => ListenableSet<R>(_inner.cast<R>());
}
