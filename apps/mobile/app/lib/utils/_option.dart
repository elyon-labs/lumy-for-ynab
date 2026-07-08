import 'package:oxidized/oxidized.dart';

extension NullableOptionX<T extends Object?> on Option<T> {
  Option<U> mapNullable<U extends Object>(U? Function(T value) fn) {
    final x = map((value) => fn(value));
    return x.isSome() ? Some(x.unwrap()!) : None<U>();
  }
}
