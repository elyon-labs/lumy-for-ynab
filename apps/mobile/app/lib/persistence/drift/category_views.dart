part of 'local_database.dart';

class DbCategoryViews extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get budgetId => text()();
  BoolColumn get isDeleted => boolean()();
}

class DbCategoryViewCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryViewId => integer()();
  TextColumn get categoryId => text()();
}

class DbCategoryViewCategoryGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryViewId => integer()();
  TextColumn get categoryGroupId => text()();
}

extension AppDatabaseCategoryViewsX on LocalDatabase {
  Future<bool> hasAnyCategoryViews() async {
    final query = select(dbCategoryViews)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Stream<bool> watchHasAnyCategoryViews() {
    final query = select(dbCategoryViews)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);
    return query.watch().map((rows) => rows.isNotEmpty).distinct();
  }

  Future<int> insertCategoryView({
    required String name,
    required String budgetId,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
    bool isDeleted = false,
  }) {
    return transaction(() async {
      final id = await into(dbCategoryViews).insert(
        DbCategoryViewsCompanion.insert(name: name, budgetId: budgetId, isDeleted: isDeleted),
      );
      for (final categoryId in categoryIds) {
        await into(dbCategoryViewCategories).insert(
          DbCategoryViewCategoriesCompanion.insert(categoryViewId: id, categoryId: categoryId),
        );
      }
      for (final categoryGroupId in categoryGroupIds) {
        await into(dbCategoryViewCategoryGroups).insert(
          DbCategoryViewCategoryGroupsCompanion.insert(
            categoryViewId: id,
            categoryGroupId: categoryGroupId,
          ),
        );
      }
      return id;
    });
  }

  Future<int> deleteCategoryView(int id) {
    return transaction(() async {
      return await (delete(dbCategoryViews)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  Future<List<LegacyCategoryView>> fetchAllCategoryViews() async {
    final query =
        select(dbCategoryViews).join([
            leftOuterJoin(
              dbCategoryViewCategories,
              dbCategoryViewCategories.categoryViewId.equalsExp(dbCategoryViews.id),
            ),
            leftOuterJoin(
              dbCategoryViewCategoryGroups,
              dbCategoryViewCategoryGroups.categoryViewId.equalsExp(dbCategoryViews.id),
            ),
          ])
          ..where(dbCategoryViews.isDeleted.equals(false))
          // Order by the ID so when we migrate, the user can use createdAt ordering
          ..orderBy([OrderingTerm.asc(dbCategoryViews.id)]);

    final results = await query.get();
    final categoryIds = <DbCategoryView, Set<String>>{};
    final categoryGroupIds = <DbCategoryView, Set<String>>{};
    for (final row in results) {
      final view = row.readTable(dbCategoryViews);
      final categoryId = row.readTableOrNull(dbCategoryViewCategories)?.categoryId;
      final categoryGroupId = row.readTableOrNull(dbCategoryViewCategoryGroups)?.categoryGroupId;
      if (categoryId != null) {
        categoryIds.putIfAbsent(view, () => {}).add(categoryId);
      }
      if (categoryGroupId != null) {
        categoryGroupIds.putIfAbsent(view, () => {}).add(categoryGroupId);
      }
    }
    final set = <DbCategoryView>{...categoryIds.keys, ...categoryGroupIds.keys};
    return set.map((view) {
      return LegacyCategoryView(
        id: view.id,
        name: view.name,
        budgetId: view.budgetId,
        isDeleted: view.isDeleted,
        categoryIds: categoryIds[view]?.toList() ?? [],
        categoryGroupIds: categoryGroupIds[view]?.toList() ?? [],
      );
    }).toList();
  }
}
