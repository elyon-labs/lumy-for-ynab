import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_spend_trackers_list_screen.dart';

class AddFirstSpendTrackerRow extends StatelessWidget {
  const AddFirstSpendTrackerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListRow(
      leading: const Icon(Ionicons.analytics_outline),
      title: const Text('Simple spend tracking'),
      subtitle: const Text('Track spending from your pocket'),
      onTap: () => GoRouter.of(context).go(ReportsSpendTrackerListScreen.route),
    );
  }
}
