class LegacyCategoryView {
  const LegacyCategoryView({
    required this.id,
    required this.name,
    required this.budgetId,
    required this.isDeleted,
    required this.categoryIds,
    required this.categoryGroupIds,
  });

  final int id;
  final String name;
  final String budgetId;
  final bool isDeleted;
  final List<String> categoryIds;
  final List<String> categoryGroupIds;
}
