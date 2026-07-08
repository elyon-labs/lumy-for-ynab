import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_stat.dart';
import '../../../../common/presentation/currency.dart';
import '../state/spend_by_payee_chart_data_cubit.dart';

class SpendByPayeeStat extends HookWidget {
  const SpendByPayeeStat({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final data = context.watch<SpendByPayeeChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => Text(value.totalSpend.format(currencyFormat)),
      _ => const LoadingStat(),
    };
  }
}
