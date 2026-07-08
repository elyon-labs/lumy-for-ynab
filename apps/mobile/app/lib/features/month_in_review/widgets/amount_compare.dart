import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/presentation/_int.dart';
import '../../../common/presentation/charts/chart_constants.dart';
import '../../../common/presentation/currency.dart';
import '../../../common/presentation/design_system/_build_context.dart';
import '../../charts/templates/cartesian_chart_template.dart';

class AmountCompare extends StatelessWidget {
  const AmountCompare({
    super.key,
    required this.comparison,
    required this.actual,
    required this.actualDate,
    this.isExpenses = false,
  });

  final int comparison;
  final int actual;
  final bool isExpenses;
  final LocalDate actualDate;

  @override
  Widget build(BuildContext context) {
    return CartesianChart(
      showYAxis: false,
      showLegend: false,
      yAxisMaximum: isExpenses
          // TECHNICALLY expenses *can* be positive already; we're assuming
          // they're not.
          ? [comparison.abs(), actual.abs()].max.toDouble() * 1.25
          : [comparison, actual].max.toDouble() * 1.25,
      xAxisLabelFormatter: (axisLabelRenderArgs) {
        final index = axisLabelRenderArgs.value.toInt();
        final label = index == 0 ? 'Average' : actualDate.monthOfYear.toMonthName();
        return ChartAxisLabel(label, TextStyle(color: context.colors.foreground));
      },
      series: <XyDataSeries<int, int>>[
        ColumnSeries(
          animationDuration: kChartAnimationDurationMs,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(Sizes.unit / 2),
                child: Text((data as int).format(context.watch<CurrencyFormatCubit>().state)),
              );
            },
          ),
          name: actualDate.monthOfYear.toMonthName(),
          dataSource: [comparison, actual],
          pointColorMapper: (datum, index) {
            return index == 0 ? context.colors.muted : context.bespokeColors.chartTwo;
          },
          width: 0.5,
          color: context.bespokeColors.chartTwo,
          xValueMapper: (v, i) => v,
          yValueMapper: (v, _) => isExpenses ? v * -1 : v,
        ),
      ],
    );
  }
}

class RangeValue<T> {
  RangeValue({
    required this.key,
    required this.value,
    required this.color,
    this.showOnRange = true,
    this.showInLegend = true,
  });

  final T key;
  final bool showOnRange;
  final bool showInLegend;
  final int value;
  final Color color;
}
