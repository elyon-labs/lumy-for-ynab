import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../utils/_cubit.dart';
import '../../../domain/use_cases/rename_spend_tracker.dart';
import '../../../domain/use_cases/watch_spend_tracker_data.dart';
import 'rename_spend_tracker_screen_state.dart';

class RenameSpendTrackerScreenCubit extends Cubit<RenameSpendTrackerScreenState> {
  RenameSpendTrackerScreenCubit({
    required String spendTrackerId,
    required WatchSpendTrackerData watchSpendTrackerData,
    required RenameSpendTracker renameSpendTracker,
  }) : _spendTrackerId = spendTrackerId,
       _watchSpendTrackerData = watchSpendTrackerData,
       _renameSpendTracker = renameSpendTracker,
       super(RenameSpendTrackerScreenState.initial(spendTrackerId: spendTrackerId)) {
    fetch();
  }

  factory RenameSpendTrackerScreenCubit.create({required String spendTrackerId}) {
    return RenameSpendTrackerScreenCubit(
      spendTrackerId: spendTrackerId,
      watchSpendTrackerData: WatchSpendTrackerData.create(),
      renameSpendTracker: RenameSpendTracker.create(),
    );
  }

  final String _spendTrackerId;
  final WatchSpendTrackerData _watchSpendTrackerData;
  final RenameSpendTracker _renameSpendTracker;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _watchSpendTrackerData(_spendTrackerId).listen((spendTrackerData) {
      safeEmit(
        RenameSpendTrackerScreenState(
          spendTrackerId: _spendTrackerId,
          spendTrackerData: Loaded(spendTrackerData),
        ),
      );
    });
    _subs.add(sub);
  }

  Future<void> renameSpendTracker(String name) async {
    await _renameSpendTracker(_spendTrackerId, name: name);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
