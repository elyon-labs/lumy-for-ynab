import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../spend_tracker/presentation/flows/create_spend_tracker/screens/choose_spend_tracker_source_screen/choose_spend_tracker_source_screen.dart';
import 'reports_spend_tracker_details_screen.dart';

class ReportsChooseSpendTrackerSourceScreen extends StatelessWidget {
  const ReportsChooseSpendTrackerSourceScreen({super.key});

  static String route = '/reports/create_spend_tracker/source';

  @override
  Widget build(BuildContext context) {
    return ChooseSpendTrackerSourceScreen(
      onContinue: (id) {
        GoRouter.of(context).go(ReportsSpendTrackerDetailsScreen.buildRoute(spendTrackerId: id));
      },
    );
  }
}
