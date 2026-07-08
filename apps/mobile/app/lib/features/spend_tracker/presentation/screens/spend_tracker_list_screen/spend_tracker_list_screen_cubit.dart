import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../utils/_cubit.dart';
import '../../../domain/use_cases/watch_all_spend_trackers.dart';
import 'spend_tracker_list_screen_state.dart';

class SpendTrackerListScreenCubit extends Cubit<SpendTrackerListScreenState> {
  SpendTrackerListScreenCubit({required WatchAllSpendTrackers watchAllSpendTrackers})
    : _watchAllSpendTrackers = watchAllSpendTrackers,
      super(SpendTrackerListScreenState.initial()) {
    fetch();
  }

  factory SpendTrackerListScreenCubit.create() {
    return SpendTrackerListScreenCubit(watchAllSpendTrackers: WatchAllSpendTrackers.create());
  }

  final WatchAllSpendTrackers _watchAllSpendTrackers;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _watchAllSpendTrackers().listen((spendTrackers) {
      safeEmit(SpendTrackerListScreenState(spendTrackers: spendTrackers));
    });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
