import '../../../domain/models/spend_tracker.dart';

class SpendTrackerListScreenState {
  SpendTrackerListScreenState({required this.spendTrackers});

  factory SpendTrackerListScreenState.initial() {
    return SpendTrackerListScreenState(spendTrackers: []);
  }

  final List<SpendTracker> spendTrackers;
}
