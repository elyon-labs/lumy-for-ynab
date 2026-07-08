import 'package:collection/collection.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/category_views_repository.dart';
import '../models/category_view.dart';

class WatchCategoryView {
  WatchCategoryView({required CategoryViewsRepository categoryViewsRepository})
    : _categoryViewsRepository = categoryViewsRepository;

  factory WatchCategoryView.create() {
    return WatchCategoryView(categoryViewsRepository: inject());
  }

  final CategoryViewsRepository _categoryViewsRepository;

  Stream<Option<CategoryView>> call(Option<String> id) {
    Stream<Option<CategoryView>> watchById(String id) {
      final stream = _categoryViewsRepository.watch;
      return stream.map((views) {
        final view = views.firstWhereOrNull((view) => view.id == id);
        return view != null ? Some(view) : const None<CategoryView>();
      });
    }

    return switch (id) {
      Some<String>(:final some) => watchById(some),
      None<String>() => Stream.value(const None<CategoryView>()),
    };
  }
}
