import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/persistence/drift/local_database.dart';

import '../factory/transaction_factory.dart';

void main() {
  group('Transactions persistence', () {
    late LocalDatabase database;

    setUp(() {
      database = LocalDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    group('watchTransactions', () {
      test('emits pending imported transactions', () async {
        await database.insertTransactions(
          [
            TransactionFactory.build(
              id: 'normal',
              isDeleted: false,
              importId: 'YNAB:-1000:2026-01-01:1',
              subTransactions: [],
            ),
            TransactionFactory.build(
              id: 'pending',
              isDeleted: false,
              importId: 'YNAB:P:-1000:2026-01-01:1',
              subTransactions: [],
            ),
          ],
          budgetId: 'budget-1',
          knowledge: 1,
        );

        final transactions = await database.watchTransactions(budgetId: 'budget-1').first;

        expect(
          transactions.map((transaction) => transaction.id),
          unorderedEquals(['normal', 'pending']),
        );
      });

      test('emits imported transactions that are not pending', () async {
        await database.insertTransactions(
          [
            TransactionFactory.build(
              id: 'normal',
              isDeleted: false,
              importId: 'YNAB:-1000:2026-01-01:1',
              subTransactions: [],
            ),
            TransactionFactory.build(
              id: 'manual',
              isDeleted: false,
              importId: null,
              subTransactions: [],
            ),
            TransactionFactory.build(
              id: 'contains-p',
              isDeleted: false,
              importId: 'YNAB:-1000:2026-01-01:P',
              subTransactions: [],
            ),
          ],
          budgetId: 'budget-1',
          knowledge: 1,
        );

        final transactions = await database.watchTransactions(budgetId: 'budget-1').first;

        expect(
          transactions.map((transaction) => transaction.id),
          unorderedEquals(['normal', 'manual', 'contains-p']),
        );
      });

      test('does not emit deleted subtransactions', () async {
        await database.insertTransactions(
          [
            TransactionFactory.build(
              id: 'split',
              isDeleted: false,
              importId: null,
              subTransactions: [
                SubTransactionFactory.build(id: 'active-subtransaction', isDeleted: false),
                SubTransactionFactory.build(id: 'deleted-subtransaction', isDeleted: true),
              ],
            ),
          ],
          budgetId: 'budget-1',
          knowledge: 1,
        );

        final transactions = await database.watchTransactions(budgetId: 'budget-1').first;

        expect(transactions, hasLength(1));
        expect(transactions.single.subTransactions.map((subTransaction) => subTransaction.id), [
          'active-subtransaction',
        ]);
      });
    });
  });
}
