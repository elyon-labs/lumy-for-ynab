import 'package:lumy/common/domain/categories/categories_repository.dart';
import 'package:lumy/common/domain/categories/categories_view.dart';
import 'package:lumy/common/domain/categories/category_groups_view.dart';
import 'package:lumy/features/category_views/domain/models/category_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

class FakeCategoriesRepository implements CategoriesRepository {
  FakeCategoriesRepository({
    this.categories = const [],
    this.categoryGroups = const [],
    this.categoryViews = const [],
  });

  final List<Category> categories;
  final List<CategoryGroup> categoryGroups;
  final List<CategoryView> categoryViews;

  @override
  ValueStream<List<Category>> watchCategories(CategoriesView view) {
    return Stream.value(categories).shareValue();
  }

  @override
  ValueStream<List<CategoryGroup>> watchCategoryGroups(CategoryGroupsView view) {
    return Stream.value(categoryGroups).shareValue();
  }

  @override
  Future<void> dispose() async {
    // Do nothing.
  }
}
