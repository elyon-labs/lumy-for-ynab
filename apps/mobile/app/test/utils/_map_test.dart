import 'package:dart_foundation/src/_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ComparableMapX2', () {
    group('sortByValues', () {
      test('should sort by values', () {
        final map = {'a': 3, 'b': 1, 'c': 2};
        final result = map.sortByValues();
        expect(result.keys, ['b', 'c', 'a']);
      });
    });
  });
}
