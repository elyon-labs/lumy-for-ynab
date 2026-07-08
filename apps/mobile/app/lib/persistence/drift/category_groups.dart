part of 'local_database.dart';

class DbCategoryGroups extends Table {
  TextColumn get uuid => text()();
  TextColumn get budgetId => text()();
  TextColumn get name => text()();
  BoolColumn get isHidden => boolean()();
  BoolColumn get isDeleted => boolean()();
  IntColumn get order => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbCategories extends Table {
  TextColumn get uuid => text()();
  TextColumn get categoryGroupId => text()();
  TextColumn get budgetId => text()();
  TextColumn get name => text()();
  BoolColumn get isHidden => boolean()();
  BoolColumn get isDeleted => boolean()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  // Current month props
  IntColumn get activity => integer().withDefault(const Constant(0))();
  IntColumn get budgeted => integer().withDefault(const Constant(0))();
  IntColumn get balance => integer().withDefault(const Constant(0))();
  // Target props
  TextColumn get targetType => textEnum<TargetType>().nullable()();
  BoolColumn get targetNeedsWholeAmount => boolean().nullable()();
  IntColumn get targetDay => integer().nullable()();
  IntColumn get targetCadence => integer().nullable()();
  IntColumn get targetCadenceFrequency => integer().nullable()();
  TextColumn get targetCreationMonth => text().nullable()();
  IntColumn get targetBalance => integer().nullable()();
  TextColumn get targetMonth => text().nullable()();
  IntColumn get targetPercentageComplete => integer().nullable()();
  IntColumn get targetMonthsToBudget => integer().nullable()();
  IntColumn get targetUnderFunded => integer().nullable()();
  IntColumn get targetOverallFunded => integer().nullable()();
  IntColumn get targetOverallLeft => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbCategoryKnowledges extends Table {
  TextColumn get budgetId => text()();
  IntColumn get knowledge => integer()();
  TextColumn get month => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabaseCategoryGroupsX on LocalDatabase {
  Future<void> insertCategoryGroups(
    List<CategoryGroup> ynabCategoryGroups, {
    required String budgetId,
    required int knowledge,
  }) async {
    await transaction(() async {
      // First, delete all categories and category groups for the budget
      // to ensure we have a clean slate. This is important because the YNAB API doesn't
      // communicate the re-ordering of categories or category groups or the renaming of category-groups
      // in delta requests.
      await (delete(dbCategories)..where((t) => t.budgetId.equals(budgetId))).go();
      await (delete(dbCategoryGroups)..where((t) => t.budgetId.equals(budgetId))).go();

      // Async insert with index used as `order` column
      // to ensure the order is preserved.
      for (int i = 0; i < ynabCategoryGroups.length; i++) {
        final categoryGroup = ynabCategoryGroups[i];
        await into(dbCategoryGroups).insertOnConflictUpdate(
          DbCategoryGroupsCompanion.insert(
            uuid: categoryGroup.id,
            budgetId: budgetId,
            name: categoryGroup.name,
            isHidden: categoryGroup.isHidden,
            isDeleted: categoryGroup.isDeleted,
            order: Value(i),
          ),
        );

        for (int j = 0; j < categoryGroup.categories.length; j++) {
          final category = categoryGroup.categories[j];
          await into(dbCategories).insertOnConflictUpdate(
            DbCategoriesCompanion.insert(
              uuid: category.id,
              categoryGroupId: categoryGroup.id,
              budgetId: budgetId,
              name: category.name,
              isHidden: category.isHidden,
              isDeleted: category.isDeleted,
              activity: Value(category.activity),
              balance: Value(category.balance),
              budgeted: Value(category.budgeted),
              targetType: Value(category.targetType),
              targetNeedsWholeAmount: Value(category.targetNeedsWholeAmount),
              targetDay: Value(category.targetDay),
              targetCadence: Value(category.targetCadence),
              targetCadenceFrequency: Value(category.targetCadenceFrequency),
              targetCreationMonth: Value(category.targetCreationMonth),
              targetBalance: Value(category.targetBalance),
              targetMonth: Value(category.targetMonth),
              targetPercentageComplete: Value(category.targetPercentageComplete),
              targetMonthsToBudget: Value(category.targetMonthsToBudget),
              targetUnderFunded: Value(category.targetUnderFunded),
              targetOverallFunded: Value(category.targetOverallFunded),
              targetOverallLeft: Value(category.targetOverallLeft),
              order: Value(j),
            ),
          );
        }
      }

      await updateCategoryKnowledge(knowledge, budgetId: budgetId);
    });
  }

  Stream<List<CategoryGroup>> watchCategoryGroups({required String budgetId}) {
    final query =
        select(dbCategoryGroups).join([
            leftOuterJoin(
              dbCategories,
              dbCategories.categoryGroupId.equalsExp(dbCategoryGroups.uuid),
            ),
          ])
          ..where(dbCategoryGroups.budgetId.equals(budgetId))
          ..orderBy([
            OrderingTerm.asc(dbCategoryGroups.order),
            OrderingTerm.asc(dbCategories.order),
          ]);
    return query.watch().map((rows) {
      final collected = rows.parseJoin(
        dbCategoryGroups,
        (group) => CategoryGroup(
          id: group.uuid,
          name: group.name,
          isHidden: group.isHidden,
          isDeleted: group.isDeleted,
          categories: List.empty(),
        ),
        dbCategories,
        (_, p0) => Category(
          id: p0.uuid,
          categoryGroupId: p0.categoryGroupId,
          name: p0.name,
          isHidden: p0.isHidden,
          isDeleted: p0.isDeleted,
          activity: p0.activity,
          budgeted: p0.budgeted,
          balance: p0.balance,
          targetType: p0.targetType,
          targetNeedsWholeAmount: p0.targetNeedsWholeAmount,
          targetDay: p0.targetDay,
          targetCadence: p0.targetCadence,
          targetCadenceFrequency: p0.targetCadenceFrequency,
          targetCreationMonth: p0.targetCreationMonth,
          targetBalance: p0.targetBalance,
          targetMonth: p0.targetMonth,
          targetPercentageComplete: p0.targetPercentageComplete,
          targetMonthsToBudget: p0.targetMonthsToBudget,
          targetUnderFunded: p0.targetUnderFunded,
          targetOverallFunded: p0.targetOverallFunded,
          targetOverallLeft: p0.targetOverallLeft,
        ),
      );
      return collected.entries.map((e) {
        // Can we do this filtering in the query?
        final categories = e.value.whereNotDeleted().toList();
        return e.key.copyWith(categories: categories);
      }).toList();
    }).shareValue();
  }

  Stream<List<Category>> watchCategories({required String budgetId}) {
    return watchCategoryGroups(
      budgetId: budgetId,
    ).map((event) => event.categories.toList()).shareValue();
  }

  Future<void> updateCategoryKnowledge(int categoryKnowledge, {required String budgetId}) {
    return transaction(() async {
      await into(dbCategoryKnowledges).insertOnConflictUpdate(
        DbCategoryKnowledgesCompanion.insert(
          budgetId: budgetId,
          knowledge: categoryKnowledge,
          month: Value(today.toIso8601String()),
        ),
      );
    });
  }

  Future<MonthConstrainedKnowledge?> getCategoryKnowledge({required String budgetId}) {
    return transaction(() async {
      final query =
          select(dbCategoryKnowledges) //
            ..where((tbl) => tbl.budgetId.equals(budgetId));
      final knowledge = await query.getSingleOrNull();
      if (knowledge == null) {
        return null;
      }

      final month = knowledge.month.iso8601ToLocalDate();
      return (knowledge: knowledge.knowledge, month: month);
    });
  }
}
