import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/colored_dot.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../state/targets_health_report_chart_data_cubit.dart';

class TargetsHealthReport extends StatelessWidget {
  const TargetsHealthReport({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<TargetsHealthReportChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => _Chart(value: value),
      _ => const LoadingChart(),
    };
  }
}

class _Chart extends HookWidget {
  const _Chart({required this.value});

  final TargetsHealthReportChartData value;

  @override
  Widget build(BuildContext context) {
    final showAll = useState(false);
    return VLayout(
      children: [
        HEdgePadding(
          child: HLayout(
            children: [
              ColoredDot(
                size: Sizes.unit * 2,
                color: switch (value.status) {
                  TargetsHealthStatus.healthy => context.colors.good,
                  TargetsHealthStatus.needsAttention => context.colors.warning,
                },
              ),
              Text(switch (value.status) {
                TargetsHealthStatus.healthy => 'Healthy',
                TargetsHealthStatus.needsAttention => 'Needs attention',
              }, style: context.text.title),
            ],
          ),
        ),
        if (value.status == TargetsHealthStatus.needsAttention)
          const HEdgePadding(
            child: Text('One or more categories have spending that exceeds their target.'),
          ),
        const Divider(),
        for (final target in value.categoryTargets.take(5)) _TargetRow(target: target),
        if (value.categoryTargets.length > 5)
          VLayout(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!showAll.value) ...[
                const VSpace(),
                HEdgePadding(
                  child: SecondaryButton(
                    onPressed: () => showAll.value = true,
                    child: const Text('Show all'),
                  ),
                ),
                const VSpace(),
              ],
              if (showAll.value)
                for (final target in value.categoryTargets.skip(5)) _TargetRow(target: target),
              if (showAll.value) ...[
                const VSpace(),
                HEdgePadding(
                  child: SecondaryButton(
                    onPressed: () => showAll.value = false,
                    child: const Text('Show less'),
                  ),
                ),
                const VSpace(),
              ],
            ],
          ),
      ],
    );
  }
}

class _TargetRow extends HookWidget {
  const _TargetRow({required this.target});

  final CategoryTargetInformation target;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    return VLayout(
      spacing: 0,
      children: [
        HEdgePadding(
          child: VLayout(
            spacing: 0,
            children: [
              const VSpace(),
              HLayout(
                spacing: 0,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      target.category.name,
                      style: context.text.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${target.monthlyAmountBudgeted.format(currencyFormat)}/mo target',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const VSpace(),
              LayoutBuilder(
                builder: (context, constraints) {
                  final spent = target.monthlyAmountSpent.abs();
                  final budgeted = target.monthlyAmountBudgeted;
                  final longerValue = [spent, budgeted].max;
                  final shorterValue = [spent, budgeted].min;
                  final percentage = shorterValue / longerValue;
                  final isInGreen = budgeted >= spent;
                  final adjustedWith = constraints.maxWidth * percentage;
                  return VLayout(
                    children: [
                      SizedBox(
                        width: isInGreen ? constraints.maxWidth : adjustedWith,
                        height: Sizes.unit * 1.5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.bespokeColors.chartCompare,
                            borderRadius: BorderRadius.circular(Sizes.borderRadius / 3),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isInGreen ? adjustedWith : constraints.maxWidth,
                        height: Sizes.unit * 1.5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: isInGreen ? context.colors.good : context.colors.error,
                            borderRadius: BorderRadius.circular(Sizes.borderRadius / 3),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${target.monthlyAmountSpent.abs().format(currencyFormat)}/mo spent',
                          style: TextStyle(
                            color: isInGreen ? context.colors.good : context.colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const VSpace(),
            ],
          ),
        ),
        const VSpace(),
        const Divider(),
      ],
    );
  }
}
