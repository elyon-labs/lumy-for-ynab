import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../spend_tracker/presentation/flows/create_spend_tracker/state/create_spend_tracker_cubit.dart';
import '../../../../../../spend_tracker/presentation/screens/spend_tracker_list_screen/spend_tracker_list_screen.dart';
import 'reports_spend_tracker_details_screen.dart';

class ReportsSpendTrackerListScreen extends StatelessWidget {
  const ReportsSpendTrackerListScreen({super.key});

  static String route = '/reports/spend_trackers';

  @override
  Widget build(BuildContext context) {
    return SpendTrackersListScreen(
      onAddSpendTrackerTapped: () {
        final route = context.read<CreateSpendTrackerCubit>().initializeFlow();
        GoRouter.of(context).go(route);
      },
      onSpendTrackerTapped: (id) {
        GoRouter.of(context).go(ReportsSpendTrackerDetailsScreen.buildRoute(spendTrackerId: id));
      },
    );
  }
}
