import 'package:faker/faker.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'local_date_factory.dart';

final _faker = Faker();

abstract class BudgetFactory {
  static Budget build({
    String? id,
    String? name,
    String? lastModifiedOn,
    String? firstMonth,
    String? lastMonth,
    CurrencyFormat? currencyFormat,
  }) {
    return Budget(
      id: id ?? _faker.guid.guid(),
      name: id ?? _faker.lorem.word(),
      lastModifiedOn: lastModifiedOn ?? LocalDateFactory.build().yyyyMMddWithSlashes(),
      firstMonth: firstMonth ?? LocalDateFactory.build().yyyyMMddWithSlashes(),
      lastMonth: lastMonth ?? LocalDateFactory.build().yyyyMMddWithSlashes(),
      currencyFormat:
          currencyFormat ??
          CurrencyFormat(
            isoCode: _faker.currency.code(),
            decimalDigits: 2,
            decimalSeparator: '.',
            groupSeparator: ',',
            currencySymbol: r'$',
            isSymbolFirst: _faker.randomGenerator.boolean(),
            shouldDisplaySymbol: _faker.randomGenerator.boolean(),
            exampleFormat: 'S###,###.00',
          ),
    );
  }
}
