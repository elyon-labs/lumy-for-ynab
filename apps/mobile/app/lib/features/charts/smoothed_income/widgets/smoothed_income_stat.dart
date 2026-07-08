import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_stat.dart';
import '../../../../common/presentation/currency.dart';
import '../smoothed_income_chart_data_cubit.dart';

class SmoothedIncomeStat extends HookWidget {
  const SmoothedIncomeStat({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SmoothedIncomeChartDataCubit>().state;
    final currencyFormat = useCurrencyFormat();

    return switch (data) {
      Loaded(:final value) => _LoadedStat(value: value, currencyFormat: currencyFormat),
      _ => const LoadingStat(),
    };
  }
}

class _LoadedStat extends StatelessWidget {
  const _LoadedStat({required this.value, required this.currencyFormat});

  final SmoothedIncomeChartData value;
  final Option<CurrencyFormat> currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: value.averageNetIncome.format(currencyFormat)),
          const WidgetSpan(child: HSpace(space: Sizes.unit / 2)),
          TextSpan(text: 'avg', style: context.text.body),
        ],
      ),
    );
  }
}
