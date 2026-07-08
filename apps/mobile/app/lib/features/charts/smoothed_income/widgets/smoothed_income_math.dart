import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/markdown.dart';
import '../../../date_range/domain/models/date_range.dart';
import '../../../date_range/state/selected_date_range_cubit.dart';
import '../smoothed_income_chart_data_cubit.dart';

class SmoothedIncomeMath extends StatelessWidget {
  const SmoothedIncomeMath({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SmoothedIncomeChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => _LoadedMath(value: value),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class _LoadedMath extends HookWidget {
  const _LoadedMath({required this.value});

  final SmoothedIncomeChartData value;

  @override
  Widget build(BuildContext context) {
    final selectedDateRange = context.watch<SelectedDateRangeCubit>().state;
    final currencyFormat = useCurrencyFormat();
    final totalIncomeFormatted = value.totalIncome.format(currencyFormat);
    final dailyIncomeFormatted = value.dailyIncome.format(currencyFormat);
    final averageNetIncomeFormatted = value.averageNetIncome.format(currencyFormat);
    final buffer = StringBuffer(
      'Your total income of **$totalIncomeFormatted** '
      'over **${selectedDateRange.duration().inDays}** days gives you a daily income of **$dailyIncomeFormatted**. '
      'When factoring in your spending over the same timeframe, your average net income '
      '(daily income - daily outflow) is **$averageNetIncomeFormatted**.',
    );
    return Markdown(data: buffer.toString());
  }
}
