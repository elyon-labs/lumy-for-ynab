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

    group('replaceTransactions', () {
      test('replaces only the target budget and removes stale subtransactions', () async {
        await database.insertTransactions(
          [
            TransactionFactory.build(
              id: 'stale',
              isDeleted: false,
              subTransactions: [
                SubTransactionFactory.build(id: 'stale-subtransaction', isDeleted: false),
              ],
            ),
          ],
          budgetId: 'budget-1',
          knowledge: 1,
        );
        await database.insertTransactions(
          [TransactionFactory.build(id: 'other-budget', isDeleted: false, subTransactions: [])],
          budgetId: 'budget-2',
          knowledge: 2,
        );

        await database.replaceTransactions(
          [
            TransactionFactory.build(
              id: 'pending',
              isDeleted: false,
              importId: 'YNAB:P:-1000:2026-01-01:1',
              subTransactions: [],
            ),
          ],
          budgetId: 'budget-1',
          knowledge: 3,
        );

        final budget1Transactions = await database.watchTransactions(budgetId: 'budget-1').first;
        final budget2Transactions = await database.watchTransactions(budgetId: 'budget-2').first;
        final subTransactions = await database.select(database.dbSubTransactions).get();

        expect(budget1Transactions.map((transaction) => transaction.id), ['pending']);
        expect(budget2Transactions.map((transaction) => transaction.id), ['other-budget']);
        expect(subTransactions, isEmpty);
        expect(await database.getTransactionKnowledge(budgetId: 'budget-1'), 3);
        expect(await database.getTransactionKnowledge(budgetId: 'budget-2'), 2);
      });

      test('an empty snapshot clears the target budget and advances knowledge', () async {
        await database.insertTransactions(
          [TransactionFactory.build(id: 'stale', isDeleted: false, subTransactions: [])],
          budgetId: 'budget-1',
          knowledge: 1,
        );

        await database.replaceTransactions([], budgetId: 'budget-1', knowledge: 2);

        expect(await database.watchTransactions(budgetId: 'budget-1').first, isEmpty);
        expect(await database.getTransactionKnowledge(budgetId: 'budget-1'), 2);
      });
    });
  });
}
