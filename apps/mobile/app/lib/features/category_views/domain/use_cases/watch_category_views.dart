import 'package:oxidized/oxidized.dart';
import 'package:rxdart/transformers.dart';

import '../../../../app/di.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/category_views_repository.dart';
import '../models/category_view.dart';

class WatchCategoryViews {
  WatchCategoryViews({required CategoryViewsRepository repository, required Settings settings})
    : _categoryViewsRepository = repository,
      _settings = settings;

  factory WatchCategoryViews.create() {
    return WatchCategoryViews(repository: inject(), settings: inject());
  }

  final CategoryViewsRepository _categoryViewsRepository;
  final Settings _settings;

  Stream<List<CategoryView>> call() {
    final categoryViewsStream = _categoryViewsRepository.watch;
    final selectedBudgetIdStream = _settings.watchSelectedBudgetId();
    return selectedBudgetIdStream.switchMap((budgetId) {
      return switch (budgetId) {
        Some<String>(:final some) => categoryViewsStream.map(
          (views) => views.where((v) => v.budgetId == some).toList(),
        ),
        None<String>() => Stream.value([]),
      };
    });
  }
}
