part of 'local_database.dart';

class DbFrugalMonths extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get budgetId => text()();
  TextColumn get month => text()();
  IntColumn get targetAmount => integer()();
  BoolColumn get isDeleted => boolean()();
}

class DbFrugalMonthCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get frugalMonthId => integer()();
  TextColumn get categoryId => text()();
}

class DbFrugalMonthAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get frugalMonthId => integer()();
  TextColumn get accountId => text()();
}

class LegacyFrugalMonth {
  LegacyFrugalMonth({
    required this.id,
    required this.budgetId,
    required this.month,
    required this.targetAmount,
    required this.categoryIds,
    required this.accountIds,
  });

  final int id;
  final String budgetId;
  final LocalDate month;
  final int targetAmount;
  final List<String> categoryIds;
  final List<String> accountIds;
}

extension FrugalMonthsX on LocalDatabase {
  Future<bool> hasAnyFrugalMonths() async {
    final query = select(dbFrugalMonths)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Stream<bool> watchHasAnyFrugalMonths() {
    final query = select(dbFrugalMonths)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);
    return query.watch().map((rows) => rows.isNotEmpty).distinct();
  }

  Future<int> deleteFrugalMonth(int id) {
    return transaction(() async {
      return await (delete(dbFrugalMonths)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  Future<List<LegacyFrugalMonth>> fetchAllFrugalMonths() async {
    final query = select(dbFrugalMonths).join([
      leftOuterJoin(
        dbFrugalMonthCategories,
        dbFrugalMonthCategories.frugalMonthId.equalsExp(dbFrugalMonths.id),
      ),
      leftOuterJoin(
        dbFrugalMonthAccounts,
        dbFrugalMonthAccounts.frugalMonthId.equalsExp(dbFrugalMonths.id),
      ),
    ])..where(dbFrugalMonths.isDeleted.equals(false));

    final results = await query.get();
    final categoryIds = <DbFrugalMonth, Set<String>>{};
    final accountIds = <DbFrugalMonth, Set<String>>{};
    for (final row in results) {
      final view = row.readTable(dbFrugalMonths);
      final categoryId = row.readTableOrNull(dbFrugalMonthCategories)?.categoryId;
      final accountId = row.readTableOrNull(dbFrugalMonthAccounts)?.accountId;
      if (categoryId != null) {
        categoryIds.putIfAbsent(view, () => {}).add(categoryId);
      }
      if (accountId != null) {
        accountIds.putIfAbsent(view, () => {}).add(accountId);
      }
    }
    final set = <DbFrugalMonth>{...categoryIds.keys, ...accountIds.keys};
    return set.map((view) {
      return LegacyFrugalMonth(
        id: view.id,
        budgetId: view.budgetId,
        month: LocalDate.dateTime(DateTime.parse(view.month)),
        targetAmount: view.targetAmount,
        categoryIds: categoryIds[view]?.toList() ?? [],
        accountIds: accountIds[view]?.toList() ?? [],
      );
    }).toList();
  }
}
