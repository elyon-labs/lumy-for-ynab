import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/utils/_string.dart';
import 'package:time_machine/time_machine.dart';

void main() {
  group('StringX', () {
    test('yyyyMMddToLocalDate parses YNAB date strings', () {
      expect('2026-05-08'.yyyyMMddToLocalDate(), LocalDate(2026, 5, 8));
    });
  });
}
