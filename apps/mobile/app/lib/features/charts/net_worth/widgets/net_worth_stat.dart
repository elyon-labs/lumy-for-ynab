import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_stat.dart';
import '../../../../common/presentation/currency.dart';
import '../net_worth_data_cubit.dart';

class NetWorthStat extends StatelessWidget {
  const NetWorthStat({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NetWorthDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _Stat(value: value),
      _ => const LoadingStat(),
    };
  }
}

class _Stat extends HookWidget {
  const _Stat({required this.value});

  final NetWorthData value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    if (value.monthSummaries.isEmpty) {
      return Text(0.format(currencyFormat));
    }
    return Text(value.monthSummaries.values.last.netWorth.format(currencyFormat));
  }
}
