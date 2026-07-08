import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';

class ChartSettingsState {
  ChartSettingsState({required this.showTrendlines});

  factory ChartSettingsState.initial() {
    return ChartSettingsState(showTrendlines: false);
  }

  final bool showTrendlines;
}

class ChartSettingsCubit extends Cubit<ChartSettingsState> {
  ChartSettingsCubit({required this.settings}) : super(ChartSettingsState.initial()) {
    fetch();
  }

  factory ChartSettingsCubit.create() {
    return ChartSettingsCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final showTrendlines = settings.watchShowTrendlines();
    final sub = showTrendlines.listen((value) {
      safeEmit(ChartSettingsState(showTrendlines: value));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}
