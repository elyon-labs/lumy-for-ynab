import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_stat.dart';
import '../../../../common/presentation/currency.dart';
import '../state/income_expense_chart_data_cubit.dart';

class IncomeExpenseStat extends StatelessWidget {
  const IncomeExpenseStat({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<IncomeExpenseChartDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _LoadedStat(value: value),
      _ => const LoadingStat(),
    };
  }
}

class _LoadedStat extends HookWidget {
  const _LoadedStat({required this.value});

  final IncomeExpenseChartData value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value.average.averageIncome.format(currencyFormat),
            style: const TextStyle(height: 1),
          ),
          const TextSpan(text: ','),
          const WidgetSpan(child: HSpace()),
          TextSpan(text: value.average.averageExpense.format(currencyFormat)),
          const WidgetSpan(child: HSpace(space: Sizes.unit / 2)),
          TextSpan(text: 'avg', style: context.text.body),
        ],
      ),
    );
  }
}
