import 'package:dart_foundation/dart_foundation.dart';

import '../../../../../../../spend_tracker/domain/models/spend_tracker_data.dart';

class ReportsEditSpendTrackerQueryScreenState {
  ReportsEditSpendTrackerQueryScreenState({
    required this.spendTrackerId,
    required this.spendTrackerData,
  });

  factory ReportsEditSpendTrackerQueryScreenState.initial({required String spendTrackerId}) {
    return ReportsEditSpendTrackerQueryScreenState(
      spendTrackerId: spendTrackerId,
      spendTrackerData: const Loading(),
    );
  }

  final String spendTrackerId;
  final Async<SpendTrackerData> spendTrackerData;
}
