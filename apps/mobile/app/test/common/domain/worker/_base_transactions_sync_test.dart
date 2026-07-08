import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/_base_transactions_sync.dart';
import 'package:lumy/ynab_api/_base_transaction.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/transaction_factory.dart';

void main() {
  group('ListBaseTransactionSyncX', () {
    const matchingPayee = 'Payee 1';
    const nonMatchingPayee = 'Payee 2';

    bool filter(BaseTransaction t, BaseTransaction? parent) =>
        t.hasPayeeId(const Some(matchingPayee), parent: parent);

    final transactions = [
      TransactionFactory.build(id: '1', payeeId: matchingPayee, amount: 100, subTransactions: []),
      TransactionFactory.build(
        id: 'ignored',
        payeeId: nonMatchingPayee,
        amount: 100,
        subTransactions: [
          SubTransactionFactory.build(id: '2', payeeId: matchingPayee, amount: 100),
          SubTransactionFactory.build(id: '3', payeeId: matchingPayee, amount: 100),
          SubTransactionFactory.build(id: '4', payeeId: nonMatchingPayee, amount: 100),
        ],
      ),
      SubTransactionFactory.build(id: '5', payeeId: matchingPayee, amount: 100),
    ];

    test('countUnique', () {
      final result = transactions.countFilteredSync(filter);
      expect(result, 4);
    });

    test('sumAmountUnique', () {
      final result = transactions.sumAmountFilteredSync(filter);

      expect(result, 400);
    });

    test('filter', () {
      final result = transactions.filterSync(filter);

      expect(result.map((e) => e.id), ['1', 'ignored', '5']);

      expect(
        result.singleWhere((t) => t.id == 'ignored'),
        isA<PastTransaction>().having(
          (p0) => p0.subTransactions.map((e) => e.id),
          'subTransactions with Ids',
          ['2', '3'],
        ),
      );
    });
  });
}
