import "dart:math";

import "package:flutter/material.dart";

/// A [List] implementation that notifies listeners as it is mutated.
class ListenableList<T> extends Iterable<T> with ChangeNotifier implements List<T> {
  ListenableList() : _inner = <T>[];
  ListenableList._(this._inner);

  final List<T> _inner;

  @override
  Iterator<T> get iterator => _inner.iterator;

  @override
  List<T> operator +(List<T> other) => ListenableList<T>._(_inner + other);

  @override
  T operator [](int index) => _inner[index];

  @override
  void operator []=(int index, T value) {
    if (value != _inner[index]) {
      _inner[index] = value;
      notifyListeners();
    }
  }

  @override
  void add(T value) {
    _inner.add(value);
    notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _inner.addAll(iterable);
    notifyListeners();
  }

  @override
  Map<int, T> asMap() => _inner.asMap();

  @override
  ListenableList<R> cast<R>() => ListenableList<R>._(_inner.cast<R>());

  @override
  void clear() {
    _inner.clear();
    notifyListeners();
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    _inner.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  set first(T value) {
    _inner.first = value;
    notifyListeners();
  }

  @override
  Iterable<T> getRange(int start, int end) => _inner.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _inner.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) => _inner.indexWhere(test, start);

  @override
  void insert(int index, T element) {
    _inner.insert(index, element);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _inner.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  int lastIndexOf(T element, [int? start]) => _inner.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      _inner.lastIndexWhere(test, start);

  @override
  set length(int newLength) {
    _inner.length = newLength;
    notifyListeners();
  }

  @override
  bool remove(Object? value) {
    bool result = _inner.remove(value);
    if (result) {
      notifyListeners();
    }
    return result;
  }

  @override
  T removeAt(int index) {
    T result = _inner.removeAt(index);
    notifyListeners();
    return result;
  }

  @override
  T removeLast() {
    T result = _inner.removeLast();
    notifyListeners();
    return result;
  }

  @override
  void removeRange(int start, int end) {
    _inner.removeRange(start, end);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _inner.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    _inner.replaceRange(start, end, replacements);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _inner.retainWhere(test);
    notifyListeners();
  }

  @override
  Iterable<T> get reversed => _inner.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) {
    _inner.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _inner.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    _inner.shuffle(random);
    notifyListeners();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _inner.sort(compare);
    notifyListeners();
  }

  @override
  List<T> sublist(int start, [int? end]) {
    return _inner.sublist(start, end);
  }

  @override
  set last(T value) {
    _inner.last = value;
    notifyListeners();
  }

  @override
  String toString() => "ListenableList($_inner)";
}
