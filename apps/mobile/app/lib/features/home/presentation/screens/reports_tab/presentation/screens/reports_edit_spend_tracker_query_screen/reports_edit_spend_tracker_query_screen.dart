import 'package:blackbird/blackbird.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../spend_tracker/domain/models/transaction_conditions.dart';
import '../../../../../../../spend_tracker/presentation/flows/create_spend_tracker/widgets/condition_builder.dart';
import 'reports_edit_spend_tracker_query_screen_cubit.dart';
import 'reports_edit_spend_tracker_query_screen_state.dart';

class ReportsEditSpendTrackerQueryScreen extends StatelessWidget {
  const ReportsEditSpendTrackerQueryScreen({super.key, required this.spendTrackerId});

  final String spendTrackerId;

  static String buildRoute({required String spendTrackerId}) {
    return '/reports/spend_tracker_details/$spendTrackerId/edit_advanced_query';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReportsEditSpendTrackerQueryScreenCubit.create(spendTrackerId: spendTrackerId),
      child: Scaffold(
        body:
            BlocBuilder<
              ReportsEditSpendTrackerQueryScreenCubit,
              ReportsEditSpendTrackerQueryScreenState
            >(
              builder: (context, state) {
                return switch (state.spendTrackerData) {
                  Loaded(:final value) => ConditionBuilder(
                    onSave: (condition) async {
                      await context.read<ReportsEditSpendTrackerQueryScreenCubit>().update(
                        condition,
                      );
                      if (context.mounted) context.pop();
                    },
                    // Pre-validation should be done to ensure this is an advanced condition prior to showing
                    // this screen
                    initialCondition:
                        value.spendTracker.condition
                            as NestedCondition<TransactionTestPayload, TransactionTest>,
                  ),
                  Error() => const Center(child: Text('Error')),
                  _ => const Center(child: CircularProgressIndicator.adaptive()),
                };
              },
            ),
      ),
    );
  }
}
