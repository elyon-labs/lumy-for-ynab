import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../utils/_local_date.dart';
import '../../../../../../../category_views/domain/use_cases/watch_category_view.dart';
import '../../../../../../../frugal_month/domain/use_cases/watch_current_frugal_month.dart';
import '../../../../../../../frugal_month/domain/use_cases/watch_frugal_months.dart';
import 'budget_tab_state.dart';

class BudgetTabCubit extends Cubit<BudgetTabState> {
  BudgetTabCubit({
    required Settings settings,
    required WatchCategoryView watchCategoryView,
    required WatchFrugalMonths watchFrugalMonths,
    required WatchCurrentFrugalMonth watchCurrentFrugalMonth,
    required BudgetsRepository budgetsRepo,
  }) : _watchFrugalMonths = watchFrugalMonths,
       _budgetsRepository = budgetsRepo,
       _settings = settings,
       _watchCategoryView = watchCategoryView,
       _watchCurrentFrugalMonth = watchCurrentFrugalMonth,
       super(BudgetTabState.initial()) {
    unawaited(_fetch());
  }

  factory BudgetTabCubit.create() {
    return BudgetTabCubit(
      watchCategoryView: WatchCategoryView.create(),
      watchCurrentFrugalMonth: WatchCurrentFrugalMonth.create(),
      watchFrugalMonths: WatchFrugalMonths.create(),
      settings: inject(),
      budgetsRepo: inject(),
    );
  }

  final Settings _settings;
  final WatchCategoryView _watchCategoryView;
  final WatchFrugalMonths _watchFrugalMonths;
  final WatchCurrentFrugalMonth _watchCurrentFrugalMonth;
  final BudgetsRepository _budgetsRepository;
  final _subs = CompositeSubscription();

  Future<void> _fetch() async {
    final sub = _settings
        .watchBudgetTabCategoryView()
        .switchMap((categoryView) async* {
          final frugalMonthsStream = _watchFrugalMonths();
          final currentFrugalMonthStream = _watchCurrentFrugalMonth();
          final selectedBudgetStream = _budgetsRepository.watchSelected();
          final selectedCategoryViewStream = _watchCategoryView(categoryView);
          yield* Rx.combineLatest4(
            selectedBudgetStream,
            frugalMonthsStream,
            currentFrugalMonthStream,
            selectedCategoryViewStream,
            (selectedBudget, frugalMonths, currentFrugalMonth, categoryView) {
              final plannedFrugalMonth = frugalMonths.singleWhereOrNull((month) {
                return month.month.isSameMonthAs(nextMonth);
              });

              return BudgetTabState(
                selectedBudgetName: selectedBudget.map((b) => b.name),
                plannedFrugalMonth: plannedFrugalMonth,
                currentFrugalMonth: currentFrugalMonth,
                selectedCategoryView: categoryView,
                isLoading: false,
              );
            },
          );
        })
        .listen(safeEmit);
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
