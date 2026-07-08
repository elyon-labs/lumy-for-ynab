import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/chart_constants.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../utils/_local_date.dart';
import '../../state/chart_settings_cubit.dart';
import '../../templates/cartesian_chart_template.dart';
import '../../widgets/custom_tooltip.dart';
import '../../widgets/tooltip_row.dart';
import '../smoothed_income_chart_data_cubit.dart';

class SmoothedIncome extends HookWidget {
  const SmoothedIncome({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SmoothedIncomeChartDataCubit>().state;
    final settings = context.watch<ChartSettingsCubit>().state;

    return switch (data) {
      Loaded(:final value) => _Chart(value: value, showTrendlines: settings.showTrendlines),
      _ => const LoadingChart(),
    };
  }
}

class _Chart extends HookWidget {
  const _Chart({required this.value, required this.showTrendlines});

  final SmoothedIncomeChartData value;
  final bool showTrendlines;

  @override
  Widget build(BuildContext context) {
    final source = value.datesToAvgNetIncome.entries.toList();
    final currencyFormat = useCurrencyFormat();
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
        final info = details.groupingModeInfo;
        final p = source.elementAt(info!.currentPointIndices.last);
        final date = p.key;
        final amount = p.value;
        final formattedAmount = amount.format(currencyFormat);
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date.MMMyyyy(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TooltipRow(color: context.bespokeColors.chartOne, text: '$formattedAmount avg'),
            ],
          ),
        );
      },
      series: <CartesianSeries<MapEntry<LocalDate, int>, LocalDate>>[
        LineSeries<MapEntry<LocalDate, int>, LocalDate>(
          name: 'Zero',
          animationDuration: kChartAnimationDurationMs,
          enableTooltip: false,
          dataSource: List.generate(
            source.length,
            (index) => MapEntry(source.elementAt(index).key, 0),
          ),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartTwo,
        ),
        SplineSeries<MapEntry<LocalDate, int>, LocalDate>(
          splineType: SplineType.cardinal,
          cardinalSplineTension: 0.25,
          name: 'Net income',
          animationDuration: kChartAnimationDurationMs,
          markerSettings: MarkerSettings(
            isVisible: source.length == 1,
            color: context.bespokeColors.chartOne,
          ),
          trendlines: [
            if (source.length > 1 && showTrendlines)
              Trendline(
                color: context.bespokeColors.chartOne,
                isVisibleInLegend: false,
                dashArray: <double>[5, 5],
              ),
          ],
          width: 4,
          dataSource: source,
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartOne,
        ),
      ],
    );
  }
}
