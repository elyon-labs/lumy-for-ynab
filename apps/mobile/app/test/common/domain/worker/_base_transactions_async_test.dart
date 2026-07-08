import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/_base_transactions_async.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/category_factory.dart';
import '../../../factory/payee_factory.dart';
import '../../../factory/transaction_factory.dart';
import '../../../utilities/test_di.dart';

void main() {
  group('ListBaseTransactionAsyncX', () {
    group('groupByPayee', () {
      test('it groups transactions by payee', () async {
        await setUpTestGraph();

        final transactions = [
          TransactionFactory.build(payeeId: '1', id: '1', subTransactions: []),
          TransactionFactory.build(payeeId: '2', id: '2', subTransactions: []),
          TransactionFactory.build(payeeId: '1', id: '3', subTransactions: []),
        ];

        final payeeOne = PayeeFactory.build(id: '1', name: 'Payee 1');
        final payeeTwo = PayeeFactory.build(id: '2', name: 'Payee 2');

        final payees = [payeeOne, payeeTwo];

        final result = await transactions.groupByPayee(payees);

        expect(result, {
          Some(payeeOne): [transactions[0], transactions[2]],
          Some(payeeTwo): [transactions[1]],
        });
      });

      test('it includes transactions without a payee as None', () async {
        await setUpTestGraph();

        final transactions = [
          // Create without factory because the factory won't allow `payeeId` to be null.
          PastTransaction(
            id: '1',
            payeeId: null,
            amount: 1010100,
            categoryId: '1234',
            memo: 'memo',
            transferAccountId: null,
            isDeleted: false,
            payeeName: null,
            categoryName: 'Whatever',
            transferTransactionId: null,
            date: '2021-01-01',
            accountId: '1',
            matchedTransactionId: null,
            importId: null,
            flagColor: null,
            subTransactions: const [],
          ),
          TransactionFactory.build(payeeId: '2', id: '2', subTransactions: []),
          TransactionFactory.build(payeeId: '1', id: '3', subTransactions: []),
        ];

        final payeeOne = PayeeFactory.build(id: '1', name: 'Payee 1');
        final payeeTwo = PayeeFactory.build(id: '2', name: 'Payee 2');

        final payees = [payeeOne, payeeTwo];

        final result = await transactions.groupByPayee(payees);

        expect(result, {
          Some(payeeOne): [transactions[2]],
          Some(payeeTwo): [transactions[1]],
          const None<Payee>(): [transactions[0]],
        });
      });
    });

    group('groupByCategory', () {
      test('it groups transactions by payee', () async {
        await setUpTestGraph();

        final transactions = [
          TransactionFactory.build(categoryId: '1', id: '1', subTransactions: []),
          TransactionFactory.build(categoryId: '2', id: '2', subTransactions: []),
          TransactionFactory.build(categoryId: '1', id: '3', subTransactions: []),
        ];

        final categoryOne = CategoryFactory.build(id: '1', name: 'Category 1');
        final categoryTwo = CategoryFactory.build(id: '2', name: 'Category 2');

        final categories = [categoryOne, categoryTwo];

        final result = await transactions.groupByCategory(categories);

        expect(result, {
          categoryOne: [transactions[0], transactions[2]],
          categoryTwo: [transactions[1]],
        });
      });
    });
  }, skip: 'We need to migrate these to be extensions on Worker');
}
