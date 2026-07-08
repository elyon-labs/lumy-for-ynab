import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/domain/calculations/days_buffer/fn.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/markdown.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../date_range/domain/models/date_range.dart';
import '../state/days_buffer_chart_data_cubit.dart';

class DaysBufferMathState {
  DaysBufferMathState({required this.selectedDateRange});

  factory DaysBufferMathState.initial() {
    return DaysBufferMathState(selectedDateRange: const Loading());
  }

  final Async<DateRange> selectedDateRange;
}

class DaysBufferMathCubit extends Cubit<DaysBufferMathState> {
  DaysBufferMathCubit({required this.settings}) : super(DaysBufferMathState.initial()) {
    fetch();
  }

  factory DaysBufferMathCubit.create() {
    return DaysBufferMathCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final selectedDateRange = settings.watchSelectedDateRange();
    final sub = selectedDateRange.listen((selectedDateRange) {
      safeEmit(DaysBufferMathState(selectedDateRange: Loaded(selectedDateRange)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class DaysBufferMath extends HookWidget {
  const DaysBufferMath({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DaysBufferChartDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => _Math(value: value),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class _Math extends HookWidget {
  const _Math({required this.value});

  final DaysBufferResult value;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final dailyOutflowFormatted = value.dailyOutflow.format(currencyFormat);
    final totalSpendFormatted = value.totalSpend.format(currencyFormat);
    final totalBalanceFormatted = value.totalBalance.format(currencyFormat);

    return BlocProvider(
      create: (context) => DaysBufferMathCubit.create(),
      child: BlocBuilder<DaysBufferMathCubit, DaysBufferMathState>(
        builder: (context, state) {
          final buffer = StringBuffer(
            'Your current total balance of **$totalBalanceFormatted** '
            'gives you a buffer of **${value.currentBuffer} days** of spending.',
          );
          final explanation = state.selectedDateRange.mapOr((value) {
            return ' This was calculated based on total outflows of **$totalSpendFormatted** '
                'over the course of **${value.duration().inDays}** days. This results in a daily outflow of '
                '**$dailyOutflowFormatted**.';
          }, '');
          buffer.write(explanation);
          return Markdown(data: buffer.toString());
        },
      ),
    );
  }
}
