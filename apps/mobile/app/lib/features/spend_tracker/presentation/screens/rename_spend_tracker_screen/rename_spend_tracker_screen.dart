import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../domain/models/spend_tracker.dart';
import '../../../domain/models/spend_tracker_data.dart';
import 'rename_spend_tracker_screen_cubit.dart';
import 'rename_spend_tracker_screen_state.dart';

class RenameSpendTrackerScreen extends StatelessWidget {
  const RenameSpendTrackerScreen({super.key, required this.spendTrackerId});
  final String spendTrackerId;

  static String buildRoute(String spendTrackerId) =>
      '/reports/spend_tracker_details/$spendTrackerId/rename';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RenameSpendTrackerScreenCubit.create(spendTrackerId: spendTrackerId),
      child: Scaffold(
        appBar: AppBar(title: const _Title()),
        body: const _Body(),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenameSpendTrackerScreenCubit, RenameSpendTrackerScreenState>(
      builder: (context, state) {
        return switch (state.spendTrackerData) {
          Loaded(:final value) => Text('Rename ${value.spendTracker.preferredName}'),
          Error() => const Text('Error'),
          _ => const Text('Loading...'),
        };
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenameSpendTrackerScreenCubit, RenameSpendTrackerScreenState>(
      builder: (context, state) {
        return switch (state.spendTrackerData) {
          Loaded(:final value) => _LoadedBody(spendTrackerData: value),
          Error() => const Center(child: Text('Error')),
          _ => const Center(child: CircularProgressIndicator.adaptive()),
        };
      },
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.spendTrackerData});

  final SpendTrackerData spendTrackerData;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController.fromValue(
      TextEditingValue(text: spendTrackerData.spendTracker.preferredName),
    );
    final updates = useListenable(controller);
    bool shouldShow(SpendTracker tracker) {
      return updates.text.isNotEmpty && updates.text != tracker.preferredName;
    }

    return HEdgePadding(
      child: Stack(
        children: [
          VLayout(
            children: [
              const VSpace(space: Sizes.unit * 2),
              OutlinedChild(
                child: HEdgePadding(
                  child: TextField(
                    autofocus: true,
                    controller: controller,
                    decoration: const InputDecoration(),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              scale: shouldShow(spendTrackerData.spendTracker) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.edgePadding),
                  child: HStretch(
                    child: PrimaryButton(
                      onPressed: !shouldShow(spendTrackerData.spendTracker)
                          ? null
                          : () async {
                              await context
                                  .read<RenameSpendTrackerScreenCubit>()
                                  .renameSpendTracker(controller.text);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                      child: Text(
                        !shouldShow(spendTrackerData.spendTracker) ? 'Save' : 'Rename',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
