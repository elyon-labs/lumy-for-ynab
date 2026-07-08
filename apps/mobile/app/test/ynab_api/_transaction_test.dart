import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/utils/_local_date.dart';
import 'package:lumy/ynab_api/_transaction.dart';
import 'package:time_machine/time_machine.dart';

import '../factory/transaction_factory.dart';

void main() {
  group('TransactionX', () {
    test('localDate', () {
      final transaction = TransactionFactory.build(date: '2023-08-31');

      expect(transaction.localDate, LocalDate(2023, 8, 31));
    });

    test('localDate caches by date string', () {
      cachedLocalDates.clear();
      final first = TransactionFactory.build(id: 'first', date: '2023-08-31');
      final second = TransactionFactory.build(id: 'second', date: '2023-08-31');

      expect(first.localDate, LocalDate(2023, 8, 31));
      expect(second.localDate, LocalDate(2023, 8, 31));
      expect(cachedLocalDates, hasLength(1));
    });
  });
}
