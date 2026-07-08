import '../../../../../../../category_views/domain/models/category_view.dart';

class CategoryViewsListScreenState {
  CategoryViewsListScreenState({required this.categoryViews});

  factory CategoryViewsListScreenState.initial() {
    return CategoryViewsListScreenState(categoryViews: []);
  }

  final List<CategoryView> categoryViews;
}
