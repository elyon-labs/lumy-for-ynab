import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../utils/_cubit.dart';
import '../../../domain/use_cases/watch_spend_tracker_data.dart';
import 'spend_tracker_transactions_screen_state.dart';

class SpendTrackerTransactionsScreenCubit extends Cubit<SpendTrackerTransactionsScreenState> {
  SpendTrackerTransactionsScreenCubit({
    required String spendTrackerId,
    required WatchSpendTrackerData watchSpendTrackerData,
    required BudgetsRepository budgetsRepo,
  }) : _budgetsRepository = budgetsRepo,
       _spendTrackerId = spendTrackerId,
       _watchSpendTrackerData = watchSpendTrackerData,
       super(SpendTrackerTransactionsScreenState.initial(spendTrackerId: spendTrackerId)) {
    fetch();
  }

  factory SpendTrackerTransactionsScreenCubit.create({required String spendTrackerId}) {
    return SpendTrackerTransactionsScreenCubit(
      spendTrackerId: spendTrackerId,
      watchSpendTrackerData: WatchSpendTrackerData.create(),
      budgetsRepo: inject(),
    );
  }

  final String _spendTrackerId;
  final WatchSpendTrackerData _watchSpendTrackerData;
  final BudgetsRepository _budgetsRepository;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _budgetsRepository.watchCurrencyFormat(),
          _watchSpendTrackerData(_spendTrackerId),
          (a, b) => (a, b),
        ).listen((event) {
          final (currencyFormat, spendTrackerData) = event;
          safeEmit(
            SpendTrackerTransactionsScreenState(
              spendTrackerId: _spendTrackerId,
              currencyFormat: currencyFormat,
              spendTrackerData: Loaded(spendTrackerData),
            ),
          );
        });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
