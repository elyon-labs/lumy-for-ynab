import 'package:dart_foundation/dart_foundation.dart';

import '../../../domain/models/spend_tracker_data.dart';

class RenameSpendTrackerScreenState {
  RenameSpendTrackerScreenState({required this.spendTrackerId, required this.spendTrackerData});

  factory RenameSpendTrackerScreenState.initial({required String spendTrackerId}) {
    return RenameSpendTrackerScreenState(
      spendTrackerId: spendTrackerId,
      spendTrackerData: const Loading(),
    );
  }

  final String spendTrackerId;
  final Async<SpendTrackerData> spendTrackerData;
}
