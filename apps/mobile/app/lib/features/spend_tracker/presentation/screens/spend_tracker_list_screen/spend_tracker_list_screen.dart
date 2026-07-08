import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../common/presentation/design_system/list_row.dart';
import '../../../domain/models/spend_tracker.dart';
import 'spend_tracker_list_screen_cubit.dart';
import 'spend_tracker_list_screen_state.dart';

class SpendTrackersListScreen extends StatelessWidget {
  const SpendTrackersListScreen({
    super.key,
    required this.onAddSpendTrackerTapped,
    required this.onSpendTrackerTapped,
  });
  final VoidCallback onAddSpendTrackerTapped;
  final ValueSetter<String> onSpendTrackerTapped;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpendTrackerListScreenCubit.create(),
      child: BlocBuilder<SpendTrackerListScreenCubit, SpendTrackerListScreenState>(
        builder: (context, state) {
          return AppScreen(
            title: const Text('Spend Trackers'),
            actions: [
              IconButton(
                tooltip: 'Add',
                icon: const Icon(Ionicons.add_circle_outline),
                onPressed: onAddSpendTrackerTapped,
              ).visible(state.spendTrackers.isNotEmpty),
            ],
            child: _Body(
              state.spendTrackers,
              onAddSpendTrackerTapped: onAddSpendTrackerTapped,
              onSpendTrackerTapped: onSpendTrackerTapped,
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(
    this.spendTrackers, {
    required this.onAddSpendTrackerTapped,
    required this.onSpendTrackerTapped,
  });
  final List<SpendTracker> spendTrackers;
  final VoidCallback onAddSpendTrackerTapped;
  final ValueSetter<String> onSpendTrackerTapped;

  @override
  Widget build(BuildContext context) {
    if (spendTrackers.isEmpty) {
      return _EmptyBody(onAddSpendTrackerTapped: onAddSpendTrackerTapped);
    } else {
      return _ContentBody(spendTrackers: spendTrackers, onSpendTrackerTapped: onSpendTrackerTapped);
    }
  }
}

class _ContentBody extends StatelessWidget {
  const _ContentBody({required this.spendTrackers, required this.onSpendTrackerTapped});
  final ValueSetter<String> onSpendTrackerTapped;
  final List<SpendTracker> spendTrackers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: spendTrackers.length,
      itemBuilder: (context, index) {
        final spendTracker = spendTrackers[index];
        final isFirst = index == 0;
        final row = Padding(
          padding: const EdgeInsets.only(bottom: Sizes.unit),
          child: ListRow(
            title: Text(spendTracker.preferredName),
            // TODO: This should be dependent on the query itself. But since
            // users won't really see this AFAICT, it's fine for now.
            leading: const Icon(Ionicons.code_slash_outline),
            onTap: () => onSpendTrackerTapped(spendTracker.id),
          ),
        );
        return VLayout(
          spacing: 0,
          children: [
            if (isFirst) const VSpace(space: Sizes.unit * 2),
            row,
          ],
        );
      },
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.onAddSpendTrackerTapped});

  final VoidCallback onAddSpendTrackerTapped;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SingleChildScrollView(
        child: Center(
          child: VLayout(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding * 2),
                child: VLayout(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No spend trackers yet',
                      textAlign: TextAlign.center,
                      style: context.text.title,
                    ),
                    const Text(
                      'Create a spend tracker to monitor spending on a specific category, payee, or memo.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.unit * 6),
                child: SecondaryButton(
                  onPressed: onAddSpendTrackerTapped,
                  child: const Text('Start tracking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
