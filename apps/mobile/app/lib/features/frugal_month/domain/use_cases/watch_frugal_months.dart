import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/frugal_months_repository.dart';
import '../models/frugal_month.dart';

class WatchFrugalMonths {
  WatchFrugalMonths({required FrugalMonthsRepository repository, required Settings settings})
    : _repository = repository,
      _settings = settings;

  factory WatchFrugalMonths.create() {
    return WatchFrugalMonths(repository: inject(), settings: inject());
  }

  final FrugalMonthsRepository _repository;
  final Settings _settings;

  ValueStream<List<FrugalMonth>> call() {
    final selectedBudgetIdStream = _settings.watchSelectedBudgetId();
    return selectedBudgetIdStream.switchMap((budgetId) {
      return switch (budgetId) {
        Some<String>(:final some) => _repository.watch.map(
          (months) => months.where((month) => month.budgetId == some).toList(),
        ),
        None<String>() => Stream.value(<FrugalMonth>[]),
      };
    }).shareValue();
  }
}
