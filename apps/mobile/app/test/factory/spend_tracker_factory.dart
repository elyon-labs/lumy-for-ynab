import 'package:blackbird/blackbird.dart';
import 'package:faker/faker.dart';
import 'package:lumy/features/spend_tracker/domain/models/spend_tracker.dart';
import 'package:lumy/features/spend_tracker/domain/models/transaction_conditions.dart';

final _faker = Faker();

abstract class SpendTrackerFactory {
  static SpendTracker build({
    String? id,
    String? budgetId,
    String? name,
    DateTime? createdAt,
    String? nickName,
    TransactionCondition? condition,
  }) {
    return SpendTracker(
      id: id ?? _faker.guid.guid(),
      budgetId: budgetId ?? _faker.guid.guid(),
      name: name ?? _faker.lorem.word(),
      createdAt: createdAt ?? DateTime.now(),
      nickname: nickName ?? _faker.lorem.word(),
      condition: condition ?? IsTrue(HasMemoKeyword(_faker.lorem.word())),
    );
  }
}
