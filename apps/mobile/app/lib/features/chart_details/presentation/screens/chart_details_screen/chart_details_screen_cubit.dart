import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../../charts/models/chart.dart';
import '../../../../charts/models/chart_type.dart';
import 'chart_details_screen_state.dart';

class ChartDetailsScreenCubit extends Cubit<ChartDetailsScreenState> {
  ChartDetailsScreenCubit({required Chart chart, required Settings settings})
    : _settings = settings,
      _chart = chart,
      super(ChartDetailsScreenState.initial()) {
    fetch();
  }

  factory ChartDetailsScreenCubit.create({required Chart chart}) {
    return ChartDetailsScreenCubit(chart: chart, settings: inject());
  }

  final Chart _chart;
  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _settings.watchSelectedChartType(_chart).listen((chartType) {
      final effectiveType = chartType.unwrapOr(_chart.defaultChartType);
      safeEmit(ChartDetailsScreenState(selectedChartType: Some(effectiveType)));
    });
    _subs.add(sub);
  }

  void setChartType(ChartType type) {
    _settings.setSelectedChartType(_chart, type);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
