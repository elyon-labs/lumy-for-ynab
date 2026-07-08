import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/presentation/charts/loading_stat.dart';
import '../state/days_buffer_chart_data_cubit.dart';

class DaysBufferStat extends StatelessWidget {
  const DaysBufferStat({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DaysBufferChartDataCubit>().state;
    return switch (data) {
      Loaded(:final value) => Text('${value.currentBuffer} days'),
      _ => const LoadingStat(),
    };
  }
}
