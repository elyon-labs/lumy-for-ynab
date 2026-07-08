import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../common/domain/calculations/days_buffer/fn.dart';
import '../../../../common/presentation/charts/chart_constants.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../utils/_local_date.dart';
import '../../templates/cartesian_chart_template.dart';
import '../../widgets/custom_tooltip.dart';
import '../../widgets/tooltip_row.dart';
import '../state/days_buffer_chart_data_cubit.dart';

class DaysBuffer extends HookWidget {
  const DaysBuffer({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DaysBufferChartDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _Chart(value: value),
      _ => const LoadingChart(),
    };
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.value});

  final DaysBufferResult value;

  @override
  Widget build(BuildContext context) {
    final source = value.buffers.entries.toList();
    return CartesianChart(
      showLegend: false,
      xAxisLabelFormatter: (details) {
        final month = source.elementAt(details.value.toInt()).key;
        return ChartAxisLabel(month.Myy(), TextStyle(color: context.colors.foreground));
      },
      trackballDisplayMode: TrackballDisplayMode.floatAllPoints,
      trackballBuilder: (context, details) {
        final p = source.elementAt(details.pointIndex!);
        final spend = p.value;
        final value = spend == null ? 'Infinite' : '${spend.floor()} days';
        final date = p.key;
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date.MMMyyyy(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TooltipRow(color: context.bespokeColors.chartOne, text: value),
            ],
          ),
        );
      },
      series: <XyDataSeries<MapEntry<LocalDate, double?>, LocalDate>>[
        ColumnSeries(
          animationDuration: kChartAnimationDurationMs,
          name: 'Buffer',
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.borderRadius),
            topRight: Radius.circular(Sizes.borderRadius),
          ),
          dataSource: source,
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          color: context.bespokeColors.chartOne,
        ),
      ],
    );
  }
}
