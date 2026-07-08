import 'package:faker/faker.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

final _faker = Faker();

abstract class PayeeFactory {
  static Payee build({String? id, String? name, bool? isDeleted}) {
    return Payee(
      id: id ?? _faker.guid.guid(),
      name: name ?? _faker.person.name(),
      isDeleted: isDeleted ?? _faker.randomGenerator.boolean(),
    );
  }
}
