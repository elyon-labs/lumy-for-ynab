import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../spend_tracker/domain/models/transaction_conditions.dart';
import '../../../../../../../spend_tracker/domain/use_cases/update_spend_tracker.dart';
import '../../../../../../../spend_tracker/domain/use_cases/watch_spend_tracker_data.dart';
import 'reports_edit_spend_tracker_query_screen_state.dart';

class ReportsEditSpendTrackerQueryScreenCubit
    extends Cubit<ReportsEditSpendTrackerQueryScreenState> {
  ReportsEditSpendTrackerQueryScreenCubit({
    required String spendTrackerId,
    required WatchSpendTrackerData watchSpendTrackerData,
    required UpdateSpendTracker updateSpendTracker,
  }) : _spendTrackerId = spendTrackerId,
       _watchSpendTrackerData = watchSpendTrackerData,
       _updateSpendTracker = updateSpendTracker,
       super(ReportsEditSpendTrackerQueryScreenState.initial(spendTrackerId: spendTrackerId)) {
    fetch();
  }

  factory ReportsEditSpendTrackerQueryScreenCubit.create({required String spendTrackerId}) {
    return ReportsEditSpendTrackerQueryScreenCubit(
      spendTrackerId: spendTrackerId,
      watchSpendTrackerData: WatchSpendTrackerData.create(),
      updateSpendTracker: UpdateSpendTracker.create(),
    );
  }

  final String _spendTrackerId;
  final WatchSpendTrackerData _watchSpendTrackerData;
  final UpdateSpendTracker _updateSpendTracker;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _watchSpendTrackerData(_spendTrackerId).listen((spendTrackerData) {
      safeEmit(
        ReportsEditSpendTrackerQueryScreenState(
          spendTrackerId: _spendTrackerId,
          spendTrackerData: Loaded(spendTrackerData),
        ),
      );
    });
    _subs.add(sub);
  }

  Future<void> update(TransactionCondition condition) async {
    await _updateSpendTracker(_spendTrackerId, condition: condition);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
