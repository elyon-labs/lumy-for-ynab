import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/transaction_templates_repository.dart';
import '../models/transaction_template.dart';

class WatchAllTemplates {
  WatchAllTemplates({
    required TransactionTemplatesRepository repository,
    required Settings settings,
  }) : _repository = repository,
       _settings = settings;

  factory WatchAllTemplates.create() {
    return WatchAllTemplates(repository: inject(), settings: inject());
  }

  final TransactionTemplatesRepository _repository;
  final Settings _settings;

  Stream<List<TransactionTemplate>> call() {
    final selectedBudgetIdStream = _settings.watchSelectedBudgetId();
    return selectedBudgetIdStream.switchMap((budgetId) {
      return switch (budgetId) {
        Some<String>(:final some) => _repository.watch.map(
          (templates) => templates.where((template) => template.budgetId == some).toList(),
        ),
        None<String>() => Stream.value(<TransactionTemplate>[]),
      };
    }).shareValue();
  }
}
