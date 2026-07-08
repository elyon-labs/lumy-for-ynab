import 'package:oxidized/oxidized.dart';

import '../../../../charts/models/chart_type.dart';

class ChartDetailsScreenState {
  ChartDetailsScreenState({required this.selectedChartType});

  factory ChartDetailsScreenState.initial() {
    return ChartDetailsScreenState(selectedChartType: const None());
  }

  final Option<ChartType> selectedChartType;
}
