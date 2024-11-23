extension SortedByExtension<E> on List<E> {
  List<E> sortedBy([int Function(E, E)? compare]) {
    List<E> list = List<E>.from(this);
    list.sort(
      (E a, E b) => a is Comparable && b is Comparable
          ? (a as Comparable<dynamic>).compareTo(b as Comparable<dynamic>)
          : compare!(a, b),
    );
    return list;
  }
}
