import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_local_date.dart';
import '../../../ynab_api/_month.dart';
import '../typedefs.dart';

class MonthsRepository {
  MonthsRepository({
    required ValueGetter<Stream<Option<String>>> budgetId,
    required BudgetDataWatcher<List<Month>> months,
  }) : _months = months,
       _budgetId = budgetId {
    _streamFromDatabase();
  }

  factory MonthsRepository.create() {
    return MonthsRepository(
      budgetId: inject<Settings>().watchSelectedBudgetId,
      months: (bId) => inject<LocalDatabase>().watchMonths(budgetId: bId),
    );
  }

  final ValueGetter<Stream<Option<String>>> _budgetId;
  final BudgetDataWatcher<List<Month>> _months;

  final _all = BehaviorSubject<List<Month>>();

  void _streamFromDatabase() {
    _budgetId()
        .switchMap((budgetId) {
          switch (budgetId) {
            case Some<String>(:final some):
              return _months(some);
            case None<String>():
              return Stream.value(List<Month>.empty());
          }
        })
        .listen(_all.add);
  }

  ValueStream<List<Month>> watchAllMonths() {
    return _all;
  }

  ValueStream<Month?> watchCurrentMonth() {
    return watchAllMonths().map((months) {
      return months.firstWhereOrNull((m) => m.localDate.isSameMonthAs(today));
    }).shareValue();
  }

  Future<void> dispose() async {
    await _all.close();
  }
}
