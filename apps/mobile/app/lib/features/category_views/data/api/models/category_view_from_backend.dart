import 'package:dart_mappable/dart_mappable.dart';

part 'category_view_from_backend.mapper.dart';

@MappableClass()
class CategoryViewOnlyFromBackend with CategoryViewOnlyFromBackendMappable {
  CategoryViewOnlyFromBackend({required this.id, required this.name, required this.budgetId});

  final String id;
  final String name;
  final String budgetId;
}

@MappableClass()
class JoinedCategoryViewFromBackend with JoinedCategoryViewFromBackendMappable {
  JoinedCategoryViewFromBackend({
    required this.id,
    required this.name,
    required this.budgetId,
    required this.createdAt,
    required this.categories,
    required this.categoryGroups,
  });

  final String id;
  final String budgetId;
  final String name;
  final DateTime createdAt;
  final List<String> categories;
  final List<String> categoryGroups;
}
