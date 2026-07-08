import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../models/chart_type.dart';
import '../income_expense_chart.dart';
import 'income_expense_bar.dart';
import 'income_expense_line.dart';

class IncomeExpenseWrapperState {
  IncomeExpenseWrapperState({required this.chartTypePreference});

  factory IncomeExpenseWrapperState.initial() {
    return IncomeExpenseWrapperState(chartTypePreference: const Loading());
  }

  final Async<ChartType> chartTypePreference;
}

class IncomeExpenseWrapperCubit extends Cubit<IncomeExpenseWrapperState> {
  IncomeExpenseWrapperCubit({required this.settings}) : super(IncomeExpenseWrapperState.initial()) {
    fetch();
  }

  factory IncomeExpenseWrapperCubit.create() {
    return IncomeExpenseWrapperCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = settings.watchSelectedChartType(IncomeExpenseChart()).listen((chartType) {
      final effectiveType = chartType.unwrapOr(ChartType.bar);
      safeEmit(IncomeExpenseWrapperState(chartTypePreference: Loaded(effectiveType)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class IncomeExpenseWrapper extends StatelessWidget {
  const IncomeExpenseWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncomeExpenseWrapperCubit.create(),
      child: BlocBuilder<IncomeExpenseWrapperCubit, IncomeExpenseWrapperState>(
        builder: (context, state) {
          return switch (state.chartTypePreference) {
            Loaded(:final value) => _Chart(value),
            _ => const LoadingChart(),
          };
        },
      ),
    );
  }
}

class _Chart extends HookWidget {
  const _Chart(this.preference);

  final ChartType preference;

  @override
  Widget build(BuildContext context) {
    final child = switch (preference) {
      ChartType.line => const IncomeExpenseLine(),
      // No other types supported
      _ => const IncomeExpenseBar(),
    };

    return child;
  }
}
