import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../spend_tracker/domain/use_cases/watch_all_spend_trackers.dart';
import 'spend_tracker_ordering_screen_state.dart';

class SpendTrackerOrderingScreenCubit extends Cubit<SpendTrackerOrderingScreenState> {
  SpendTrackerOrderingScreenCubit({
    required WatchAllSpendTrackers watchAllSpendTrackers,
    required Settings settings,
  }) : _settings = settings,
       _watchAllSpendTrackers = watchAllSpendTrackers,
       super(SpendTrackerOrderingScreenState.initial()) {
    fetch();
  }

  factory SpendTrackerOrderingScreenCubit.create() {
    return SpendTrackerOrderingScreenCubit(
      watchAllSpendTrackers: WatchAllSpendTrackers.create(),
      settings: inject(),
    );
  }

  final WatchAllSpendTrackers _watchAllSpendTrackers;
  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _watchAllSpendTrackers(),
          _settings.watchSpendTrackersOrderStrategy(),
          (a, b) => (a, b),
        ).listen((event) {
          final (spendTrackers, strategy) = event;
          safeEmit(
            SpendTrackerOrderingScreenState(
              spendTrackers: spendTrackers,
              strategy: strategy,
              isLoading: false,
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
