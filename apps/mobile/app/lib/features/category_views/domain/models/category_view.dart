import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'category_view.mapper.dart';

@MappableClass()
class CategoryView extends Equatable with CategoryViewMappable {
  const CategoryView({
    required this.id,
    required this.name,
    required this.budgetId,
    required this.isDeleted,
    required this.categoryGroupIds,
    required this.categoryIds,
  });

  final String id;
  final String name;
  final String budgetId;
  final List<String> categoryGroupIds;
  final List<String> categoryIds;
  final bool isDeleted;

  @override
  List<Object?> get props => [id, name, budgetId, categoryIds, categoryGroupIds, isDeleted];
}
