import 'package:blackbird/blackbird.dart';
import 'package:collection/collection.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../persistence/drift/local_database.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/spend_trackers_repository.dart';
import '../models/spend_tracker.dart';
import '../models/spend_tracker_order.dart';
import '../models/transaction_conditions.dart';

class WatchAllSpendTrackers {
  WatchAllSpendTrackers({
    required SpendTrackersRepository spendTrackersRepository,
    required Settings settings,
    required LocalDatabase database,
  }) : _settings = settings,
       _spendTrackersRepository = spendTrackersRepository,
       _database = database;

  factory WatchAllSpendTrackers.create() {
    return WatchAllSpendTrackers(
      spendTrackersRepository: inject(),
      settings: inject(),
      database: inject(),
    );
  }

  final SpendTrackersRepository _spendTrackersRepository;
  final Settings _settings;
  // TODO: Swap out for other use cases when we migrate
  final LocalDatabase _database;

  Stream<List<SpendTracker>> call() {
    final spendTrackersStream = _spendTrackersRepository.watch;
    final budgetIdStream = _settings.watchSelectedBudgetId();
    final spendTrackerOrderStream = _settings.watchSpendTrackersOrder();
    final orderStrategyStream = _settings.watchSpendTrackersOrderStrategy();

    // TODO: Swap out for other use cases when we migrate
    Stream<List<Category>> categories(String budgetId) =>
        _database.watchCategories(budgetId: budgetId);
    Stream<List<CategoryGroup>> categoryGroups(String budgetId) =>
        _database.watchCategoryGroups(budgetId: budgetId);
    Stream<List<Payee>> payees(String budgetId) => _database.watchPayees(budgetId: budgetId);

    return Rx.combineLatest4(
      budgetIdStream,
      spendTrackerOrderStream,
      orderStrategyStream,
      spendTrackersStream,
      (a, b, c, d) => (a, b, c, d),
    ).switchMap((value) async* {
      final (budgetId, spendTrackerOrder, orderStrategy, spendTrackers) = value;
      switch (budgetId) {
        case Some(:final some):
          final $categories = categories(some);
          final $categoryGroups = categoryGroups(some);
          final $payees = payees(some);

          yield* Rx.combineLatest3(
            $categories,
            $categoryGroups,
            $payees,
            (a, b, c) => (a, b, c, spendTrackerOrder, orderStrategy, spendTrackers),
          ).map((event) {
            final (
              categories,
              categoryGroups,
              payees,
              spendTrackerOrder,
              orderStrategy,
              spendTrackers,
            ) = event;

            final queries = spendTrackers.map((e) {
              // For trackers that are based on a single condition,
              // we can update the name if the underlying entity's name has changed
              final name = switch (e.condition) {
                IsNotTrue(:final test) || IsTrue(:final test) => () {
                  return switch (test) {
                    HasPayeeId(:final value) => payees.firstWhereOrNull((p) => p.id == value)?.name,
                    HasCategoryId(:final value) =>
                      categories.firstWhereOrNull((c) => c.id == value)?.name,
                    HasCategoryGroupId(:final value) =>
                      categoryGroups.firstWhereOrNull((g) => g.id == value)?.name,
                    _ => e.name,
                  };
                }(),
                // For complex conditions, we can't update the name. That's OK, because they
                // have custom names.
                _ => e.name,
              };
              return e.copyWith(name: name ?? e.name);
            }).toList();

            return switch (orderStrategy) {
              SpendTrackerOrderStrategy.manual =>
                queries.orderByPreference(spendTrackerOrder).toList(),
              SpendTrackerOrderStrategy.alphabetical => queries.orderAlphabetically().toList(),
              SpendTrackerOrderStrategy.created =>
                queries..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
            };
          });
        case None():
          yield* Stream.value(<SpendTracker>[]);
      }
    });
  }
}
