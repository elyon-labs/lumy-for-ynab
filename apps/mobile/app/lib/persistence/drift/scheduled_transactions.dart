part of 'local_database.dart';

@TableIndex(name: 'idx_scheduled_txn', columns: {#budgetId, #isDeleted})
class DbScheduledTransactions extends Table {
  TextColumn get uuid => text()();
  TextColumn get budgetId => text()();
  IntColumn get amount => integer()();
  TextColumn get frequency => text()();
  DateTimeColumn get dateFirst => dateTime()();
  DateTimeColumn get dateNext => dateTime()();
  TextColumn get accountId => text()();
  TextColumn get accountName => text()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get payeeName => text().nullable()();
  TextColumn get payeeId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get categoryName => text().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get transferAccountId => text().nullable()();
  TextColumn get flagColor => textEnum<Flag>().nullable()();
  TextColumn get flagName => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

@TableIndex(
  name: 'idx_scheduled_sub_txn',
  columns: {#budgetId, #scheduledTransactionId, #isDeleted},
)
class DbScheduledSubTransactions extends Table {
  TextColumn get uuid => text()();
  TextColumn get scheduledTransactionId => text()();
  TextColumn get budgetId => text()();
  IntColumn get amount => integer()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get payeeId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get transferAccountId => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbScheduledTransactionKnowledges extends Table {
  TextColumn get budgetId => text()();
  IntColumn get knowledge => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabaseScheduledTransactionsX on LocalDatabase {
  Future<void> insertScheduledTransactions(
    List<ScheduledTransaction> transactions, {
    required String budgetId,
    required int knowledge,
  }) async {
    return await batch((b) async {
      final transactionStatements = <Insertable>[];
      final subTransactionStatements = <Insertable>[];
      for (final transaction in transactions) {
        transactionStatements.add(
          DbScheduledTransactionsCompanion.insert(
            uuid: transaction.id,
            budgetId: budgetId,
            frequency: transaction.frequency.name,
            dateFirst: DateTime.parse(transaction.dateFirst),
            dateNext: DateTime.parse(transaction.dateNext),
            amount: transaction.amount,
            accountId: transaction.accountId,
            accountName: transaction.accountName,
            isDeleted: transaction.isDeleted,
            payeeName: Value(transaction.payeeName),
            payeeId: Value(transaction.payeeId),
            categoryId: Value(transaction.categoryId),
            categoryName: Value(transaction.categoryName),
            memo: Value(transaction.memo),
            transferAccountId: Value(transaction.transferAccountId),
            flagColor: Value(
              transaction.flagColor == null || transaction.flagColor!.isEmpty
                  ? null
                  : Flag.values.byName(transaction.flagColor!),
            ),
            flagName: Value(transaction.flagName),
          ),
        );
        for (final subTransaction in transaction.subTransactions) {
          subTransactionStatements.add(
            DbScheduledSubTransactionsCompanion.insert(
              uuid: subTransaction.id,
              scheduledTransactionId: transaction.id,
              budgetId: budgetId,
              amount: subTransaction.amount,
              isDeleted: subTransaction.isDeleted,
              payeeId: Value(subTransaction.payeeId),
              categoryId: Value(subTransaction.categoryId),
              memo: Value(subTransaction.memo),
              transferAccountId: Value(subTransaction.transferAccountId),
            ),
          );
        }
      }
      b
        ..insertAllOnConflictUpdate(dbScheduledTransactions, transactionStatements)
        ..insertAllOnConflictUpdate(dbScheduledSubTransactions, subTransactionStatements)
        ..insertAllOnConflictUpdate(dbScheduledTransactionKnowledges, [
          DbScheduledTransactionKnowledgesCompanion.insert(
            budgetId: budgetId,
            knowledge: knowledge,
          ),
        ]);
    });
  }

  Stream<List<ScheduledTransaction>> watchScheduledTransactions({required String budgetId}) {
    final query =
        select(dbScheduledTransactions).join([
            leftOuterJoin(
              dbScheduledSubTransactions,
              dbScheduledSubTransactions.scheduledTransactionId.equalsExp(
                dbScheduledTransactions.uuid,
              ),
            ),
          ])
          ..where(
            dbScheduledTransactions.budgetId.equals(budgetId) &
                dbScheduledTransactions.isDeleted.equals(false),
          )
          ..orderBy([OrderingTerm.desc(dbScheduledTransactions.dateNext)]);
    return query.watch().map((rows) {
      final collected = rows.parseJoin(
        dbScheduledTransactions,
        (p0) => ScheduledTransaction(
          id: p0.uuid,
          amount: p0.amount,
          frequency: ScheduledTransactionFrequency.values.byName(p0.frequency),
          dateFirst: p0.dateFirst.toIso8601String(),
          dateNext: p0.dateNext.toIso8601String(),
          accountId: p0.accountId,
          accountName: p0.accountName,
          isDeleted: p0.isDeleted,
          payeeName: p0.payeeName,
          payeeId: p0.payeeId,
          categoryId: p0.categoryId,
          categoryName: p0.categoryName,
          memo: p0.memo,
          transferAccountId: p0.transferAccountId,
          flagColor: p0.flagColor?.name,
          flagName: p0.flagName,
          subTransactions: List.empty(),
        ),
        dbScheduledSubTransactions,
        (parent, p0) {
          return ScheduledSubTransaction(
            id: p0.uuid,
            scheduledTransactionId: p0.scheduledTransactionId,
            amount: p0.amount,
            isDeleted: p0.isDeleted,
            payeeId: p0.payeeId,
            categoryId: p0.categoryId,
            memo: p0.memo,
            transferAccountId: p0.transferAccountId,
          );
        },
      );
      return collected.entries
          .map((e) => e.key.copyWith(subTransactions: e.value.toList()))
          .toList();
    }).shareValue();
  }

  Future<void> updateScheduledTransactionKnowledge(int knowledge, {required String budgetId}) {
    return transaction(() async {
      await into(dbScheduledTransactionKnowledges).insertOnConflictUpdate(
        DbScheduledTransactionKnowledgesCompanion.insert(budgetId: budgetId, knowledge: knowledge),
      );
    });
  }

  Future<int?> getScheduledTransactionKnowledge({required String budgetId}) {
    return transaction(() async {
      final query = select(dbScheduledTransactionKnowledges)
        ..where((tbl) => tbl.budgetId.equals(budgetId));
      final knowledge = await query.getSingleOrNull();
      return knowledge?.knowledge;
    });
  }

  Future<void> deleteScheduledTransactionData() async {
    await transaction(() async {
      await delete(dbScheduledTransactions).go();
      await delete(dbScheduledSubTransactions).go();
      await delete(dbScheduledTransactionKnowledges).go();
    });
  }
}
