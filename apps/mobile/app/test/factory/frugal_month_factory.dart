import 'package:faker/faker.dart';
import 'package:lumy/features/frugal_month/domain/models/frugal_month.dart';
import 'package:time_machine/time_machine.dart';

final _faker = Faker();

abstract class FrugalMonthFactory {
  static FrugalMonth build({
    String? budgetId,
    String? id,
    LocalDate? date,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  }) {
    return FrugalMonth(
      budgetId: _faker.guid.guid(),
      id: _faker.guid.guid(),
      month: date ?? LocalDate(1970, 1, 1),
      targetAmount: _faker.randomGenerator.integer(1000000),
      categoryIds: List.generate(10, (index) => _faker.guid.guid()),
      accountIds: List.generate(10, (index) => _faker.guid.guid()),
    );
  }
}
