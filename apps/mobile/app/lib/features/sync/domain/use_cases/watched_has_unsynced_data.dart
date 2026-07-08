import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../persistence/drift/local_database.dart';
import '../../../../persistence/settings.dart';

class WatchHasUnsyncedData {
  WatchHasUnsyncedData({required LocalDatabase localDatabase, required Settings settings})
    : _localDatabase = localDatabase,
      _settings = settings;

  factory WatchHasUnsyncedData.create() {
    return WatchHasUnsyncedData(localDatabase: inject(), settings: inject());
  }

  final LocalDatabase _localDatabase;
  final Settings _settings;

  Stream<bool> call() {
    return Rx.combineLatest4(
      _localDatabase.watchHasAnyCategoryViews(),
      _localDatabase.watchHasAnyFrugalMonths(),
      _localDatabase.watchHasAnyQueriedSpendTrackers(),
      _settings.watchHasAnyTransactionTemplates(),
      (hasCategoryViews, hasFrugalMonths, hasSpendTrackers, hasTransactionTemplates) =>
          hasCategoryViews || hasFrugalMonths || hasSpendTrackers || hasTransactionTemplates,
    ).distinct();
  }
}
