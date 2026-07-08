import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/_color.dart';
import '../../../../common/presentation/charts/chart_constants.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../utils/_T.dart';
import '../../../../utils/_local_date.dart';
import '../../../charts/templates/cartesian_chart_template.dart';
import '../../../charts/widgets/custom_tooltip.dart';
import '../../../charts/widgets/tooltip_row.dart';
import '../../domain/models/frugal_month_data.dart';

class FrugalMonthChart extends HookWidget {
  const FrugalMonthChart({super.key, required this.frugalMonth});

  final FrugalMonthData frugalMonth;

  @override
  Widget build(BuildContext context) {
    final source = frugalMonth.cumulativeSpend.entries.toList();
    final projectedSpendSource = frugalMonth.projectedSpend.entries.toList();
    final currencyFormat = useCurrencyFormat();
    final limitSource = List.generate(
      frugalMonth.month.month.numDaysInMonth(),
      (index) => MapEntry(
        LocalDate(frugalMonth.month.month.year, frugalMonth.month.month.monthOfYear, index + 1),
        frugalMonth.month.targetAmount,
      ),
    );
    return CartesianChart(
      xAxisLabelFormatter: (details) {
        final date = source.elementAt(details.value.toInt()).key;
        return ChartAxisLabel(
          date.dayOfMonth.toString(),
          TextStyle(color: context.colors.foreground),
        );
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
      onMarkerRender: (args) {
        final isToday = args.pointIndex == today.dayOfMonth - 1;
        args.color = isToday ? context.bespokeColors.chartOne : Colors.transparent;
      },
      trackballBuilder: (context, details) {
        final info = details.groupingModeInfo!;
        final projectedPoint = projectedSpendSource.elementAt(info.currentPointIndices.first);
        final spentPoint = source.elementAt(info.currentPointIndices.second);
        final projectedAmount = projectedPoint.value;
        final spentAmount = spentPoint.value;
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TooltipRow(
                color: context.bespokeColors.chartThree,
                text: '${projectedAmount.format(currencyFormat)} projected',
              ),
              TooltipRow(
                color: context.bespokeColors.chartOne,
                text: '${spentAmount.format(currencyFormat)} spent',
              ),
            ],
          ),
        );
      },
      series: <XyDataSeries<MapEntry<LocalDate, int>, LocalDate>>[
        LineSeries<MapEntry<LocalDate, int>, LocalDate>(
          name: 'Projected',
          dashArray: const [5, 5],
          animationDuration: kChartAnimationDurationMs,
          enableTooltip: false,
          dataSource: projectedSpendSource.map((e) => MapEntry(e.key, e.value * -1)).toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartThree.withAlphaOf(0.5),
        ),
        StepLineSeries<MapEntry<LocalDate, int>, LocalDate>(
          name: 'Spent',
          width: 4,
          markerSettings: const MarkerSettings(
            isVisible: true,
            width: Sizes.unit * 1.25,
            height: Sizes.unit * 1.25,
            borderWidth: 0,
          ),
          dataSource: source,
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) {
            if (today.isAfter(entry.key) || today.isSameDayAs(entry.key)) {
              return entry.value * -1;
            }
            return null;
          },
          color: context.bespokeColors.chartOne,
        ),
        LineSeries<MapEntry<LocalDate, int>, LocalDate>(
          name: 'Limit',
          animationDuration: kChartAnimationDurationMs,
          enableTooltip: false,
          dataSource: limitSource,
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartTwo,
        ),
      ],
    );
  }
}
