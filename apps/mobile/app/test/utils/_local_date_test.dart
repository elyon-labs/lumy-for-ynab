import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/utils/_local_date.dart';
import 'package:time_machine/time_machine.dart';

void main() {
  group('LocalDate', () {
    test('format', () {
      final date = LocalDate(2022, 1, 1);

      expect(date.MMMMdyyyy(), 'January 1 2022');
      expect(date.yyyyMMdd(), '20220101');
    });
  });
}
