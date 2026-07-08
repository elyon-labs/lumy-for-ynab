import 'package:dart_mappable/dart_mappable.dart';

part 'insert_category_view_request.mapper.dart';

@MappableClass()
class InsertCategoryViewRequest with InsertCategoryViewRequestMappable {
  InsertCategoryViewRequest({
    required this.userId,
    required this.name,
    required this.budgetId,
    required this.categoryIds,
    required this.categoryGroupIds,
  });

  final String userId;
  final String name;
  final String budgetId;
  final List<String> categoryIds;
  final List<String> categoryGroupIds;
}
