part of 'local_database.dart';

class DbPayees extends Table {
  TextColumn get uuid => text()();
  TextColumn get budgetId => text()();
  TextColumn get name => text()();
  BoolColumn get deleted => boolean()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbPayeeKnowledges extends Table {
  TextColumn get budgetId => text()();
  IntColumn get knowledge => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabasePayeesX on LocalDatabase {
  Future<void> insertPayees(
    List<Payee> payees, {
    required String budgetId,
    required int knowledge,
  }) async {
    return await transaction(() async {
      for (final payee in payees) {
        await into(dbPayees).insertOnConflictUpdate(
          DbPayeesCompanion.insert(
            uuid: payee.id,
            budgetId: budgetId,
            name: payee.name,
            deleted: payee.isDeleted,
          ),
        );
      }
      await updatePayeeKnowledge(knowledge, budgetId: budgetId);
    });
  }

  Stream<List<Payee>> watchPayees({required String budgetId}) {
    final query = select(dbPayees)
      ..where((payee) => payee.budgetId.equals(budgetId) & payee.deleted.equals(false))
      ..orderBy([(s) => OrderingTerm(expression: s.name)]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return Payee(id: row.uuid, name: row.name, isDeleted: row.deleted);
      }).toList();
    }).shareValue();
  }

  Future<void> updatePayeeKnowledge(int payeeKnowledge, {required String budgetId}) {
    return transaction(() async {
      await into(dbPayeeKnowledges).insertOnConflictUpdate(
        DbPayeeKnowledgesCompanion.insert(budgetId: budgetId, knowledge: payeeKnowledge),
      );
    });
  }

  Future<int?> getPayeeKnowledge({required String budgetId}) {
    return transaction(() async {
      final query = select(dbPayeeKnowledges)..where((tbl) => tbl.budgetId.equals(budgetId));
      final knowledge = await query.getSingleOrNull();

      return knowledge?.knowledge;
    });
  }
}
