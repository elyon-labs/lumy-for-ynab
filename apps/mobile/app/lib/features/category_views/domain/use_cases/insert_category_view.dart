import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/category_views_repository.dart';

class InsertCategoryView {
  InsertCategoryView({required CategoryViewsRepository categoryViewsRepository})
    : _categoryViewsRepository = categoryViewsRepository;

  factory InsertCategoryView.create() {
    return InsertCategoryView(categoryViewsRepository: inject());
  }

  final CategoryViewsRepository _categoryViewsRepository;

  Future<Result<String, Exception>> call({
    required String name,
    required String budgetId,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) async {
    final result = await _categoryViewsRepository.insertCategoryView(
      name: name,
      budgetId: budgetId,
      categoryIds: categoryIds,
      categoryGroupIds: categoryGroupIds,
    );
    if (result.isOk()) {
      await _categoryViewsRepository.refresh();
    }
    return result;
  }
}
