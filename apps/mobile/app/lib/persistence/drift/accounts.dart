part of 'local_database.dart';

class DbAccounts extends Table {
  TextColumn get uuid => text()();
  TextColumn get budgetId => text()();
  IntColumn get balance => integer()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<AccountType>()();
  BoolColumn get isOnBudget => boolean()();
  BoolColumn get isClosed => boolean()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbAccountInterestRates extends Table {
  TextColumn get budgetId => text()();
  TextColumn get accountId => text()();
  TextColumn get month => text()();
  IntColumn get interestRate => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId, accountId, month};
}

class DbAccountMinimumPayments extends Table {
  TextColumn get budgetId => text()();
  TextColumn get accountId => text()();
  TextColumn get month => text()();
  IntColumn get mininumPayment => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId, accountId, month};
}

class DbAccountEscrowAmounts extends Table {
  TextColumn get budgetId => text()();
  TextColumn get accountId => text()();
  TextColumn get month => text()();
  IntColumn get escrowPayment => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId, accountId, month};
}

class DbAccountKnowledges extends Table {
  TextColumn get budgetId => text()();
  IntColumn get knowledge => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabaseAccountsX on LocalDatabase {
  Future<void> insertAccounts(
    List<Account> accounts, {
    required String budgetId,
    required int knowledge,
  }) async {
    return await transaction(() async {
      for (final account in accounts) {
        await into(dbAccounts).insertOnConflictUpdate(
          DbAccountsCompanion.insert(
            uuid: account.id,
            budgetId: budgetId,
            balance: account.balance,
            name: account.name,
            type: account.type,
            isOnBudget: account.isOnBudget,
            isClosed: account.isClosed,
            isDeleted: account.isDeleted,
          ),
        );

        for (final entry in account.debtInterestRates.entries) {
          await into(dbAccountInterestRates).insertOnConflictUpdate(
            DbAccountInterestRatesCompanion.insert(
              budgetId: budgetId,
              accountId: account.id,
              month: entry.key,
              interestRate: entry.value,
            ),
          );
        }

        for (final entry in account.debtMinimumPayments.entries) {
          await into(dbAccountMinimumPayments).insertOnConflictUpdate(
            DbAccountMinimumPaymentsCompanion.insert(
              budgetId: budgetId,
              accountId: account.id,
              month: entry.key,
              mininumPayment: entry.value,
            ),
          );
        }

        for (final entry in account.debtEscrowAmounts.entries) {
          await into(dbAccountEscrowAmounts).insertOnConflictUpdate(
            DbAccountEscrowAmountsCompanion.insert(
              budgetId: budgetId,
              accountId: account.id,
              month: entry.key,
              escrowPayment: entry.value,
            ),
          );
        }
      }
      await into(dbAccountKnowledges).insertOnConflictUpdate(
        DbAccountKnowledgesCompanion.insert(budgetId: budgetId, knowledge: knowledge),
      );
    });
  }

  Stream<List<Account>> watchAccounts({required String budgetId}) {
    final query = select(dbAccounts).join([
      leftOuterJoin(
        dbAccountInterestRates,
        dbAccountInterestRates.accountId.equalsExp(dbAccounts.uuid),
      ),
      leftOuterJoin(
        dbAccountMinimumPayments,
        dbAccountMinimumPayments.accountId.equalsExp(dbAccounts.uuid),
      ),
      leftOuterJoin(
        dbAccountEscrowAmounts,
        dbAccountEscrowAmounts.accountId.equalsExp(dbAccounts.uuid),
      ),
    ])..where(dbAccounts.budgetId.equals(budgetId) & dbAccounts.isDeleted.equals(false));

    return query.watch().map((rows) {
      // Handle JOIN with dbAccountInterestRates
      final parsedJoinWithInterestRates = rows.parseJoin(
        dbAccounts,
        (p0) {
          return Account(
            id: p0.uuid,
            name: p0.name,
            isOnBudget: p0.isOnBudget,
            isClosed: p0.isClosed,
            isDeleted: p0.isDeleted,
            type: p0.type,
            balance: p0.balance,
            debtInterestRates: const {},
            debtMinimumPayments: const {},
            debtEscrowAmounts: const {},
          );
        },
        dbAccountInterestRates,
        (_, p0) => MapEntry(p0.month, p0.interestRate),
      );
      final withInterestRates = parsedJoinWithInterestRates.entries
          .map((e) => e.key.copyWith(debtInterestRates: Map.fromEntries(e.value)))
          .toList();

      // Handle JOIN with dbAccountMinimumPayments
      final parsedJoinWithMinimumPayments = rows.parseJoin(
        dbAccounts,
        // Return the one we already created with interestRates
        (p0) => withInterestRates.singleWhere((f) => f.id == p0.uuid),
        dbAccountMinimumPayments,
        (_, p0) => MapEntry(p0.month, p0.mininumPayment),
      );
      final withMinimumPayments = parsedJoinWithMinimumPayments.entries
          .map((e) => e.key.copyWith(debtMinimumPayments: Map.fromEntries(e.value)))
          .toList();

      // Handle JOIN with dbAccountEscrowAmounts
      final parsedJoinWithEscrowAmounts = rows.parseJoin(
        dbAccounts,
        (p0) => withMinimumPayments.singleWhere((f) => f.id == p0.uuid),
        dbAccountEscrowAmounts,
        (_, p0) => MapEntry(p0.month, p0.escrowPayment),
      );

      return parsedJoinWithEscrowAmounts.entries
          .map((e) => e.key.copyWith(debtEscrowAmounts: Map.fromEntries(e.value)))
          .toList();
    }).shareValue();
  }

  Future<void> updateAccountKnowledge(int accountKnowledge, {required String budgetId}) {
    return transaction(() async {
      await into(dbAccountKnowledges).insertOnConflictUpdate(
        DbAccountKnowledgesCompanion.insert(budgetId: budgetId, knowledge: accountKnowledge),
      );
    });
  }

  Future<int?> getAccountKnowledge({required String budgetId}) {
    return transaction(() async {
      final query = select(dbAccountKnowledges)..where((tbl) => tbl.budgetId.equals(budgetId));
      final knowledge = await query.getSingleOrNull();
      return knowledge?.knowledge;
    });
  }
}
