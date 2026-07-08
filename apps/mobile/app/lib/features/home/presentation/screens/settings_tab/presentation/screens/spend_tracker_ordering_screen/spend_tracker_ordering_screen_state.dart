import '../../../../../../../spend_tracker/domain/models/spend_tracker.dart';
import '../../../../../../../spend_tracker/domain/models/spend_tracker_order.dart';

class SpendTrackerOrderingScreenState {
  SpendTrackerOrderingScreenState({
    required this.spendTrackers,
    required this.strategy,
    required this.isLoading,
  });

  factory SpendTrackerOrderingScreenState.initial() {
    return SpendTrackerOrderingScreenState(
      spendTrackers: [],
      strategy: SpendTrackerOrderStrategy.manual,
      isLoading: true,
    );
  }

  final List<SpendTracker> spendTrackers;
  final SpendTrackerOrderStrategy strategy;
  final bool isLoading;
}
