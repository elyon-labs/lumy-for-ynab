import 'dart:math';

extension ListX<T> on List<T> {
  T pickRandom() {
    final index = Random().nextInt(length);
    return this[index];
  }
}
