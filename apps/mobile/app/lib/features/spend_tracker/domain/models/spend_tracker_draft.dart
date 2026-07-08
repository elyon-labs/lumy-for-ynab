import 'package:blackbird/blackbird.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'transaction_conditions.dart';

part 'spend_tracker_draft.mapper.dart';

extension TxnTestTypeX on TransactionTestType {
  TransactionTest toTest(String? value) {
    return switch (this) {
      TransactionTestType.hasFlagColor => HasFlagColor(value!),
      TransactionTestType.hasPayeeId => HasPayeeId(value!),
      TransactionTestType.hasCategoryId => HasCategoryId(value!),
      TransactionTestType.hasCategoryGroupId => HasCategoryGroupId(value!),
      TransactionTestType.hasAccountId => HasAccountId(value!),
      TransactionTestType.isIncome => const IsIncome(),
      TransactionTestType.isInflow => const IsInflow(),
      TransactionTestType.isExpense => const IsExpense(),
      TransactionTestType.isOutflow => const IsOutflow(),
      TransactionTestType.hasMemoKeyword => HasMemoKeyword(value!),
    };
  }
}

sealed class SpendTrackerTypeChoice {
  const SpendTrackerTypeChoice();
}

class Single extends SpendTrackerTypeChoice {
  const Single(this.type);
  final TransactionTestType type;
}

class Multi extends SpendTrackerTypeChoice {
  const Multi();
}

@MappableClass()
class SpendTrackerDraft with SpendTrackerDraftMappable {
  SpendTrackerDraft({this.name, this.type, this.condition});

  final String? name;
  final SpendTrackerTypeChoice? type;
  final TransactionCondition? condition;
}

extension SpendTrackerDraftX on SpendTrackerDraft {
  SpendTrackerDraft setName(String name) => copyWith(name: name);
  SpendTrackerDraft setCondition(TransactionCondition condition) => copyWith(condition: condition);
  SpendTrackerDraft setType(SpendTrackerTypeChoice type) => copyWith(type: type);
  bool isMultiQuery() => type is Multi;
  bool isTestType(TransactionTestType txnTestType) {
    return switch (type) {
      Single(:final type) => type == txnTestType,
      Multi() => false,
      null => false,
    };
  }
}
