import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/category_views_repository.dart';

class UpdateCategoryView {
  UpdateCategoryView({required CategoryViewsRepository categoryViewsRepository})
    : _categoryViewsRepository = categoryViewsRepository;

  factory UpdateCategoryView.create() {
    return UpdateCategoryView(categoryViewsRepository: inject());
  }

  final CategoryViewsRepository _categoryViewsRepository;

  Future<Result<void, Exception>> call({
    required String id,
    required String name,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) async {
    final result = await _categoryViewsRepository.updateCategoryView(
      id: id,
      name: name,
      categoryIds: categoryIds,
      categoryGroupIds: categoryGroupIds,
    );
    if (result.isOk()) {
      await _categoryViewsRepository.refresh();
    }
    return result;
  }
}
