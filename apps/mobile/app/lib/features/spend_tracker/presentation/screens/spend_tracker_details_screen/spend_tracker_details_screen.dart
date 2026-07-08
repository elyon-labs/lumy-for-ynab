import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../common/presentation/charts/chart_constants.dart';
import '../../../../../common/presentation/currency.dart';
import '../../../../../common/presentation/design_system/_build_context.dart';
import '../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../common/presentation/markdown.dart';
import '../../../../../utils/_local_date.dart';
import '../../../../charts/templates/cartesian_chart_template.dart';
import '../../../../charts/widgets/custom_tooltip.dart';
import '../../../../charts/widgets/tooltip_row.dart';
import '../../../domain/models/spend_tracker.dart';
import '../../../domain/models/spend_tracker_data.dart';
import 'spend_tracker_details_screen_cubit.dart';
import 'widgets/edit_spend_tracker_options_button.dart';

class SpendTrackerDetailsScreenState {
  SpendTrackerDetailsScreenState({
    required this.spendTrackerId,
    required this.data,
    required this.currencyFormat,
    required this.showTrendlines,
  });

  final String spendTrackerId;
  final SpendTrackerData data;
  final Option<CurrencyFormat> currencyFormat;
  final bool showTrendlines;
}

class SpendTrackerDetailsScreen extends StatelessWidget {
  const SpendTrackerDetailsScreen({
    super.key,
    required this.spendTrackerId,
    required this.onSeeTransactionsTapped,
  });

  final String spendTrackerId;
  final VoidCallback onSeeTransactionsTapped;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpendTrackerDetailsScreenCubit.create(spendTrackerId: spendTrackerId),
      child: BlocBuilder<SpendTrackerDetailsScreenCubit, Async<SpendTrackerDetailsScreenState>>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const _Title(),
              actions: switch (state) {
                Loaded(:final value) => [
                  EditSpendTrackerOptionsButton(
                    spendTrackerId: value.data.spendTracker.id,
                    isAdvanced: value.data.spendTracker.isAdvanced,
                  ),
                ],
                _ => [],
              },
            ),
            body: _Body(onSeeTransactionsTapped: onSeeTransactionsTapped),
          );
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendTrackerDetailsScreenCubit, Async<SpendTrackerDetailsScreenState>>(
      builder: (context, state) {
        return switch (state) {
          Loaded(:final value) => Text(value.data.spendTracker.preferredName),
          Error() => const Text('Error'),
          _ => const Text('Loading...'),
        };
      },
    );
  }
}

class _Body extends HookWidget {
  const _Body({required this.onSeeTransactionsTapped});

  final VoidCallback onSeeTransactionsTapped;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendTrackerDetailsScreenCubit, Async<SpendTrackerDetailsScreenState>>(
      builder: (context, state) {
        return switch (state) {
          Loaded(:final value) => _LoadedBody(
            state: value,
            onSeeTransactionsTapped: onSeeTransactionsTapped,
          ),
          Error() => const Center(child: Text('Error')),
          _ => const Center(child: CircularProgressIndicator.adaptive()),
        };
      },
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state, required this.onSeeTransactionsTapped});

  final SpendTrackerDetailsScreenState state;
  final VoidCallback onSeeTransactionsTapped;

  @override
  Widget build(BuildContext context) {
    final source = state.data.monthsToSpend.entries.toList();
    final chart = CartesianChart(
      showLegend: false,
      xAxisLabelFormatter: (details) {
        final month = source.elementAt(details.value.toInt()).key;
        return ChartAxisLabel(month.Myy(), TextStyle(color: context.colors.foreground));
      },
      yAxisLabelFormatter: (details) {
        final axis = details.axis;
        final value = details.value.toInt();
        final formatted = value.formatForAxis(
          currencyFormat: state.currencyFormat,
          interval: axis.visibleInterval,
        );
        return ChartAxisLabel(formatted, TextStyle(color: context.colors.foreground));
      },
      trackballDisplayMode: TrackballDisplayMode.floatAllPoints,
      trackballBuilder: (context, details) {
        final p = source.elementAt(details.pointIndex!);
        final spend = p.value;
        final date = p.key;
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date.MMMyyyy(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TooltipRow(
                color: context.bespokeColors.chartOne,
                text: spend.format(state.currencyFormat),
              ),
            ],
          ),
        );
      },
      series: <XyDataSeries<MapEntry<LocalDate, int>, LocalDate>>[
        if (!source.every((e) => e.value == 0))
          SplineSeries<MapEntry<LocalDate, int>, LocalDate>(
            splineType: SplineType.cardinal,
            cardinalSplineTension: 0.25,
            width: 4,
            animationDuration: kChartAnimationDurationMs,
            markerSettings: MarkerSettings(
              isVisible: source.length == 1,
              color: context.bespokeColors.chartOne,
            ),
            trendlines: [
              if (source.length > 1 && state.showTrendlines)
                Trendline(
                  color: context.bespokeColors.chartOne,
                  isVisibleInLegend: false,
                  dashArray: <double>[5, 5],
                ),
            ],
            dataSource: source,
            xValueMapper: (entry, _) => entry.key,
            yValueMapper: (entry, _) => entry.value.abs(),
            color: context.bespokeColors.chartOne,
          ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
      child: VLayout(
        spacing: 0,
        children: [
          chart,
          if (state.data.description != null)
            Align(
              child: HEdgePadding(child: Markdown(data: state.data.description!)),
            ),
          const VSpace(space: Sizes.unit * 4),
          const HEdgePadding(child: SectionHeader('Highlights')),
          ListRow(
            title: const Text('Net amount'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.arrow_forward_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text(state.data.netTotal.format(state.currencyFormat)),
          ),
          ListRow(
            title: const Text('Percent income'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.pie_chart_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text('${(state.data.percentIncome * 100).toStringAsFixed(2)}%'),
          ),
          ListRow(
            title: const Text('Number of transactions'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.list_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text(state.data.transactionsCount.toString()),
          ),
          if (state.data.transactionsCount > 0)
            ListRow(
              title: const Text('See transactions'),
              leading: CircleAvatar(
                radius: Sizes.unit * 2,
                backgroundColor: context.colors.secondary,
                child: Icon(
                  Ionicons.receipt_outline,
                  color: context.colors.onSecondary,
                  size: Sizes.unit * 2,
                ),
              ),
              trailing: const Icon(
                Ionicons.chevron_forward_outline,
                size: Sizes.unit * 2.5,
              ).opacity(0.25),
              onTap: onSeeTransactionsTapped,
            ),
          const VSpace(space: Sizes.unit * 4),
          const HEdgePadding(child: SectionHeader('Weekly stats')),
          ListRow(
            title: const Text('Transactions per week'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.calendar_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text(state.data.transactionsPerWeek.toStringAsFixed(2)),
          ),
          ListRow(
            title: const Text('Weekly average'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.analytics_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text(state.data.averageWeeklySpend.format(state.currencyFormat)),
          ),
          const VSpace(space: Sizes.unit * 4),
          const HEdgePadding(child: SectionHeader('Monthly stats')),
          ListRow(
            title: const Text('Transactions per month'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.calendar_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text(state.data.transactionsPerMonth.toStringAsFixed(2)),
          ),
          ListRow(
            title: const Text('Monthly average'),
            leading: CircleAvatar(
              radius: Sizes.unit * 2,
              backgroundColor: context.colors.secondary,
              child: Icon(
                Ionicons.analytics_outline,
                color: context.colors.onSecondary,
                size: Sizes.unit * 2,
              ),
            ),
            trailing: Text(state.data.averageMonthlySpend.format(state.currencyFormat)),
          ),
          if (state.data.maxSpendForMonth != null)
            ListRow(
              title: const Text('Highest spend month'),
              leading: CircleAvatar(
                radius: Sizes.unit * 2,
                backgroundColor: context.colors.secondary,
                child: Icon(
                  Ionicons.arrow_up_outline,
                  color: context.colors.onSecondary,
                  size: Sizes.unit * 2,
                ),
              ),
              trailing: VLayout(
                spacing: 0,

                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    state.data.maxSpendForMonth!.month.MMMyyyy(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(state.data.maxSpendForMonth!.spend.format(state.currencyFormat)),
                ],
              ),
            ),
          if (state.data.minSpendForMonth != null)
            ListRow(
              title: const Text('Lowest spend month'),
              leading: CircleAvatar(
                radius: Sizes.unit * 2,
                backgroundColor: context.colors.secondary,
                child: Icon(
                  Ionicons.arrow_down_outline,
                  color: context.colors.onSecondary,
                  size: Sizes.unit * 2,
                ),
              ),
              trailing: VLayout(
                spacing: 0,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    state.data.minSpendForMonth!.month.MMMyyyy(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(state.data.minSpendForMonth!.spend.format(state.currencyFormat)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
