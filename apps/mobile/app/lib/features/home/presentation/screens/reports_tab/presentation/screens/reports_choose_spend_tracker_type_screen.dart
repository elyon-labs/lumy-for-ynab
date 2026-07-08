import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../spend_tracker/presentation/flows/create_spend_tracker/screens/choose_spend_tracker_type_screen.dart';
import 'reports_choose_spend_tracker_source_screen.dart';

class ReportsChooseSpendTrackerTypeScreen extends StatelessWidget {
  const ReportsChooseSpendTrackerTypeScreen({super.key});

  static String route = '/reports/create_spend_tracker';

  @override
  Widget build(BuildContext context) {
    return ChooseSpendTrackerTypeScreen(
      onContinue: () => GoRouter.of(context).go(ReportsChooseSpendTrackerSourceScreen.route),
    );
  }
}
