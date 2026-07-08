import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/category_views_repository.dart';

class DeleteCategoryView {
  DeleteCategoryView({required CategoryViewsRepository categoryViewsRepository})
    : _categoryViewsRepository = categoryViewsRepository;

  factory DeleteCategoryView.create() {
    return DeleteCategoryView(categoryViewsRepository: inject());
  }

  final CategoryViewsRepository _categoryViewsRepository;

  Future<Result<void, Exception>> call(String id) async {
    return Result.asyncOf(() async {
      await _categoryViewsRepository.deleteCategoryView(id);
      await _categoryViewsRepository.refresh();
    });
  }
}
