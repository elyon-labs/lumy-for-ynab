import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';

class BudgetsRepository {
  BudgetsRepository({
    required Stream<Option<String>> Function() budgetId,
    required Stream<List<Budget>> Function() budgets,
  }) : _budgets = budgets,
       _budgetId = budgetId {
    _streamFromDatabase();
  }

  factory BudgetsRepository.create() {
    return BudgetsRepository(
      budgetId: () => inject<Settings>().watchSelectedBudgetId(),
      budgets: () => inject<LocalDatabase>().watchBudgets(),
    );
  }

  final ValueGetter<Stream<Option<String>>> _budgetId;
  final ValueGetter<Stream<List<Budget>>> _budgets;

  final _all = BehaviorSubject<List<Budget>>();

  void _streamFromDatabase() {
    _budgets().listen(_all.add);
  }

  ValueStream<Option<Budget>> watchSelected() {
    return Rx.combineLatest2(_budgetId(), _all, (selected, all) {
      return selected.mapOr(
        (bId) => Option.from(all.singleWhereOrNull((budget) => budget.id == bId)),
        const None<Budget>(),
      );
    }).shareValue();
  }

  ValueStream<Option<CurrencyFormat>> watchCurrencyFormat() {
    return watchSelected().map((selected) {
      return selected.mapOr(
        (budget) => Option.from(budget.currencyFormat),
        const None<CurrencyFormat>(),
      );
    }).shareValue();
  }

  ValueStream<List<Budget>> watch() {
    return _all;
  }

  Future<void> dispose() {
    return _all.close();
  }
}
