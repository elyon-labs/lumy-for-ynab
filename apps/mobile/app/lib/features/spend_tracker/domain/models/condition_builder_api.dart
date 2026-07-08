import 'package:blackbird/blackbird.dart';
import 'transaction_conditions.dart';

typedef RootTransactionConditionDraft =
    NestedCondition<TransactionTestPayload, TransactionTestDraft>;

sealed class TransactionTestDraft extends Test<TransactionTestPayload> {
  const TransactionTestDraft();

  @override
  bool call(TransactionTestPayload t) {
    // These tests aren't intended to be called directly.
    throw UnimplementedError();
  }
}

/// A [TransactionTest] that checks the payload against a specified value.
sealed class MatchesValueDraft<T> extends TransactionTestDraft {
  const MatchesValueDraft(this.value);
  final T? value;

  @override
  List<Object?> get props => [value];
}

/// A [TransactionTest] that checks the payload against some arbitrary logic.
sealed class MatchesLogicDraft extends TransactionTestDraft {
  const MatchesLogicDraft();
}

class HasFlagColorDraft extends MatchesValueDraft<String> {
  const HasFlagColorDraft([super.value]);
}

class HasPayeeIdDraft extends MatchesValueDraft<String> {
  const HasPayeeIdDraft([super.value]);
}

class HasCategoryIdDraft extends MatchesValueDraft<String> {
  const HasCategoryIdDraft([super.value]);
}

class HasCategoryGroupIdDraft extends MatchesValueDraft<String> {
  const HasCategoryGroupIdDraft([super.value]);
}

class HasAccountIdDraft extends MatchesValueDraft<String> {
  const HasAccountIdDraft([super.value]);
}

class ContainsMemoKeywordDraft extends MatchesValueDraft<String> {
  const ContainsMemoKeywordDraft([super.value]);
}

class IsIncomeDraft extends MatchesLogicDraft {
  const IsIncomeDraft();

  @override
  List<Object?> get props => [];
}

class IsInflowDraft extends MatchesLogicDraft {
  const IsInflowDraft();

  @override
  List<Object?> get props => [];
}

class IsExpenseDraft extends MatchesLogicDraft {
  const IsExpenseDraft();

  @override
  List<Object?> get props => [];
}

class IsOutflowDraft extends MatchesLogicDraft {
  const IsOutflowDraft();

  @override
  List<Object?> get props => [];
}

extension NestedTransactionConditionX on NestedCondition<TransactionTestPayload, TransactionTest> {
  /// Converts a [TransactionCondition] to a [RootTransactionConditionDraft] for
  /// use in the condition builder.
  RootTransactionConditionDraft toDraft() {
    return switch (this) {
      And(:final conditions) => And<TransactionTestPayload, TransactionTestDraft>([
        ...conditions.whereType<NestedCondition<TransactionTestPayload, TransactionTest>>().map(
          (e) => e.toDraft(),
        ),
        ...conditions.whereType<TestCondition<TransactionTestPayload, TransactionTest>>().map(
          (e) => e.toDraft(),
        ),
      ]),
      Or(:final conditions) => Or<TransactionTestPayload, TransactionTestDraft>([
        ...conditions.whereType<NestedCondition<TransactionTestPayload, TransactionTest>>().map(
          (e) => e.toDraft(),
        ),
        ...conditions.whereType<TestCondition<TransactionTestPayload, TransactionTest>>().map(
          (e) => e.toDraft(),
        ),
      ]),
    };
  }
}

extension RootTransactionConditionDraftX on RootTransactionConditionDraft {
  TransactionCondition finalize() {
    final $value = this;
    return switch ($value) {
      And(:final conditions) => And(<Condition<TransactionTestPayload, TransactionTest>>[
        ...conditions
            .whereType<NestedCondition<TransactionTestPayload, TransactionTestDraft>>()
            .map((e) => e.finalize()),
        ...conditions.whereType<TestCondition<TransactionTestPayload, TransactionTestDraft>>().map(
          (e) => e.finalize(),
        ),
      ]),
      Or(:final conditions) => Or(<Condition<TransactionTestPayload, TransactionTest>>[
        ...conditions
            .whereType<NestedCondition<TransactionTestPayload, TransactionTestDraft>>()
            .map((e) => e.finalize()),
        ...conditions.whereType<TestCondition<TransactionTestPayload, TransactionTestDraft>>().map(
          (e) => e.finalize(),
        ),
      ]),
    };
  }
}

extension TransactionConditionX on Condition<TransactionTestPayload, TransactionTestDraft> {
  bool allTestDraftsAreValid() {
    return switch (this) {
      IsTrue(:final test) => switch (test) {
        MatchesLogicDraft() => true,
        MatchesValueDraft(:final value) => value != null,
      },
      IsNotTrue(:final test) => switch (test) {
        MatchesLogicDraft() => true,
        MatchesValueDraft(:final value) => value != null,
      },
      NestedCondition<TransactionTestPayload, TransactionTestDraft>(:final conditions) => () {
        return conditions.every((c) => c.allTestDraftsAreValid());
      }(),
    };
  }
}

extension TransactionTestConditionX on TestCondition<TransactionTestPayload, TransactionTest> {
  /// Converts a [TestCondition] to another [TestCondition] where the [Test] is
  /// a [TransactionTestDraft].
  TestCondition<TransactionTestPayload, TransactionTestDraft> toDraft() {
    return switch (this) {
      IsTrue(:final test) => IsTrue(test.toDraft()),
      IsNotTrue(:final test) => IsNotTrue(test.toDraft()),
    };
  }
}

extension TransactionTestX on TransactionTest {
  /// Converts a [TransactionTest] to a [TransactionTestDraft] for use in the condition builder.
  TransactionTestDraft toDraft() {
    return switch (this) {
      HasFlagColor(:final value) => HasFlagColorDraft(value),
      HasPayeeId(:final value) => HasPayeeIdDraft(value),
      HasCategoryId(:final value) => HasCategoryIdDraft(value),
      HasCategoryGroupId(:final value) => HasCategoryGroupIdDraft(value),
      HasAccountId(:final value) => HasAccountIdDraft(value),
      HasMemoKeyword(:final value) => ContainsMemoKeywordDraft(value),
      IsIncome() => const IsIncomeDraft(),
      IsInflow() => const IsInflowDraft(),
      IsExpense() => const IsExpenseDraft(),
      IsOutflow() => const IsOutflowDraft(),
    };
  }
}

extension TestConditionDraftX<T, R extends Test<T>> on TestConditionDraft<T, R> {
  String userFriendlyDescription(TransactionTestDraft test) {
    final isTrue = switch (this) {
      IsTrueDraft() => true,
      IsNotTrueDraft() => false,
    };
    return switch (test) {
      ContainsMemoKeywordDraft() => isTrue ? 'contains' : 'does not contain',
      _ => isTrue ? 'is' : 'is not',
    };
  }
}

extension on TestCondition<TransactionTestPayload, TransactionTestDraft> {
  TestCondition<TransactionTestPayload, TransactionTest> finalize() {
    return switch (this) {
      IsTrue(:final test) => IsTrue(test.finalize()),
      IsNotTrue(:final test) => IsNotTrue(test.finalize()),
    };
  }
}

extension TxnTestDraftX on TransactionTestDraft {
  TransactionTest finalize() {
    return switch (this) {
      HasFlagColorDraft(:final value) => HasFlagColor(value!),
      HasPayeeIdDraft(:final value) => HasPayeeId(value!),
      HasCategoryIdDraft(:final value) => HasCategoryId(value!),
      HasCategoryGroupIdDraft(:final value) => HasCategoryGroupId(value!),
      HasAccountIdDraft(:final value) => HasAccountId(value!),
      ContainsMemoKeywordDraft(:final value) => HasMemoKeyword(value!),
      IsIncomeDraft() => const IsIncome(),
      IsInflowDraft() => const IsInflow(),
      IsExpenseDraft() => const IsExpense(),
      IsOutflowDraft() => const IsOutflow(),
    };
  }

  String get userFriendlyDescription {
    return switch (this) {
      HasFlagColorDraft() => 'Flag color',
      HasPayeeIdDraft() => 'Payee',
      HasCategoryIdDraft() => 'Category',
      HasCategoryGroupIdDraft() => 'Category group',
      HasAccountIdDraft() => 'Account',
      ContainsMemoKeywordDraft() => 'Memo',
      IsIncomeDraft() => 'Income',
      IsInflowDraft() => 'Inflow',
      IsExpenseDraft() => 'Expense',
      IsOutflowDraft() => 'Outflow',
    };
  }
}
