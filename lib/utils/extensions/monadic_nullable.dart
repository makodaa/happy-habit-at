extension MonadicNullable<T extends Object> on T? {
  /// Allows for mapping a nullable value to another nullable value.
  ///   Useful as alternatives for conditional null checking:
  ///   ```dart
  ///   // Usual pattern:
  ///   var v = nullableValue == null ? null : process(nullableValue)
  ///
  ///   // This is equivalent.
  ///   var v = nullableValue.nullableMap((v) => process(v))
  ///   ```
  R? nullableMap<R>(R Function(T) mappingFunction) {
    if (this case T value) {
      return mappingFunction(value);
    }

    return null;
  }

  /// Allows for mapping a nullable value to another nullable value.
  /// As an alternative to [nullableMap], it allows values to be null
  /// based on the given [mappingFunction].
  R? nullableFlatMap<R>(R? Function(T) mappingFunction) {
    if (this case T value) {
      return mappingFunction(value);
    }

    return null;
  }
}
