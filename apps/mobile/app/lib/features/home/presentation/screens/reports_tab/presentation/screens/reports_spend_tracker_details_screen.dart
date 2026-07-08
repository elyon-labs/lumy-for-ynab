import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../spend_tracker/presentation/screens/spend_tracker_details_screen/spend_tracker_details_screen.dart';
import 'reports_spend_tracker_transactions_screen.dart';

class ReportsSpendTrackerDetailsScreen extends StatelessWidget {
  const ReportsSpendTrackerDetailsScreen({super.key, required this.spendTrackerId});

  final String spendTrackerId;

  static String buildRoute({required String spendTrackerId}) {
    return '/reports/spend_tracker_details/$spendTrackerId';
  }

  @override
  Widget build(BuildContext context) {
    return SpendTrackerDetailsScreen(
      spendTrackerId: spendTrackerId,
      onSeeTransactionsTapped: () => GoRouter.of(
        context,
      ).go(ReportsSpendTrackerTransactionsScreen.buildRoute(spendTrackerId: spendTrackerId)),
    );
  }
}
