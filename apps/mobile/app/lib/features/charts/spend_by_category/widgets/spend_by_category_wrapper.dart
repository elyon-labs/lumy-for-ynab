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
import '../spend_by_category_chart.dart';
import 'spend_by_category_bar.dart';
import 'spend_by_category_pie.dart';

class SpendByCategoryWrapperState {
  SpendByCategoryWrapperState({required this.chartTypePreference});

  factory SpendByCategoryWrapperState.initial() {
    return SpendByCategoryWrapperState(chartTypePreference: const Loading());
  }

  final Async<ChartType> chartTypePreference;
}

class SpendByCategoryWrapperCubit extends Cubit<SpendByCategoryWrapperState> {
  SpendByCategoryWrapperCubit({required this.settings})
    : super(SpendByCategoryWrapperState.initial()) {
    fetch();
  }

  factory SpendByCategoryWrapperCubit.create() {
    return SpendByCategoryWrapperCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = settings.watchSelectedChartType(SpendByCategoryChart()).listen((chartType) {
      final effectiveType = chartType.unwrapOr(ChartType.pie);
      safeEmit(SpendByCategoryWrapperState(chartTypePreference: Loaded(effectiveType)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class SpendByCategoryWrapper extends StatelessWidget {
  const SpendByCategoryWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpendByCategoryWrapperCubit.create(),
      child: BlocBuilder<SpendByCategoryWrapperCubit, SpendByCategoryWrapperState>(
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
  const _Chart(this.chartType);

  final ChartType chartType;

  @override
  Widget build(BuildContext context) {
    final child = switch (chartType) {
      ChartType.bar => const SpendByCategoryBar(),
      // No other types supported
      _ => const SpendByCategoryPie(),
    };

    return child;
  }
}
