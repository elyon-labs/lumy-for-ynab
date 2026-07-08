import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/chart_constants.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../utils/_string.dart';
import '../../templates/cartesian_chart_template.dart';
import '../../widgets/custom_tooltip.dart';
import '../../widgets/tooltip_row.dart';
import '../state/spend_by_category_chart_data_cubit.dart';

class SpendByCategoryBar extends HookWidget {
  const SpendByCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SpendByCategoryChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => _Chart(value: value),
      _ => const LoadingChart(),
    };
  }
}

class _Chart extends HookWidget {
  const _Chart({required this.value});

  final SpendByCategoryData value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final source = value.categorySpendData.sortedBySpendDesc;

    return CartesianChart(
      showLegend: false,
      maximumXAxisLabels: 100,
      xAxisAutoScrollingDelta: 10,
      trackballDisplayMode: TrackballDisplayMode.floatAllPoints,
      xAxisLabelFormatter: (details) {
        // `value` is the index of the category in the list of categories
        final category = source.elementAt(details.value.toInt()).category;
        return ChartAxisLabel(
          category.name.safeSubstring(0, 1),
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
      trackballBuilder: (context, details) {
        final p = details.point!;
        final category = p.x as Category;
        final spend = p.y! as int;
        return CustomTooltip(
          child: VLayout(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TooltipRow(color: context.bespokeColors.chartOne, text: spend.format(currencyFormat)),
            ],
          ),
        );
      },
      series: <XyDataSeries<MapEntry<Category, int>, Category>>[
        ColumnSeries(
          animationDuration: kChartAnimationDurationMs,
          name: 'Category',
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Sizes.borderRadius),
            topRight: Radius.circular(Sizes.borderRadius),
          ),
          dataSource: source.map((entry) => MapEntry(entry.category, entry.spend)).toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value * -1,
          color: context.bespokeColors.chartOne,
        ),
      ],
    );
  }
}
