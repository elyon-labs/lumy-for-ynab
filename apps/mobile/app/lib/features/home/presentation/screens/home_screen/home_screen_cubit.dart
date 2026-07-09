import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../../sync/domain/use_cases/watched_has_unsynced_data.dart';
import 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit({required Settings settings, required WatchHasUnsyncedData watchHasUnsyncedData})
    : _watchHasUnsyncedData = watchHasUnsyncedData,
      _settings = settings,
      super(HomeScreenState.initial()) {
    fetch();
  }

  factory HomeScreenCubit.create() {
    return HomeScreenCubit(settings: inject(), watchHasUnsyncedData: WatchHasUnsyncedData.create());
  }

  final Settings _settings;
  final WatchHasUnsyncedData _watchHasUnsyncedData;
  final _subs = CompositeSubscription();

  void fetch() {
    final budgetId = _settings.watchSelectedBudgetId();
    final hasUnsyncedData = _watchHasUnsyncedData();

    final sub = Rx.combineLatest2(budgetId, hasUnsyncedData, (budgetId, hasUnsyncedData) {
      return state.copyWith(budgetId: Loaded(budgetId), hasUnsyncedData: hasUnsyncedData);
    }).listen(safeEmit);

    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
