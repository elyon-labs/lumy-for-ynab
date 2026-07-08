import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../app/di.dart';
import '../../../../../../../common/domain/categories/categories_repository.dart';
import '../../../../../../../common/domain/categories/category_groups_view.dart';
import '../../../../../../../common/domain/payees/payees_repository.dart';
import '../../../../../../../common/domain/payees/payees_view.dart';
import '../../../../../../../utils/_cubit.dart';
import 'choose_spend_tracker_source_screen_state.dart';

class ChooseSpendTrackerSourceScreenCubit extends Cubit<ChooseSpendTrackerSourceScreenState> {
  ChooseSpendTrackerSourceScreenCubit({
    required PayeesRepository payeesRepo,
    required CategoriesRepository categoriesRepo,
  }) : _categoriesRepository = categoriesRepo,
       _payeesRepository = payeesRepo,
       super(ChooseSpendTrackerSourceScreenState.initial()) {
    fetch();
  }

  factory ChooseSpendTrackerSourceScreenCubit.create() {
    return ChooseSpendTrackerSourceScreenCubit(payeesRepo: inject(), categoriesRepo: inject());
  }

  final PayeesRepository _payeesRepository;
  final CategoriesRepository _categoriesRepository;
  final _subs = CompositeSubscription();

  void fetch() {
    final categoryGroups = _categoriesRepository.watchCategoryGroups(
      const WithoutHiddenAndSpecialGroups(),
    );
    final payees = _payeesRepository.watch(const AllPayees());
    final sub = Rx.combineLatest2(
      categoryGroups,
      payees,
      (a, b) => ChooseSpendTrackerSourceScreenState(categoryGroups: a, payees: b),
    ).listen(safeEmit);
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
