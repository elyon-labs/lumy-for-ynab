import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/colored_dot.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../templates/circular_chart_template.dart';
import '../state/spend_by_payee_chart_data_cubit.dart';

class SpendByPayeePie extends HookWidget {
  const SpendByPayeePie({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final data = context.watch<SpendByPayeeChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => _Chart(currencyFormat: currencyFormat, value: value),
      _ => const LoadingChart(),
    };
  }
}

const _maxObjects = 9;

class _Chart extends HookWidget {
  const _Chart({required this.currencyFormat, required this.value});

  final SpendByPayeeChartData value;
  final Option<CurrencyFormat> currencyFormat;

  @override
  Widget build(BuildContext context) {
    final source = value.payeeSpendData;
    final sorted = source.sortedBySpendAsc;
    final firstMaxObjects = sorted.take(_maxObjects);
    final others = sorted.skip(_maxObjects);
    final combinedOthers = others.length == 1
        ? others.single
        : OtherPayeesSpendData(
            spend: others.map((e) => e.spend).fold(0, (a, b) => a + b),
            percentOfTotalSpend: others.map((e) => e.percentOfTotalSpend).fold(0, (a, b) => a + b),
          );

    final data = [...firstMaxObjects.map((v) => v), if (others.isNotEmpty) combinedOthers];

    return VLayout(
      spacing: 0,
      children: [
        CircularChart(
          series: [
            context.createDoughnutSeries<PayeeSpendData, String>(
              pointColorMapper: (datum, index) {
                return context.bespokeColors.chartColors.elementAtOrNull(index) ??
                    context.bespokeColors.chartCompare;
              },
              innerRadius: '80%',
              radius: '90%',
              strokeWidth: 0,
              xValueMapper: (entry, _) => switch (entry) {
                SinglePayeeSpendData(:final payee) => payee.mapOr((p) => p.name, 'No Payee'),
                OtherPayeesSpendData() => 'Others',
              },
              yValueMapper: (entry, _) => entry.spend.abs(),
              source: data,
            ),
          ],
        ),
        Builder(
          builder: (context) {
            final length = data.length;
            return VLayout(
              spacing: 0,
              children: [
                for (int i = 0; i < length; i++) ...[
                  Builder(
                    builder: (context) {
                      final entry = data.elementAt(i);
                      return ListRow(
                        externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                        leading: ColoredDot(
                          color: context.bespokeColors.chartColors[i],
                          size: Sizes.unit * 2,
                        ),
                        onTap: () {},
                        visualDensity: VisualDensity.compact,
                        title: Text(entry.name, overflow: TextOverflow.ellipsis),
                        trailing: Text(
                          '${entry.spend.abs().format(currencyFormat)} (${entry.percentOfTotalSpend.toStringAsFixed(2)}%)',
                        ),
                      );
                    },
                  ),
                  if (i < length - 1) const Divider(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
