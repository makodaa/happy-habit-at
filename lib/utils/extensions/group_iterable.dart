extension GroupIterable<T> on Iterable<T> {
  Iterable<List<T>> group(int size) sync* {
    List<T> group = <T>[];

    for (T element in this) {
      group.add(element);

      if (group.length == size) {
        yield group;
        group = <T>[];
      }
    }

    if (group.isNotEmpty) {
      yield group;
    }
  }
}
