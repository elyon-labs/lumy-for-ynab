import 'package:lumy/common/domain/budgets/budgets_repository.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/budget_factory.dart';

void main() {
  group('BudgetsRepository', () {
    group('selected', () {
      test('it emits None when no budgetId selected', () async {
        final subject = BudgetsRepository(
          budgetId: () => Stream.value(const None<String>()).shareValue(),
          budgets: () => Stream.value([BudgetFactory.build()]).shareValue(),
        );

        await expectLater(subject.watchSelected(), emits(const None<Budget>()));
      });

      test('it emits selected budget when Some selected', () async {
        final budget = BudgetFactory.build(id: 'abcd');

        final subject = BudgetsRepository(
          budgetId: () => Stream.value(const Some('abcd')).shareValue(),
          budgets: () => Stream.value([budget]).asBroadcastStream().shareValue(),
        );

        await expectLater(
          subject.watchSelected(),
          emitsThrough(predicate<Option<Budget>>((p0) => p0.isSome() && p0.unwrap() == budget)),
        );
      });
    });

    group('watch', () {
      test('it emits all budgets', () async {
        final subject = BudgetsRepository(
          budgetId: () => Stream.value(const None<String>()).shareValue(),
          budgets: () => Stream.value([BudgetFactory.build()]).shareValue(),
        );

        expect(
          subject.watch(),
          emitsThrough(
            predicate<List<Budget>>((budgets) {
              return budgets.isNotEmpty;
            }),
          ),
        );
      });
    });
  });
}
