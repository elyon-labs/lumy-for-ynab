import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/domain/categories/categories_repository.dart';
import '../../../../../../../../common/domain/categories/categories_view.dart';
import '../../../../../../../../common/domain/categories/category_groups_view.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../category_views/domain/errors/category_view_not_found_error.dart';
import '../../../../../../../category_views/domain/use_cases/delete_category_view.dart';
import '../../../../../../../category_views/domain/use_cases/watch_category_view.dart';
import 'category_view_details_screen_state.dart';

class CategoryViewDetailsScreenCubit extends Cubit<CategoryViewDetailsScreenState> {
  CategoryViewDetailsScreenCubit({
    required String categoryViewId,
    required WatchCategoryView watchCategoryView,
    required CategoriesRepository categoriesRepo,
    required DeleteCategoryView deleteCategoryView,
  }) : _categoryViewId = categoryViewId,
       _watchCategoryView = watchCategoryView,
       _categoriesRepo = categoriesRepo,
       _deleteCategoryView = deleteCategoryView,
       super(CategoryViewDetailsScreenState.initial(categoryViewId)) {
    fetch();
  }

  factory CategoryViewDetailsScreenCubit.create({required String categoryViewId}) {
    return CategoryViewDetailsScreenCubit(
      categoryViewId: categoryViewId,
      watchCategoryView: WatchCategoryView.create(),
      categoriesRepo: inject(),
      deleteCategoryView: DeleteCategoryView.create(),
    );
  }

  final String _categoryViewId;
  final WatchCategoryView _watchCategoryView;
  final CategoriesRepository _categoriesRepo;
  final DeleteCategoryView _deleteCategoryView;
  final _subs = CompositeSubscription();

  void fetch() {
    final categories = _categoriesRepo.watchCategories(CategoriesInView(_categoryViewId));
    final categoryGroups = _categoriesRepo.watchCategoryGroups(const AllCategoryGroups());
    final view = _watchCategoryView(Some(_categoryViewId));
    final sub = Rx.combineLatest3(categories, categoryGroups, view, (a, b, c) {
      return CategoryViewDetailsScreenState(
        categoryViewId: _categoryViewId,
        view: c.mapOr(Loaded.new, Error(CategoryViewNotFoundError(_categoryViewId))),
        categories: a,
        categoryGroups: b,
      );
    }).listen(safeEmit);
    _subs.add(sub);
  }

  Future<void> delete() {
    return _deleteCategoryView(_categoryViewId);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
