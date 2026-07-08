import 'package:design/design.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../common/presentation/orientation_aware.dart';
import '../../../../charts/all_charts.dart';
import '../../../../charts/models/chart.dart';
import '../../../../charts/models/chart_type.dart';
import '../chart_source_screen.dart';
import '../choose_chart_accounts_screen/choose_chart_accounts_screen.dart';
import '../share_chart_screen.dart';
import 'chart_details_screen_cubit.dart';
import 'chart_details_screen_state.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class ChartDetailsScreen extends HookWidget {
  const ChartDetailsScreen({super.key, required this.chartId});

  final String chartId;

  static String buildRoute(String chartId) {
    return '/reports/chart_details/$chartId';
  }

  @override
  Widget build(BuildContext context) {
    final chart = useRef<Chart>(allCharts.singleWhere((c) => c.id == chartId));
    final supportedTypes = chart.value.supportedTypes;
    final chartWidget = chart.value.build(context);
    final math = chart.value.buildMath(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(chart.value.title),
        actions: [
          IconButton(
            onPressed: () async {
              if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
                scaffoldKey.currentState?.closeEndDrawer();
              } else {
                scaffoldKey.currentState?.openEndDrawer();
              }
            },
            icon: const Icon(Ionicons.information_circle_outline),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: HEdgePadding(
            child: SingleChildScrollView(
              child: VLayout(
                children: [
                  Text(chart.value.title, style: context.text.title),
                  chart.value.buildLongDescription(context),
                  if (math != null) ...[
                    Text("How it's calculated", style: context.text.title),
                    math,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      body: OrientationAware(
        ifPortrait: (_) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: _List(
            chart: chart,
            supportedTypes: supportedTypes,
            chartId: chartId,
            chartWidget: chartWidget,
          ),
        ),
        ifLandscape: (_) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: Row(
            children: [
              Expanded(child: chartWidget),
              Expanded(
                child: _List(chart: chart, supportedTypes: supportedTypes, chartId: chartId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends HookWidget {
  const _List({
    required this.chart,
    required this.supportedTypes,
    required this.chartId,
    this.chartWidget,
  });

  final ObjectRef<Chart> chart;
  final List<ChartType> supportedTypes;
  final String chartId;
  final Widget? chartWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartDetailsScreenCubit.create(chart: chart.value),
      child: VLayout(
        children: [
          if (chartWidget == null) const VSpace(space: Sizes.unit * 2),
          if (chartWidget != null) chartWidget!,
          const VSpace(space: Sizes.unit * 2),
          ListSection(
            children: [
              ListRow(
                title: const Text('Select accounts for chart'),
                onTap: () => GoRouter.of(context).go(ChooseChartAccountsScreen.buildRoute(chartId)),
                leading: const Icon(Ionicons.card_outline),
              ),
              if (chart.value.showTransactionDataEntrypoint)
                ListRow(
                  title: const Text('View transaction data'),
                  leading: const Icon(Ionicons.search_outline),
                  onTap: () => GoRouter.of(context).go(ChartSourceScreen.buildRoute(chartId)),
                ),
              if (supportedTypes.isNotEmpty)
                BlocBuilder<ChartDetailsScreenCubit, ChartDetailsScreenState>(
                  builder: (context, state) {
                    return ListRow(
                      leading: const Icon(Ionicons.pie_chart_outline),
                      title: const Text('Chart type'),
                      trailing: Skeletonizer(
                        enabled: state.selectedChartType.isNone(),
                        child: Text(
                          state.selectedChartType.mapOr((ct) => ct.label, 'Loading'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () async {
                        await showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          useRootNavigator: true,
                          builder: (context) {
                            return _SelectChartTypeBottomSheet(chart: chart.value);
                          },
                        );
                      },
                    );
                  },
                ),
              if (!kIsWeb)
                ListRow(
                  title: const Text('Share chart with others'),
                  leading: const Icon(Ionicons.share_outline),
                  onTap: () => GoRouter.of(context).go(ShareChartScreen.buildRoute(chartId)),
                ),
            ],
          ),
          const SafeArea(child: VSpace()),
        ],
      ),
    );
  }
}

class _SelectChartTypeBottomSheet extends StatelessWidget {
  const _SelectChartTypeBottomSheet({required this.chart});

  final Chart chart;

  @override
  Widget build(BuildContext context) {
    final supportedTypes = chart.supportedTypes;
    return BlocProvider(
      create: (context) => ChartDetailsScreenCubit.create(chart: chart),
      child: BottomSheetWithHeader(
        title: const Text('Chart type'),
        builder: (context) {
          return BlocBuilder<ChartDetailsScreenCubit, ChartDetailsScreenState>(
            builder: (context, state) {
              final selectedType = state.selectedChartType;
              return VLayout(
                children: [
                  ...supportedTypes.map(
                    (t) => VLayout(
                      children: [
                        const VSpace(),
                        Material(
                          type: MaterialType.transparency,
                          child: ListRow(
                            externalPadding: const EdgeInsets.symmetric(
                              horizontal: Sizes.edgePadding,
                            ),
                            title: Text(t.name),
                            trailing: const Icon(
                              Ionicons.checkmark_circle_outline,
                            ).visible(selectedType.mapOr((ct) => t == ct, false)),
                            onTap: () {
                              context.read<ChartDetailsScreenCubit>().setChartType(t);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SafeArea(child: VSpace()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
