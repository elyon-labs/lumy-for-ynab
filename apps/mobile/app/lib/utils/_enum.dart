extension EnumX<T extends Enum> on T {
  T nextOf(List<T> values) {
    final currentIndex = values.indexOf(this);
    final nextIndex = (currentIndex + 1) % values.length;
    return values[nextIndex];
  }
}
