import 'package:dart_foundation/dart_foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../domain/models/spend_tracker_data.dart';

class SpendTrackerTransactionsScreenState {
  SpendTrackerTransactionsScreenState({
    required this.spendTrackerId,
    required this.currencyFormat,
    required this.spendTrackerData,
  });

  factory SpendTrackerTransactionsScreenState.initial({required String spendTrackerId}) {
    return SpendTrackerTransactionsScreenState(
      spendTrackerId: spendTrackerId,
      currencyFormat: const None(),
      spendTrackerData: const Loading(),
    );
  }

  final String spendTrackerId;
  final Option<CurrencyFormat> currencyFormat;
  final Async<SpendTrackerData> spendTrackerData;
}
