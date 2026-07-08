import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/presentation/charts/chart_constants.dart';
import '../../../common/presentation/design_system/_build_context.dart';

class CircularChart<T, D> extends StatelessWidget {
  const CircularChart({super.key, this.tooltipBuilder, required this.series});

  final ChartWidgetBuilder<dynamic, dynamic>? tooltipBuilder;
  final List<CircularSeries<T, D>> series;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      margin: EdgeInsets.zero,
      palette: context.bespokeColors.chartColors,
      tooltipBehavior: tooltipBuilder != null
          ? TooltipBehavior(
              canShowMarker: false,
              enable: true,
              color: context.bespokeColors.chartTooltip,
              textStyle: context.text.body.copyWith(color: context.colors.foreground),
              builder: tooltipBuilder,
            )
          : null,
      series: series,
    );
  }
}

extension CircularChartContextX on BuildContext {
  DoughnutSeries<T, D> createDoughnutSeries<T, D>({
    required ChartValueMapper<T, D> xValueMapper,
    required ChartValueMapper<T, num> yValueMapper,
    required List<T> source,
    ChartValueMapper<T, String>? dataLabelMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    bool showDataLabelSettings = true,
    String? innerRadius,
    String? radius,
    double? strokeWidth,
    ValueSetter<ChartPointDetails>? onPointTap,
  }) {
    return DoughnutSeries<T, D>(
      pointColorMapper: pointColorMapper,
      dataLabelSettings: dataLabelMapper != null
          ? DataLabelSettings(
              margin: const EdgeInsets.all(Sizes.unit / 2),
              isVisible: showDataLabelSettings,
              labelPosition: ChartDataLabelPosition.outside,
              borderRadius: Sizes.borderRadius / 2,
              useSeriesColor: true,
            )
          : const DataLabelSettings(),
      onPointTap: onPointTap,
      radius: radius ?? '60%',
      innerRadius: innerRadius ?? '70%',
      animationDuration: kChartAnimationDurationMs,
      strokeWidth: strokeWidth ?? 1,
      dataSource: source,
      strokeColor: colors.card,
      groupMode: CircularChartGroupMode.point,
      groupTo: source.length < 10 ? null : 10,
      dataLabelMapper: dataLabelMapper,
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
    );
  }
}
