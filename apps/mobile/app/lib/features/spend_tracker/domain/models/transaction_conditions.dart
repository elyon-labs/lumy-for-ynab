import 'package:blackbird/blackbird.dart';
import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../ynab_api/_base_transaction.dart';

/// The payload that is provided to a [TransactionTest] for evaluation.
///
/// The txn is the transaction to be evaluated.
/// The groups are [CategoryGroup]s which are required for some tests,
/// but are only transitively related to the transaction, so transactions
/// themselves have no information about the [Category] group it belongs
/// to.
typedef TransactionTestPayload = ({
  BaseTransaction txn,
  BaseTransaction? parent,
  List<CategoryGroup> groups,
});

/// A [Condition] that can be used to evaluate a [TransactionTestPayload].
///
/// The leaf nodes of the condition tree are [TransactionTest]s.
typedef TransactionCondition = Condition<TransactionTestPayload, TransactionTest>;

/// A [Test] that can be used to evaluate a [TransactionTestPayload].
///
/// Makes up the leaf nodes of a [TransactionCondition].
sealed class TransactionTest extends Test<TransactionTestPayload> {
  const TransactionTest();

  Map<String, dynamic> toJson();
}

/// A [TransactionTest] that checks the payload against a specified value.
sealed class MatchesValue extends TransactionTest {
  const MatchesValue(this.value);
  final String value;

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'value': value};
  }

  @override
  List<Object?> get props => [value];
}

/// A [TransactionTest] that checks the payload against some arbitrary logic.
sealed class MatchesLogic extends TransactionTest {
  const MatchesLogic();

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name};
  }
}

/// An [Enum] that can be used to identify a [TransactionTest]'s type. Useful for
/// representing the type of a [TransactionTest] in a database.
enum TransactionTestType {
  hasFlagColor,
  hasPayeeId,
  hasCategoryId,
  hasCategoryGroupId,
  hasAccountId,
  isIncome,
  isInflow,
  isExpense,
  isOutflow,
  hasMemoKeyword,
}

class TransactionConditionSimpleMapper extends SimpleMapper<TransactionCondition> {
  const TransactionConditionSimpleMapper();

  @override
  TransactionCondition decode(Object value) {
    return TransactionConditionX.fromJson(value as Map<String, dynamic>);
  }

  @override
  Object? encode(TransactionCondition self) {
    return TransactionConditionX.toJson(self);
  }
}

extension TransactionConditionX on TransactionCondition {
  /// Converts a [TransactionCondition] to a JSON-serializable map.
  /// This is a static method so it can be passed to `JsonKey` annotations.
  static Map<String, dynamic> toJson(TransactionCondition c) {
    return switch (c) {
      TestCondition(:final test) => {'type': c.type.name, 'test': test.toJson()},
      NestedCondition(:final conditions) => {
        'type': c.type.name,
        'conditions': conditions.map(TransactionConditionX.toJson).toList(),
      },
    };
  }

  /// Converts a JSON-serializable map to a [TransactionCondition].
  static TransactionCondition fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final conditionType = ConditionType.values.byName(type);
    return conditionType.fromJson(json);
  }

  /// Evaluates the condition tree without relying on dynamic callable syntax.
  ///
  /// Some compilers/runtimes (notably web) can mis-handle calling objects
  /// with a `call()` method through generic types. This explicitly dispatches
  /// to `call` and recurses, avoiding those issues.
  bool evaluateSafe(TransactionTestPayload payload) {
    final self = this;
    return switch (self) {
      IsTrue<TransactionTestPayload, TransactionTest>(:final test) => test.call(payload),
      IsNotTrue<TransactionTestPayload, TransactionTest>(:final test) => !test.call(payload),
      And<TransactionTestPayload, TransactionTest>(:final conditions) => conditions.every(
        (c) => c.evaluateSafe(payload),
      ),
      Or<TransactionTestPayload, TransactionTest>(:final conditions) => conditions.any(
        (c) => c.evaluateSafe(payload),
      ),
    };
  }
}

extension on ConditionType {
  /// Converts a JSON-serializable map to a [TransactionCondition].
  ///
  /// The type of [TransactionCondition] returned depends on the [ConditionType]
  /// this method is called on.
  TransactionCondition fromJson(Map<String, dynamic> json) {
    return switch (this) {
      ConditionType.isTrue => IsTrue<TransactionTestPayload, TransactionTest>(
        TransactionTestX.fromJson(json['test'] as Map<String, dynamic>),
      ),
      ConditionType.isNotTrue => IsNotTrue<TransactionTestPayload, TransactionTest>(
        TransactionTestX.fromJson(json['test'] as Map<String, dynamic>),
      ),
      ConditionType.and => And<TransactionTestPayload, TransactionTest>(
        (json['conditions'] as List<dynamic>)
            .map((j) => TransactionConditionX.fromJson(j as Map<String, dynamic>))
            .toList(),
      ),
      ConditionType.or => Or<TransactionTestPayload, TransactionTest>(
        (json['conditions'] as List<dynamic>)
            .map((j) => TransactionConditionX.fromJson(j as Map<String, dynamic>))
            .toList(),
      ),
    };
  }
}

extension TransactionTestX on TransactionTest {
  /// Returns the [TransactionTestType] of the [TransactionTest].
  TransactionTestType get type {
    return switch (this) {
      HasFlagColor() => TransactionTestType.hasFlagColor,
      HasPayeeId() => TransactionTestType.hasPayeeId,
      HasCategoryId() => TransactionTestType.hasCategoryId,
      HasCategoryGroupId() => TransactionTestType.hasCategoryGroupId,
      HasAccountId() => TransactionTestType.hasAccountId,
      HasMemoKeyword() => TransactionTestType.hasMemoKeyword,
      IsIncome() => TransactionTestType.isIncome,
      IsInflow() => TransactionTestType.isInflow,
      IsExpense() => TransactionTestType.isExpense,
      IsOutflow() => TransactionTestType.isOutflow,
    };
  }

  /// Converts a JSON-serializable map to a [TransactionTest].
  static TransactionTest fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final testType = TransactionTestType.values.byName(type);
    return testType.fromJson(json);
  }
}

extension TransactionTestTypeX on TransactionTestType {
  /// Converts a JSON-serializable map to a [TransactionTest].
  ///
  /// The type of [TransactionTest] returned depends on the [TransactionTestType]
  /// this method is called on.
  TransactionTest fromJson(Map<String, dynamic> json) {
    switch (this) {
      case TransactionTestType.hasFlagColor:
        return HasFlagColor(json['value'] as String);
      case TransactionTestType.hasPayeeId:
        return HasPayeeId(json['value'] as String);
      case TransactionTestType.hasCategoryId:
        return HasCategoryId(json['value'] as String);
      case TransactionTestType.hasCategoryGroupId:
        return HasCategoryGroupId(json['value'] as String);
      case TransactionTestType.hasAccountId:
        return HasAccountId(json['value'] as String);
      case TransactionTestType.hasMemoKeyword:
        return HasMemoKeyword(json['value'] as String);
      case TransactionTestType.isIncome:
        return const IsIncome();
      case TransactionTestType.isInflow:
        return const IsInflow();
      case TransactionTestType.isExpense:
        return const IsExpense();
      case TransactionTestType.isOutflow:
        return const IsOutflow();
    }
  }
}

class HasFlagColor extends MatchesValue {
  const HasFlagColor(super.value);

  @override
  bool call(TransactionTestPayload t) {
    return switch (t.txn) {
      PastTransaction(:final flagColor) => flagColor == value,
      SubTransaction() => false,
      ScheduledTransaction(:final flagColor) => flagColor == value,
      ScheduledSubTransaction() => false,
    };
  }
}

class HasPayeeId extends MatchesValue {
  const HasPayeeId(super.value);

  @override
  bool call(TransactionTestPayload t) {
    return t.txn.hasPayeeId(Some(value), parent: t.parent);
  }
}

class HasCategoryId extends MatchesValue {
  const HasCategoryId(super.value);
  @override
  bool call(TransactionTestPayload t) {
    // Split transactions have no category id
    return !t.txn.isSplit && t.txn.categoryId == value;
  }
}

class HasCategoryGroupId extends MatchesValue {
  const HasCategoryGroupId(super.value);
  @override
  bool call(TransactionTestPayload t) {
    final group = t.groups.firstWhereOrNull((g) => g.id == value);
    return group != null && group.categories.any((c) => c.id == t.txn.categoryId);
  }
}

class HasMemoKeyword extends MatchesValue {
  const HasMemoKeyword(super.value);

  @override
  bool call(TransactionTestPayload t) {
    return t.txn.memo?.containsCaseInsensitive(value) ?? false;
  }
}

class HasAccountId extends MatchesValue {
  const HasAccountId(super.value);

  @override
  bool call(TransactionTestPayload t) {
    return t.txn is PastTransaction && (t.txn as PastTransaction).accountId == value;
  }
}

class IsIncome extends MatchesLogic {
  const IsIncome();

  @override
  bool call(TransactionTestPayload t) {
    return t.txn.isIncome;
  }

  @override
  List<Object?> get props => [];
}

class IsInflow extends MatchesLogic {
  const IsInflow();

  @override
  bool call(TransactionTestPayload t) {
    return t.txn.isInflow;
  }

  @override
  List<Object?> get props => [];
}

class IsExpense extends MatchesLogic {
  const IsExpense();

  @override
  bool call(TransactionTestPayload t) {
    return t.txn.isExpense;
  }

  @override
  List<Object?> get props => [];
}

class IsOutflow extends MatchesLogic {
  const IsOutflow();

  @override
  bool call(TransactionTestPayload t) {
    return t.txn.isOutflow;
  }

  @override
  List<Object?> get props => [];
}
