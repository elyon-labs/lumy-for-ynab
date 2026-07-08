import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../app_review/app_review_service.dart';
import '../../../../../../../auth/domain/use_cases/watch_is_user_anonymous.dart';
import '../../../../../../../frugal_month/domain/use_cases/watch_past_frugal_months.dart';
import '../../../../../../../spend_tracker/domain/use_cases/watch_all_spend_trackers.dart';
import 'settings_tab_state.dart';

class SettingsTabCubit extends Cubit<SettingsTabState> {
  SettingsTabCubit({
    required BudgetsRepository budgetsRepository,
    required Settings settings,
    required AppReviewService appReviewService,
    required WatchAllSpendTrackers watchAllSpendTrackers,
    required WatchPastFrugalMonths watchPastFrugalMonths,
    required WatchIsUserAnonymous watchIsUserAnonymous,
  }) : _budgetsRepo = budgetsRepository,
       _settings = settings,
       _appReviewService = appReviewService,
       _watchAllSpendTrackers = watchAllSpendTrackers,
       _watchPastFrugalMonths = watchPastFrugalMonths,
       _watchIsUserAnonymous = watchIsUserAnonymous,
       super(SettingsTabState.initial()) {
    fetch();
  }

  factory SettingsTabCubit.create() {
    return SettingsTabCubit(
      budgetsRepository: inject(),
      settings: inject(),
      appReviewService: inject<AppReviewService>(),
      watchAllSpendTrackers: WatchAllSpendTrackers.create(),
      watchPastFrugalMonths: WatchPastFrugalMonths.create(),
      watchIsUserAnonymous: WatchIsUserAnonymous.create(),
    );
  }

  final BudgetsRepository _budgetsRepo;
  final Settings _settings;
  final AppReviewService _appReviewService;
  final WatchAllSpendTrackers _watchAllSpendTrackers;
  final WatchPastFrugalMonths _watchPastFrugalMonths;
  final WatchIsUserAnonymous _watchIsUserAnonymous;

  final _subs = CompositeSubscription();

  void fetch() {
    final currencyFormatStream = _budgetsRepo.watchCurrencyFormat();
    final themeModeStream = _settings.watchThemeMode();
    final allBudgetsStream = _budgetsRepo.watch();
    final selectedBudgetStream = _budgetsRepo.watchSelected();

    final sub =
        Rx.combineLatest7(
          currencyFormatStream,
          themeModeStream,
          allBudgetsStream,
          selectedBudgetStream,
          _watchAllSpendTrackers(),
          _watchPastFrugalMonths(),
          _watchIsUserAnonymous(),
          (a, b, c, d, e, f, g) => (a, b, c, d, e, f, g),
        ).listen((event) {
          final (
            currencyFormat,
            themeMode,
            allBudgets,
            selectedBudget,
            spendTrackers,
            frugalMonths,
            isUserAnonymous,
          ) = event;

          safeEmit(
            SettingsTabState(
              selectedBudget: selectedBudget,
              allBudgets: allBudgets,
              spendTrackers: spendTrackers,
              shouldShowNullCurrencyTile: currencyFormat.isNone(),
              themeMode: themeMode,
              pastFrugalMonths: frugalMonths,
              isLoading: false,
              isUserAnonymous: isUserAnonymous,
            ),
          );
        });
    _subs.add(sub);
  }

  Future<void> openStore() {
    return _appReviewService.openStore();
  }

  @override
  Future<void> close() async {
    await _subs.cancel();
    return super.close();
  }
}
