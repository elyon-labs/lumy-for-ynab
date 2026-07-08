import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../app/di.dart';
import '../../../../../../../common/domain/categories/categories_repository.dart';
import '../../../../../../../common/domain/categories/category_groups_view.dart';
import '../../../../../../../utils/_cubit.dart';
import 'choose_categories_for_view_screen_state.dart';

class ChooseCategoriesForViewScreenCubit extends Cubit<ChooseCategoriesForViewScreenState> {
  ChooseCategoriesForViewScreenCubit({required this.categoriesRepo})
    : super(ChooseCategoriesForViewScreenState.initial()) {
    fetch();
  }

  factory ChooseCategoriesForViewScreenCubit.create() {
    return ChooseCategoriesForViewScreenCubit(categoriesRepo: inject());
  }

  final CategoriesRepository categoriesRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = categoriesRepo.watchCategoryGroups(const WithoutHiddenAndSpecialGroups()).listen((
      value,
    ) {
      safeEmit(ChooseCategoriesForViewScreenState(categoryGroups: Loaded(value)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}
