import 'package:faker/faker.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

final _faker = Faker();

abstract class CategoryFactory {
  static Category build({
    String? id,
    String? name,
    bool? isHidden,
    bool? isDeleted,
    String? categoryGroupId,
    int? activity,
    int? budgeted,
    int? balance,
    TargetType? targetType,
    bool? targetNeedsWholeAmount,
    int? targetDay,
    int? targetCadence,
    int? targetCadenceFrequency,
    String? targetCreationMonth,
    int? targetBalance,
    String? targetMonth,
    int? targetPercentageComplete,
    int? targetMonthsToBudget,
    int? targetUnderFunded,
    int? targetOverallFunded,
    int? targetOverallLeft,
  }) {
    return Category(
      id: id ?? _faker.guid.guid(),
      name: name ?? _faker.lorem.word(),
      isHidden: isHidden ?? _faker.randomGenerator.boolean(),
      isDeleted: isDeleted ?? _faker.randomGenerator.boolean(),
      categoryGroupId: categoryGroupId ?? _faker.guid.guid(),
      activity: activity ?? _faker.randomGenerator.integer(1000),
      budgeted: budgeted ?? _faker.randomGenerator.integer(1000),
      balance: balance ?? _faker.randomGenerator.integer(1000),
      targetType: targetType,
      targetNeedsWholeAmount: targetNeedsWholeAmount,
      targetDay: targetDay,
      targetCadence: targetCadence,
      targetCadenceFrequency: targetCadenceFrequency,
      targetCreationMonth: targetCreationMonth,
      targetBalance: targetBalance,
      targetMonth: targetMonth,
      targetPercentageComplete: targetPercentageComplete,
      targetMonthsToBudget: targetMonthsToBudget,
      targetUnderFunded: targetUnderFunded,
      targetOverallFunded: targetOverallFunded,
      targetOverallLeft: targetOverallLeft,
    );
  }
}
