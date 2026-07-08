import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/presentation/design_system/_build_context.dart';

class CartesianChart<T, D> extends StatelessWidget {
  const CartesianChart({
    super.key,
    this.margin = EdgeInsets.zero,
    this.trackballDisplayMode = TrackballDisplayMode.groupAllPoints,
    this.trackballBuilder,
    this.showLegend = true,
    this.onMarkerRender,
    // X axis
    this.showXAxis = true,
    this.maximumXAxisLabels = 2,
    this.xAxisLabelFormatter,
    this.xAxisAutoScrollingDelta,
    this.xAxisLabelRotation = 0,
    // Y axis
    this.showYAxis = true,
    this.yAxisMaximum,
    this.yAxisMinimum,
    this.yAxisLabelFormatter,
    required this.series,
  });

  final EdgeInsets margin;
  final List<CartesianSeries<T, D>> series;
  final ChartTrackballBuilder<T>? trackballBuilder;
  final bool showLegend;
  final TrackballDisplayMode trackballDisplayMode;
  final ChartMarkerRenderCallback? onMarkerRender;

  // X axis
  final bool showXAxis;
  final ChartLabelFormatterCallback? xAxisLabelFormatter;
  final int maximumXAxisLabels;
  final int? xAxisAutoScrollingDelta;
  final int xAxisLabelRotation;

  // Y axis
  final bool showYAxis;
  final double? yAxisMaximum;
  final double? yAxisMinimum;
  final ChartLabelFormatterCallback? yAxisLabelFormatter;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // margin: margin,
      legend: Legend(
        isVisible: showLegend,
        position: LegendPosition.bottom,
        padding: Sizes.unit,
        itemPadding: Sizes.unit,
      ),
      onMarkerRender: onMarkerRender,
      primaryXAxis: CategoryAxis(
        maximumLabels: maximumXAxisLabels,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        isVisible: showXAxis,
        autoScrollingDelta: xAxisAutoScrollingDelta,
        axisLabelFormatter: xAxisLabelFormatter,
        labelRotation: xAxisLabelRotation,
      ),
      plotAreaBorderWidth: 0,
      primaryYAxis: NumericAxis(
        maximum: yAxisMaximum,
        minimum: yAxisMinimum,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: showYAxis
            ? const MajorGridLines(width: 1, dashArray: <double>[2, 2])
            : const MajorGridLines(width: 0),
        isVisible: showYAxis,
        anchorRangeToVisiblePoints: false,
        axisLabelFormatter: yAxisLabelFormatter,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
      trackballBehavior: trackballBuilder != null
          ? TrackballBehavior(
              hideDelay: 2000,
              tooltipSettings: InteractiveTooltip(
                connectorLineColor: context.bespokeColors.chartTooltip,
                borderColor: context.bespokeColors.chartTooltip,
                color: context.bespokeColors.chartTooltip,
              ),
              lineWidth: 2,
              lineColor: context.colors.primary,
              enable: true,
              tooltipDisplayMode: trackballDisplayMode,
              builder: trackballBuilder,
            )
          : null,
      series: series,
    );
  }
}
