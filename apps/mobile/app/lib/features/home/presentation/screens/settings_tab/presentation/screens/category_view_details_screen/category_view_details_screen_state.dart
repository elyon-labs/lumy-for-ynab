import 'package:dart_foundation/dart_foundation.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../category_views/domain/models/category_view.dart';

class CategoryViewDetailsScreenState {
  CategoryViewDetailsScreenState({
    required this.categoryViewId,
    required this.view,
    required this.categories,
    required this.categoryGroups,
  });

  factory CategoryViewDetailsScreenState.initial(String categoryViewId) {
    return CategoryViewDetailsScreenState(
      categoryViewId: categoryViewId,
      view: const Loading(),
      categories: [],
      categoryGroups: [],
    );
  }

  final String categoryViewId;
  final Async<CategoryView> view;
  final List<Category> categories;
  final List<CategoryGroup> categoryGroups;
}
