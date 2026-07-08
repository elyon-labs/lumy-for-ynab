import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../category_views/domain/use_cases/watch_category_views.dart';
import 'category_views_list_screen_state.dart';

class CategoryViewsListScreenCubit extends Cubit<CategoryViewsListScreenState> {
  CategoryViewsListScreenCubit({required WatchCategoryViews watchCategoryViews})
    : _watchCategoryViews = watchCategoryViews,
      super(CategoryViewsListScreenState.initial()) {
    fetch();
  }

  factory CategoryViewsListScreenCubit.create() {
    return CategoryViewsListScreenCubit(watchCategoryViews: WatchCategoryViews.create());
  }

  final WatchCategoryViews _watchCategoryViews;
  final _subs = CompositeSubscription();

  void fetch() {
    final categoryViewsStream = _watchCategoryViews();
    final sub = categoryViewsStream.listen(
      (categoryViews) => safeEmit(CategoryViewsListScreenState(categoryViews: categoryViews)),
    );
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
