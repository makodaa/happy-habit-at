extension MapPairsExtension<K, V> on Map<K, V> {
  Iterable<(K, V)> get pairs => entries.map((MapEntry<K, V> entry) => (entry.key, entry.value));
}
