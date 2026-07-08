import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:oxidized/oxidized.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../common/presentation/_color.dart';
import '../../../common/presentation/charts/chart_constants.dart';
import '../../../common/presentation/currency.dart';
import '../../../common/presentation/design_system/_build_context.dart';
import '../../../utils/_local_date.dart';
import '../../charts/widgets/custom_tooltip.dart';
import '../../charts/widgets/tooltip_row.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key, required this.currencyFormat, required this.source});

  final Option<CurrencyFormat> currencyFormat;
  final List<MapEntry<LocalDate, int>> source;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      // TODO: Migrate to template
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        primaryXAxis: CategoryAxis(
          maximumLabels: 2,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          axisLabelFormatter: (details) {
            final month = source.elementAt(details.value.toInt()).key;
            return ChartAxisLabel(month.Myy(), TextStyle(color: context.colors.foreground));
          },
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          anchorRangeToVisiblePoints: false,
          axisLabelFormatter: (details) {
            final axis = details.axis;
            final value = details.value.toInt();
            final formatted = value.formatForAxis(
              currencyFormat: currencyFormat,
              interval: axis.visibleInterval,
            );
            return ChartAxisLabel(formatted, TextStyle(color: context.colors.foreground));
          },
        ),
        plotAreaBorderWidth: 0,
        trackballBehavior: TrackballBehavior(
          hideDelay: 2000,
          enable: true,
          activationMode: ActivationMode.singleTap,
          builder: (context, trackballDetails) {
            final point = trackballDetails.point;
            if (point == null) return const SizedBox.shrink();
            final x = point.x as int;
            final entry = source.elementAt(x);
            final date = entry.key;
            final value = entry.value;
            return CustomTooltip(
              child: VLayout(
                spacing: 0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(date.MMMyyyy(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  TooltipRow(
                    color: context.bespokeColors.chartOne,
                    text: value.format(currencyFormat),
                  ),
                ],
              ),
            );
          },
        ),
        series: <XyDataSeries<MapEntry<LocalDate, int?>, int>>[
          SplineAreaSeries(
            animationDuration: kChartAnimationDurationMs,
            dataSource: source,
            xValueMapper: (entry, index) => index,
            yValueMapper: (entry, _) => entry.value,
            borderColor: context.colors.primary,
            borderWidth: 3,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.bespokeColors.chartTwo.withAlphaOf(0.2),
                context.bespokeColors.chartTwo,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
