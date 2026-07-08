import 'package:dart_mappable/dart_mappable.dart';

part 'update_category_view_request.mapper.dart';

@MappableClass()
class UpdateCategoryViewRequest with UpdateCategoryViewRequestMappable {
  UpdateCategoryViewRequest({
    required this.userId,
    required this.id,
    required this.name,
    required this.categoryIds,
    required this.categoryGroupIds,
  });

  final String userId;
  final String id;
  final String name;
  final List<String> categoryIds;
  final List<String> categoryGroupIds;
}
