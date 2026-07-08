// ignore_for_file: file_names
extension NestedListGenerics<T> on Iterable<Iterable<T>> {
  /// Flattens the nested list into a single list.
  ///
  /// We use this rather than `flattened` because the latter returns
  /// an unevaluated/lazy iterable which cannot be sent across isolates.
  /// see: https://github.com/dart-lang/sdk/issues/51757
  Iterable<T> flattenSafe() {
    return expand((e) => e);
  }
}

extension ListGenerics<T> on Iterable<T> {
  T get second => elementAt(1);
  T get third => elementAt(2);
  T get forth => elementAt(3);
  T get secondToLast => elementAt(length - 2);

  Iterable<T> takeLast(int number) {
    if (number >= length) return this;
    return skip(length - number);
  }

  Iterable<T> scan(T Function(T? prev, T curr) op) sync* {
    if (isEmpty) return;
    yield op(null, first);
    var sum = first;
    for (final element in skip(1)) {
      sum = op(sum, element);
      yield sum;
    }
  }

  Future<Iterable<R>> mapAsync<R>(Future<R> Function(T) op) async {
    final results = <R>[];
    for (final element in this) {
      results.add(await op(element));
    }
    return results;
  }
}
