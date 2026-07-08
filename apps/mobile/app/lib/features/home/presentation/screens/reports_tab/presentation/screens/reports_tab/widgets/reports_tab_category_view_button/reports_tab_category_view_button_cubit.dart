import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../../../app/di.dart';
import '../../../../../../../../../../persistence/settings.dart';
import '../../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../category_views/domain/models/category_view.dart';
import '../../../../../../../../../category_views/domain/use_cases/watch_category_view.dart';
import '../../../../../../../../../category_views/domain/use_cases/watch_category_views.dart';
import 'reports_tab_category_view_button_state.dart';

class ReportsTabCategoryMenuButtonCubit extends Cubit<ReportsTabCategoryViewButtonState> {
  ReportsTabCategoryMenuButtonCubit({
    required Settings settings,
    required WatchCategoryView watchCategoryView,
    required WatchCategoryViews watchCategoryViews,
  }) : _settings = settings,
       _watchCategoryView = watchCategoryView,
       _watchCategoryViews = watchCategoryViews,
       super(ReportsTabCategoryViewButtonState.initial()) {
    fetch();
  }

  factory ReportsTabCategoryMenuButtonCubit.create() {
    return ReportsTabCategoryMenuButtonCubit(
      settings: inject(),
      watchCategoryView: WatchCategoryView.create(),
      watchCategoryViews: WatchCategoryViews.create(),
    );
  }

  final Settings _settings;
  final WatchCategoryView _watchCategoryView;
  final WatchCategoryViews _watchCategoryViews;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub = _settings
        .watchReportsTabCategoryView()
        .switchMap((value) async* {
          final view = _watchCategoryView(value);
          final views = _watchCategoryViews();
          yield* Rx.combineLatest2(view, views, (a, b) => (a, b));
        })
        .listen((value) {
          final (selected, views) = value;
          final unselected = switch (selected) {
            Some<CategoryView>(:final some) => views.where((v) => v.id != some.id).toList(),
            None<CategoryView>() => views,
          };
          safeEmit(
            ReportsTabCategoryViewButtonState(
              allViews: views,
              unselectedViews: unselected,
              selected: selected,
            ),
          );
        });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
