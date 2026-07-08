import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_cubit.dart';
import 'budget_tab_settings_screen_state.dart';

class BudgetTabSettingsCubit extends Cubit<BudgetTabSettingsState> {
  BudgetTabSettingsCubit({required Settings settings})
    : _settings = settings,
      super(BudgetTabSettingsState.initial()) {
    fetch();
  }

  factory BudgetTabSettingsCubit.create() {
    return BudgetTabSettingsCubit(settings: inject());
  }

  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final categoryView = _settings.watchBudgetTabCategoryView();
    final useFrugalMonthLeftToSpend = _settings.watchUseFrugalMonthLeftToSpend();
    final sub = Rx.combineLatest2(
      categoryView,
      useFrugalMonthLeftToSpend,
      (a, b) => BudgetTabSettingsState(categoryView: a, useFrugalMonthLeftToSpend: b),
    ).listen(safeEmit);
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
