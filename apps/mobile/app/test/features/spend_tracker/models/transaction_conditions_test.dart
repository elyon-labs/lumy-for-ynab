import 'package:blackbird/blackbird.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/features/spend_tracker/domain/models/transaction_conditions.dart';

void main() {
  group('TransactionCondition', () {
    test('toJson', () {
      final condition = And<TransactionTestPayload, TransactionTest>([
        IsTrue(const HasCategoryId('a')),
        IsTrue(const HasMemoKeyword('b')),
        IsTrue(const IsIncome()),
      ]);

      final json = TransactionConditionX.toJson(condition);

      expect(json, {
        'type': 'and',
        'conditions': [
          {
            'type': 'isTrue',
            'test': {'type': 'hasCategoryId', 'value': 'a'},
          },
          {
            'type': 'isTrue',
            'test': {'type': 'hasMemoKeyword', 'value': 'b'},
          },
          {
            'type': 'isTrue',
            'test': {'type': 'isIncome'},
          },
        ],
      });
    });

    test('fromJson', () {
      final json = {
        'type': 'and',
        'conditions': [
          {
            'type': 'isTrue',
            'test': {'type': 'hasCategoryId', 'value': 'a'},
          },
          {
            'type': 'isTrue',
            'test': {'type': 'hasMemoKeyword', 'value': 'b'},
          },
          {
            'type': 'isTrue',
            'test': {'type': 'isIncome'},
          },
        ],
      };

      final condition = TransactionConditionX.fromJson(json);

      expect(
        condition,
        And<TransactionTestPayload, TransactionTest>([
          IsTrue(const HasCategoryId('a')),
          IsTrue(const HasMemoKeyword('b')),
          IsTrue(const IsIncome()),
        ]),
      );
    });
  });
}
