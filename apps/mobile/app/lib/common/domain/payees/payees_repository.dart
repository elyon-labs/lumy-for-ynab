import 'package:flutter/foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../typedefs.dart';
import 'payees_view.dart';

class PayeesRepository {
  PayeesRepository({
    required BudgetDataWatcher<List<Payee>> payees,
    required ValueGetter<Stream<Option<String>>> budgetId,
  }) : _payees = payees,
       _budgetId = budgetId {
    _streamFromDatabase();
  }

  factory PayeesRepository.create() {
    return PayeesRepository(
      payees: (bId) => inject<LocalDatabase>().watchPayees(budgetId: bId),
      budgetId: () => inject<Settings>().watchSelectedBudgetId(),
    );
  }

  final ValueGetter<Stream<Option<String>>> _budgetId;
  final BudgetDataWatcher<List<Payee>> _payees;

  final _all = BehaviorSubject<List<Payee>>();

  void _streamFromDatabase() {
    _budgetId()
        .switchMap((budgetId) {
          switch (budgetId) {
            case Some<String>(:final some):
              return _payees(some);
            case None<String>():
              return Stream.value(List<Payee>.empty());
          }
        })
        .listen(_all.add);
  }

  Stream<List<Payee>> watch(PayeesView view) {
    return switch (view) {
      AllPayees() => _all,
    };
  }

  Future<void> dispose() async {
    await _all.close();
  }
}
