import 'package:dart_mappable/dart_mappable.dart';

part 'category_view_draft.mapper.dart';

@MappableClass()
class CategoryViewDraft with CategoryViewDraftMappable {
  const CategoryViewDraft({this.categoryIds, this.categoryGroupIds, this.name});

  final List<String>? categoryIds;
  final List<String>? categoryGroupIds;
  final String? name;
}

extension CategoryViewDraftX on CategoryViewDraft {
  bool get isValid {
    final hasCategoryIds = categoryIds != null && categoryIds!.isNotEmpty;
    final hasCategoryGroupIds = categoryGroupIds != null && categoryGroupIds!.isNotEmpty;
    final nameIsValid = name != null && name!.isNotEmpty;
    return (hasCategoryIds || hasCategoryGroupIds) && nameIsValid;
  }

  CategoryViewDraft setName(String name) => copyWith(name: name);
  CategoryViewDraft setSelected({
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) => copyWith(categoryIds: categoryIds, categoryGroupIds: categoryGroupIds);
}
