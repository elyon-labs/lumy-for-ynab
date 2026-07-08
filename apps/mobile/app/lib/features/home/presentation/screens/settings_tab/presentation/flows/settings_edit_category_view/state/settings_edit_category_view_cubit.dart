import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../category_views/domain/errors/category_view_not_found_error.dart';
import '../../../../../../../../category_views/domain/use_cases/watch_category_view.dart';
import 'settings_edit_category_view_state.dart';

class SettingsEditCategoryViewCubit extends Cubit<SettingsEditCategoryViewState> {
  SettingsEditCategoryViewCubit({
    required String viewId,
    required WatchCategoryView watchCategoryView,
  }) : _watchCategoryView = watchCategoryView,
       _categoryViewId = viewId,
       super(SettingsEditCategoryViewState.initial()) {
    fetch();
  }

  factory SettingsEditCategoryViewCubit.create({required String viewId}) {
    return SettingsEditCategoryViewCubit(
      viewId: viewId,
      watchCategoryView: WatchCategoryView.create(),
    );
  }

  final String _categoryViewId;
  final WatchCategoryView _watchCategoryView;
  final _subs = CompositeSubscription();

  void fetch() {
    final categoryViewStream = _watchCategoryView(Some(_categoryViewId));
    final sub = categoryViewStream.listen(
      (categoryView) => safeEmit(
        SettingsEditCategoryViewState(
          categoryView: categoryView.mapOr(
            Loaded.new,
            Error(CategoryViewNotFoundError(_categoryViewId)),
          ),
        ),
      ),
    );
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
