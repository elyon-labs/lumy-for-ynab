import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/domain/calculations/net_worth/fn.dart';
import '../../../../common/presentation/charts/chart_constants.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../utils/_local_date.dart';
import '../../templates/cartesian_chart_template.dart';
import '../../widgets/custom_tooltip.dart';
import '../../widgets/tooltip_row.dart';
import '../net_worth_data_cubit.dart';

class NetWorth extends HookWidget {
  const NetWorth({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NetWorthDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _Chart(value: value),
      _ => const LoadingChart(),
    };
  }
}

class _Chart extends HookWidget {
  const _Chart({required this.value});

  final NetWorthData value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final source = value.monthSummaries.entries.toList();
    return CartesianChart(
      xAxisLabelFormatter: (details) {
        final month = source.elementAt(details.value.toInt()).key;
        return ChartAxisLabel(month.Myy(), TextStyle(color: context.colors.foreground));
      },
      yAxisLabelFormatter: (details) {
        final axis = details.axis;
        final value = details.value.toInt();
        final formatted = value.formatForAxis(
          currencyFormat: currencyFormat,
          interval: axis.visibleInterval,
        );
        return ChartAxisLabel(formatted, TextStyle(color: context.colors.foreground));
      },
      trackballBuilder: (context, details) {
        final info = details.groupingModeInfo!;
        final point = source.elementAt(info.currentPointIndices[0]);
        final assetsAmount = point.value.assets;
        final liabilitiesAmount = point.value.liabilities;
        final netWorthAmount = point.value.netWorth;
        final date = point.key;
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date.MMMyyyy(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TooltipRow(
                color: context.bespokeColors.chartOne,
                text: 'Assets: ${assetsAmount.format(currencyFormat)}',
              ),
              TooltipRow(
                color: context.bespokeColors.chartTwo,
                text: 'Liabilities: ${liabilitiesAmount.format(currencyFormat)}',
              ),
              TooltipRow(
                color: context.bespokeColors.chartFour,
                text: 'Net worth: ${netWorthAmount.format(currencyFormat)}',
              ),
            ],
          ),
        );
      },
      series: <XyDataSeries<MapEntry<LocalDate, NetWorthSummary>, LocalDate>>[
        ColumnSeries<MapEntry<LocalDate, NetWorthSummary>, LocalDate>(
          animationDuration: kChartAnimationDurationMs,
          name: 'Assets',
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.borderRadius),
            topRight: Radius.circular(Sizes.borderRadius),
          ),
          dataSource: source,
          xValueMapper: (entry, index) => entry.key,
          yValueMapper: (entry, _) => entry.value.assets,
          color: context.bespokeColors.chartOne,
        ),
        ColumnSeries<MapEntry<LocalDate, NetWorthSummary>, LocalDate>(
          animationDuration: kChartAnimationDurationMs,
          name: 'Liabilities',
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.borderRadius),
            topRight: Radius.circular(Sizes.borderRadius),
          ),
          dataSource: source,
          xValueMapper: (entry, index) => entry.key,
          yValueMapper: (entry, _) => entry.value.liabilities.abs(),
          color: context.bespokeColors.chartTwo,
        ),
        SplineSeries<MapEntry<LocalDate, NetWorthSummary>, LocalDate>(
          animationDuration: kChartAnimationDurationMs,
          splineType: SplineType.cardinal,
          cardinalSplineTension: 0.25,
          name: 'Net worth',
          dataSource: source,
          markerSettings: MarkerSettings(
            isVisible: source.length == 1,
            color: context.bespokeColors.chartFour,
          ),
          xValueMapper: (entry, index) => entry.key,
          yValueMapper: (entry, _) => entry.value.netWorth,
          color: context.bespokeColors.chartFour,
        ),
      ],
    );
  }
}
