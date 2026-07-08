import '_T.dart';

extension ListIntX on Iterable<int> {
  Iterable<int> accumulate() {
    return scan((prev, curr) => null == prev ? curr : prev + curr);
  }
}
