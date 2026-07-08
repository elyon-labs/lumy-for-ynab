part of 'local_database.dart';

class DbMonths extends Table {
  TextColumn get budgetId => text()();
  TextColumn get month => text()();
  TextColumn get note => text().nullable()();
  IntColumn get income => integer()();
  IntColumn get budgeted => integer()();
  IntColumn get activity => integer()();
  IntColumn get toBeBudgeted => integer()();
  IntColumn get ageOfMoney => integer().nullable()();
  BoolColumn get deleted => boolean()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId, month};
}

class DbMonthKnowledges extends Table {
  TextColumn get budgetId => text()();
  IntColumn get knowledge => integer()();
  TextColumn get month => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabaseMonthsX on LocalDatabase {
  Future<void> updateCurrentMonth(SingleMonth month, {required String budgetId}) async {
    await transaction(() async {
      await into(dbMonths).insertOnConflictUpdate(
        DbMonthsCompanion.insert(
          budgetId: budgetId,
          month: month.month,
          note: Value(month.note),
          income: month.income,
          budgeted: month.budgeted,
          activity: month.activity,
          toBeBudgeted: month.toBeBudgeted,
          ageOfMoney: Value(month.ageOfMoney),
          deleted: month.isDeleted,
        ),
      );

      for (final category in month.categories) {
        await into(dbCategories).insertOnConflictUpdate(
          DbCategoriesCompanion.insert(
            uuid: category.id,
            categoryGroupId: category.categoryGroupId,
            budgetId: budgetId,
            name: category.name,
            isHidden: category.isHidden,
            isDeleted: category.isDeleted,
            activity: Value(category.activity),
            balance: Value(category.balance),
            budgeted: Value(category.budgeted),
          ),
        );
      }
    });
  }

  Future<void> insertMonths(
    List<Month> months, {
    required String budgetId,
    required int knowledge,
  }) async {
    await transaction(() async {
      for (final month in months) {
        await into(dbMonths).insertOnConflictUpdate(
          DbMonthsCompanion.insert(
            budgetId: budgetId,
            month: month.month,
            note: Value(month.note),
            income: month.income,
            budgeted: month.budgeted,
            activity: month.activity,
            toBeBudgeted: month.toBeBudgeted,
            ageOfMoney: Value(month.ageOfMoney),
            deleted: month.isDeleted,
          ),
        );
      }
      await updateMonthKnowledge(knowledge, budgetId: budgetId);
    });
  }

  Stream<List<Month>> watchMonths({required String budgetId}) {
    final query = select(dbMonths)
      ..where((month) => month.budgetId.equals(budgetId) & month.deleted.equals(false));
    return query.watch().map((rows) {
      return rows.map((row) {
        return Month(
          month: row.month,
          note: row.note,
          income: row.income,
          budgeted: row.budgeted,
          activity: row.activity,
          toBeBudgeted: row.toBeBudgeted,
          ageOfMoney: row.ageOfMoney,
          isDeleted: row.deleted,
        );
      }).toList();
    }).shareValue();
  }

  Future<void> updateMonthKnowledge(int monthKnowledge, {required String budgetId}) {
    return transaction(() async {
      await into(dbMonthKnowledges).insertOnConflictUpdate(
        DbMonthKnowledgesCompanion.insert(
          budgetId: budgetId,
          knowledge: monthKnowledge,
          month: Value(today.toIso8601String()),
        ),
      );
    });
  }

  Future<MonthConstrainedKnowledge?> getMonthKnowledge({required String budgetId}) {
    return transaction(() async {
      final query =
          select(dbMonthKnowledges) //
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
