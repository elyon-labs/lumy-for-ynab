import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../domain/use_cases/delete_spend_tracker.dart';
import '../../../domain/use_cases/watch_spend_tracker_data.dart';
import 'spend_tracker_details_screen.dart';

class SpendTrackerDetailsScreenCubit extends Cubit<Async<SpendTrackerDetailsScreenState>> {
  SpendTrackerDetailsScreenCubit({
    required String spendTrackerId,
    required WatchSpendTrackerData watchSpendTrackerData,
    required DeleteSpendTracker deleteSpendTracker,
    required BudgetsRepository budgetsRepository,
    required Settings settings,
  }) : _settings = settings,
       _budgetRepository = budgetsRepository,
       _spendTrackerId = spendTrackerId,
       _watchSpendTrackerData = watchSpendTrackerData,
       _deleteSpendTracker = deleteSpendTracker,
       super(const Loading()) {
    fetch();
  }

  factory SpendTrackerDetailsScreenCubit.create({required String spendTrackerId}) {
    return SpendTrackerDetailsScreenCubit(
      spendTrackerId: spendTrackerId,

      watchSpendTrackerData: WatchSpendTrackerData.create(),
      deleteSpendTracker: DeleteSpendTracker.create(),
      budgetsRepository: inject(),
      settings: inject(),
    );
  }

  final String _spendTrackerId;
  final WatchSpendTrackerData _watchSpendTrackerData;
  final DeleteSpendTracker _deleteSpendTracker;
  final BudgetsRepository _budgetRepository;
  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final spendTrackerStream = _watchSpendTrackerData(_spendTrackerId);
    final currencyFormatStream = _budgetRepository.watchCurrencyFormat();
    final showTrendlinesStream = _settings.watchShowTrendlines();
    final sub =
        Rx.combineLatest3(
          spendTrackerStream,
          currencyFormatStream,
          showTrendlinesStream,
          (a, b, c) => (a, b, c),
        ).listen((event) {
          final (spendTracker, currencyFormat, showTrendlines) = event;
          safeEmit(
            Loaded(
              SpendTrackerDetailsScreenState(
                spendTrackerId: _spendTrackerId,
                data: spendTracker,
                currencyFormat: currencyFormat,
                showTrendlines: showTrendlines,
              ),
            ),
          );
        });
    _subs.add(sub);
  }

  Future<void> delete() async {
    await _deleteSpendTracker(_spendTrackerId);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
