part of 'local_database.dart';

@TableIndex(name: 'idx_txn', columns: {#budgetId, #isDeleted})
@TableIndex(name: 'idx_txn_budget_deleted_date', columns: {#budgetId, #isDeleted, #date})
class DbTransactions extends Table {
  TextColumn get uuid => text()();
  TextColumn get budgetId => text()();
  IntColumn get amount => integer()();
  TextColumn get date => text()();
  TextColumn get accountId => text()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get payeeName => text().nullable()();
  TextColumn get payeeId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get categoryName => text().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get transferAccountId => text().nullable()();
  TextColumn get transferTransactionId => text().nullable()();
  TextColumn get matchedTransactionId => text().nullable()();
  TextColumn get importId => text().nullable()();
  TextColumn get flagColor => textEnum<Flag>().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

@TableIndex(name: 'idx_sub_txn', columns: {#budgetId, #transactionId, #isDeleted})
@TableIndex(name: 'idx_sub_txn_join', columns: {#transactionId, #isDeleted})
class DbSubTransactions extends Table {
  TextColumn get uuid => text()();
  TextColumn get transactionId => text()();
  TextColumn get budgetId => text()();
  IntColumn get amount => integer()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get payeeName => text().nullable()();
  TextColumn get payeeId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get categoryName => text().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get transferAccountId => text().nullable()();
  TextColumn get transferTransactionId => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbTransactionKnowledges extends Table {
  TextColumn get budgetId => text()();
  IntColumn get knowledge => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabaseTransactionsX on LocalDatabase {
  Future<void> insertTransactions(
    List<PastTransaction> transactions, {
    required String budgetId,
    required int knowledge,
  }) async {
    await transaction(() async {
      await _insertTransactions(transactions, budgetId: budgetId, knowledge: knowledge);
    });
  }

  Future<void> replaceTransactions(
    List<PastTransaction> transactions, {
    required String budgetId,
    required int knowledge,
  }) async {
    await transaction(() async {
      await (delete(dbSubTransactions)..where((table) => table.budgetId.equals(budgetId))).go();
      await (delete(dbTransactions)..where((table) => table.budgetId.equals(budgetId))).go();
      await _insertTransactions(transactions, budgetId: budgetId, knowledge: knowledge);
    });
  }

  Future<void> _insertTransactions(
    List<PastTransaction> transactions, {
    required String budgetId,
    required int knowledge,
  }) async {
    final transactionStatements = <Insertable>[];
    final subTransactionStatements = <Insertable>[];
    for (final transaction in transactions) {
      transactionStatements.add(
        DbTransactionsCompanion.insert(
          uuid: transaction.id,
          budgetId: budgetId,
          amount: transaction.amount,
          date: transaction.date,
          accountId: transaction.accountId,
          isDeleted: transaction.isDeleted,
          payeeName: Value(transaction.payeeName),
          payeeId: Value(transaction.payeeId),
          categoryId: Value(transaction.categoryId),
          categoryName: Value(transaction.categoryName),
          memo: Value(transaction.memo),
          transferAccountId: Value(transaction.transferAccountId),
          transferTransactionId: Value(transaction.transferTransactionId),
          matchedTransactionId: Value(transaction.matchedTransactionId),
          importId: Value(transaction.importId),
          flagColor: Value(
            transaction.flagColor == null || transaction.flagColor!.isEmpty
                ? null
                : Flag.values.byName(transaction.flagColor!),
          ),
        ),
      );
      for (final subTransaction in transaction.subTransactions) {
        subTransactionStatements.add(
          DbSubTransactionsCompanion.insert(
            uuid: subTransaction.id,
            transactionId: transaction.id,
            budgetId: budgetId,
            amount: subTransaction.amount,
            isDeleted: subTransaction.isDeleted,
            payeeName: Value(subTransaction.payeeName),
            payeeId: Value(subTransaction.payeeId),
            categoryId: Value(subTransaction.categoryId),
            categoryName: Value(subTransaction.categoryName),
            memo: Value(subTransaction.memo),
            transferAccountId: Value(subTransaction.transferAccountId),
            transferTransactionId: Value(subTransaction.transferTransactionId),
          ),
        );
      }
    }
    await batch((batch) {
      if (transactionStatements.isNotEmpty) {
        batch.insertAllOnConflictUpdate(dbTransactions, transactionStatements);
      }
      if (subTransactionStatements.isNotEmpty) {
        batch.insertAllOnConflictUpdate(dbSubTransactions, subTransactionStatements);
      }
      batch.insertAllOnConflictUpdate(dbTransactionKnowledges, [
        DbTransactionKnowledgesCompanion.insert(budgetId: budgetId, knowledge: knowledge),
      ]);
    });
  }

  Stream<List<PastTransaction>> watchTransactions({required String budgetId}) {
    final query =
        select(dbTransactions).join([
            leftOuterJoin(
              dbSubTransactions,
              dbSubTransactions.transactionId.equalsExp(dbTransactions.uuid) &
                  dbSubTransactions.isDeleted.equals(false),
            ),
          ])
          ..where(dbTransactions.budgetId.equals(budgetId) & dbTransactions.isDeleted.equals(false))
          ..orderBy([OrderingTerm.desc(dbTransactions.date)]);
    return query.watch().map((rows) {
      final collected = rows.parseJoin(
        dbTransactions,
        (p0) => PastTransaction(
          id: p0.uuid,
          amount: p0.amount,
          date: p0.date,
          accountId: p0.accountId,
          isDeleted: p0.isDeleted,
          payeeName: p0.payeeName,
          payeeId: p0.payeeId,
          categoryId: p0.categoryId,
          categoryName: p0.categoryName,
          memo: p0.memo,
          transferAccountId: p0.transferAccountId,
          transferTransactionId: p0.transferTransactionId,
          matchedTransactionId: p0.matchedTransactionId,
          importId: p0.importId,
          flagColor: p0.flagColor?.name,
          subTransactions: List.empty(),
        ),
        dbSubTransactions,
        (parent, p0) {
          return SubTransaction(
            id: p0.uuid,
            transactionId: p0.transactionId,
            amount: p0.amount,
            isDeleted: p0.isDeleted,
            payeeName: p0.payeeName,
            payeeId: p0.payeeId,
            categoryId: p0.categoryId,
            categoryName: p0.categoryName,
            memo: p0.memo,
            transferAccountId: p0.transferAccountId,
            transferTransactionId: p0.transferTransactionId,
          );
        },
      );
      return collected.entries
          .map((e) => e.key.copyWith(subTransactions: e.value.toList()))
          .toList();
    }).shareValue();
  }

  Future<void> updateTransactionKnowledge(int transactionKnowledge, {required String budgetId}) {
    return transaction(() async {
      await into(dbTransactionKnowledges).insertOnConflictUpdate(
        DbTransactionKnowledgesCompanion.insert(
          budgetId: budgetId,
          knowledge: transactionKnowledge,
        ),
      );
    });
  }

  Future<int?> getTransactionKnowledge({required String budgetId}) {
    return transaction(() async {
      final query = select(dbTransactionKnowledges)..where((tbl) => tbl.budgetId.equals(budgetId));
      final knowledge = await query.getSingleOrNull();
      return knowledge?.knowledge;
    });
  }

  Future<void> deleteTransactionKnowledges() async {
    await transaction(() async {
      await delete(dbTransactionKnowledges).go();
    });
  }

  Future<void> deleteTransactionData() async {
    await transaction(() async {
      await delete(dbTransactions).go();
      await delete(dbSubTransactions).go();
      await delete(dbTransactionKnowledges).go();
    });
  }
}
