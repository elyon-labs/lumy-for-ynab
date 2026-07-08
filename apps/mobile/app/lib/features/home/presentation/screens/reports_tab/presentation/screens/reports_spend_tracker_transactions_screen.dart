import 'package:flutter/material.dart';
import '../../../../../../spend_tracker/presentation/screens/spend_tracker_transactions_screen/spend_tracker_transactions_screen.dart';

class ReportsSpendTrackerTransactionsScreen extends StatelessWidget {
  const ReportsSpendTrackerTransactionsScreen({super.key, required this.spendTrackerId});
  final String spendTrackerId;

  static String buildRoute({required String spendTrackerId}) {
    return '/reports/spend_tracker_details/$spendTrackerId/transactions';
  }

  @override
  Widget build(BuildContext context) {
    return SpendTrackerTransactionsScreen(spendTrackerId: spendTrackerId);
  }
}
