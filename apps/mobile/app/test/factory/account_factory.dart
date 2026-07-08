import 'package:faker/faker.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

final _faker = Faker();

abstract class AccountFactory {
  static Account build({
    String? id,
    String? name,
    bool? isOnBudget,
    bool? isClosed,
    AccountType? type,
    int? balance,
  }) {
    return Account(
      id: id ?? _faker.guid.guid(),
      name: name ?? _faker.lorem.word(),
      isOnBudget: isOnBudget ?? _faker.randomGenerator.boolean(),
      isClosed: isClosed ?? _faker.randomGenerator.boolean(),
      isDeleted: isClosed ?? _faker.randomGenerator.boolean(),
      type:
          type ?? AccountType.values[_faker.randomGenerator.integer(AccountType.values.length - 1)],
      balance: balance ?? _faker.randomGenerator.integer(100000),
      debtInterestRates: const {},
      debtMinimumPayments: const {},
      debtEscrowAmounts: const {},
    );
  }
}
