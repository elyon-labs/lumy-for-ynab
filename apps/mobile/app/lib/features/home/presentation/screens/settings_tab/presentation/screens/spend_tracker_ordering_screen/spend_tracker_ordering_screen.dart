import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../utils/_enum.dart';
import '../../../../../../../spend_tracker/domain/models/spend_tracker.dart';
import '../../../../../../../spend_tracker/domain/models/spend_tracker_order.dart';
import 'spend_tracker_ordering_screen_cubit.dart';
import 'spend_tracker_ordering_screen_state.dart';

class SpendTrackerOrderingScreen extends HookWidget {
  const SpendTrackerOrderingScreen({super.key});

  static String route = '/settings/spend_tracker_ordering';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpendTrackerOrderingScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Spend Trackers')),
        body: BlocBuilder<SpendTrackerOrderingScreenCubit, SpendTrackerOrderingScreenState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return _LoadedBody(spendTrackers: state.spendTrackers, currentStrategy: state.strategy);
          },
        ),
      ),
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.spendTrackers, required this.currentStrategy});

  final List<SpendTracker> spendTrackers;
  final SpendTrackerOrderStrategy currentStrategy;

  @override
  Widget build(BuildContext context) {
    final sorted = useState(spendTrackers);

    useEffect(() {
      sorted.value = spendTrackers;
      return;
    }, [spendTrackers]);

    return ReorderableListView(
      buildDefaultDragHandles: currentStrategy == SpendTrackerOrderStrategy.manual,
      header: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.unit),
        child: GestureDetector(
          onTap: () async {
            await $settings().setSpendTrackerOrderStrategy(
              currentStrategy.nextOf(SpendTrackerOrderStrategy.values),
            );
          },
          child: HEdgePadding(
            child: HLayout(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(currentStrategy.name.capitalize()),
                const Icon(Ionicons.albums_outline),
              ],
            ),
          ),
        ),
      ),
      // Removes extra whitespace when reordering
      proxyDecorator: (child, _, __) => child,
      children: [
        ...sorted.value.mapIndexed((index, tracker) {
          return SafeArea(
            key: Key('${tracker.id}@$index'),
            bottom: index == sorted.value.length - 1,
            child: VEdgePadding(
              padding: Sizes.unit / 2,
              child: Material(
                type: MaterialType.transparency,
                child: VLayout(
                  spacing: 0,
                  children: [
                    ListRow(
                      title: Text(tracker.preferredName),
                      trailing: const Icon(
                        Icons.drag_handle,
                      ).visible(currentStrategy == SpendTrackerOrderStrategy.manual),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
      onReorder: (int oldIndex, int newIndex) async {
        final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
        // Make a copy of the list so that reactive primitives notify their
        // listeners due to an object change
        final copy = List<SpendTracker>.from(sorted.value);
        final movedItem = copy.removeAt(oldIndex);
        final newOrder = copy..insert(adjustedNewIndex, movedItem);
        // TODO: Should we locally update?
        sorted.value = newOrder;
        await $settings().setSpendTrackerOrder(newOrder.map((e) => e.id).toList());
      },
    );
  }
}
