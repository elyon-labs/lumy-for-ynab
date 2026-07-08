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
import '../state/income_expense_chart_data_cubit.dart';

class IncomeExpenseBar extends HookWidget {
  const IncomeExpenseBar({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<IncomeExpenseChartDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _Chart(value: value),
      _ => const LoadingChart(),
    };
  }
}

class _Chart extends HookWidget {
  const _Chart({required this.value});

  final IncomeExpenseChartData value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final showTrendlines = context.watch<ChartSettingsCubit>().state.showTrendlines;
    final incomeSource = value.datesToIncome.entries.toList();
    final expenseSource = value.datesToExpense.entries.toList();
    final netSource = value.datesToNet.entries.toList();
    return CartesianChart(
      xAxisLabelFormatter: (details) {
        final month = incomeSource.elementAt(details.value.toInt()).key;
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
        final income = incomeSource.elementAt(info.currentPointIndices[0]);
        final expense = expenseSource.elementAt(info.currentPointIndices[1]);
        final net = netSource.elementAt(info.currentPointIndices[2]);
        final date = income.key;
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date.MMMyyyy(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TooltipRow(
                color: context.bespokeColors.chartOne,
                text: 'Income: ${income.value.format(currencyFormat)}',
              ),
              TooltipRow(
                color: context.bespokeColors.chartTwo,
                text: 'Expense: ${expense.value.format(currencyFormat)}',
              ),
              TooltipRow(
                color: context.bespokeColors.chartFour,
                text: 'Net: ${net.value.format(currencyFormat)}',
              ),
            ],
          ),
        );
      },
      series: <XyDataSeries<MapEntry<LocalDate, int>, LocalDate>>[
        ColumnSeries<MapEntry<LocalDate, int>, LocalDate>(
          name: 'Income',
          animationDuration: kChartAnimationDurationMs,
          dataSource: incomeSource,
          xValueMapper: (entry, _) => entry.key,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.borderRadius),
            topRight: Radius.circular(Sizes.borderRadius),
          ),
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartOne,
        ),
        ColumnSeries<MapEntry<LocalDate, int>, LocalDate>(
          name: 'Expense',
          animationDuration: kChartAnimationDurationMs,
          dataSource: expenseSource,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Sizes.borderRadius),
            bottomRight: Radius.circular(Sizes.borderRadius),
          ),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartTwo,
        ),
        SplineSeries(
          splineType: SplineType.cardinal,
          cardinalSplineTension: 0.25,
          name: 'Net',
          animationDuration: kChartAnimationDurationMs,
          xValueMapper: (entry, _) => entry.key,
          color: context.bespokeColors.chartFour,
          markerSettings: MarkerSettings(
            isVisible: netSource.length == 1,
            color: context.bespokeColors.chartFour,
          ),
          trendlines: [
            if (netSource.length > 1 && showTrendlines)
              Trendline(
                color: context.bespokeColors.chartFour,
                isVisibleInLegend: false,
                dashArray: <double>[5, 5],
              ),
          ],
          dataSource: netSource,
          yValueMapper: (entry, index) => entry.value,
        ),
      ],
    );
  }
}
