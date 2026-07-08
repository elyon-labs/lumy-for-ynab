import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../charts/models/chart.dart';

class ChartsSelectionScreenState {
  ChartsSelectionScreenState({required this.selectedCharts, required this.hiddenCharts});

  factory ChartsSelectionScreenState.initial() {
    return ChartsSelectionScreenState(selectedCharts: [], hiddenCharts: []);
  }

  final List<Chart> selectedCharts;
  final List<Chart> hiddenCharts;
}

class ChartsSelectionScreenCubit extends Cubit<Async<ChartsSelectionScreenState>> {
  ChartsSelectionScreenCubit({required this.settings}) : super(const Loading()) {
    fetch();
  }

  factory ChartsSelectionScreenCubit.create() {
    return ChartsSelectionScreenCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final hiddenCharts = settings.watchHiddenCharts();
    final selectedCharts = settings.watchSelectedCharts();
    final sub = Rx.combineLatest2(selectedCharts, hiddenCharts, (selected, hidden) {
      return ChartsSelectionScreenState(selectedCharts: selected, hiddenCharts: hidden);
    }).listen((value) => safeEmit(Loaded(value)));
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChartsSelectionScreen extends HookWidget {
  const ChartsSelectionScreen({super.key});

  static String route = '/settings/charts/selection';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartsSelectionScreenCubit.create(),
      child: BlocBuilder<ChartsSelectionScreenCubit, Async<ChartsSelectionScreenState>>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Charts')),
            body: switch (state) {
              Loaded(:final value) => _LoadedBody(
                selectedCharts: value.selectedCharts,
                unselectedCharts: value.hiddenCharts,
              ),
              _ => const Center(child: CircularProgressIndicator.adaptive()),
            },
          );
        },
      ),
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.selectedCharts, required this.unselectedCharts});

  final List<Chart> selectedCharts;
  final List<Chart> unselectedCharts;

  @override
  Widget build(BuildContext context) {
    final sorted = useState(selectedCharts);
    useEffect(() {
      sorted.value = selectedCharts;
      return null;
    }, [selectedCharts]);
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
      footer: Visibility(
        visible: unselectedCharts.isNotEmpty,
        child: SafeArea(
          child: VEdgePadding(
            padding: Sizes.unit / 2,
            child: ListRow(
              backgroundColor: Colors.transparent,
              title: Text(
                '${unselectedCharts.length} ${unselectedCharts.length == 1 ? 'chart' : 'charts'} hidden',
              ),
              subtitle: const Text('Tap to view'),
              leading: const Icon(Ionicons.information_circle).opacity(0.5),
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  showDragHandle: true,
                  builder: (context) {
                    return ArchiveBottomSheet(onChartSelected: $settings().unhideChart);
                  },
                );
              },
            ),
          ),
        ),
      ),
      // Removes extra whitespace when reordering
      proxyDecorator: (child, _, __) => child,
      children: [
        ...sorted.value.mapIndexed((index, chart) {
          return SafeArea(
            bottom: index == sorted.value.length - 1 && unselectedCharts.isEmpty,
            key: Key('${chart.id}@$index'),
            child: Material(
              type: MaterialType.transparency,
              child: VLayout(
                spacing: 0,
                children: [
                  ListRow(
                    title: Text(chart.title),
                    subtitle: chart.buildDescription(context),
                    trailing: IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () async {
                        await $settings().hideChart(chart);
                      },
                      icon: const Icon(Ionicons.eye_off).opacity(0.75),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
        }),
      ],
      onReorder: (oldIndex, newIndex) async {
        final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
        // Make a copy of the list so that reactive primitives notify their
        // listeners due to an object change
        final copy = List<Chart>.from(sorted.value);
        final movedItem = copy.removeAt(oldIndex);
        final newOrder = copy..insert(adjustedNewIndex, movedItem);
        sorted.value = newOrder;
        $settings().setSelectedCharts(newOrder);
      },
    );
  }
}

class ArchiveBottomSheet extends StatelessWidget {
  const ArchiveBottomSheet({super.key, required this.onChartSelected});
  final ValueSetter<Chart> onChartSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartsSelectionScreenCubit.create(),
      child: BottomSheetWithHeader(
        title: const Text('Hidden charts'),
        builder: (context) => Expanded(
          child: BlocBuilder<ChartsSelectionScreenCubit, Async<ChartsSelectionScreenState>>(
            builder: (context, state) {
              final unselectedCharts = state.mapOr((value) => value.hiddenCharts, <Chart>[]);
              final children = [...unselectedCharts].mapIndexed((index, chart) {
                void onTap() {
                  final shouldPop = unselectedCharts.length == 1;
                  onChartSelected(chart);
                  if (shouldPop) Navigator.of(context).pop();
                }

                return VEdgePadding(
                  padding: Sizes.unit / 2,
                  child: SafeArea(
                    bottom: index == unselectedCharts.length - 1,
                    child: ListRow(
                      title: Text(chart.title),
                      subtitle: chart.buildDescription(context),
                      trailing: IconButton(icon: const Icon(Ionicons.eye), onPressed: onTap),
                      onTap: onTap,
                    ),
                  ),
                );
              }).toList();

              return ListView(
                padding: const EdgeInsets.only(top: Sizes.edgePadding / 2),
                shrinkWrap: true,
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}
