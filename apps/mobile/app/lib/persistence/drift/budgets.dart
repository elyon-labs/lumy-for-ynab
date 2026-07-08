part of 'local_database.dart';

class DbBudgets extends Table {
  TextColumn get uuid => text()();
  TextColumn get name => text()();
  TextColumn get firstMonth => text().nullable()();
  TextColumn get lastMonth => text().nullable()();
  TextColumn get lastModifiedOn => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {uuid};
}

class DbCurrencyFormats extends Table {
  TextColumn get budgetId => text()();
  TextColumn get isoCode => text()();
  IntColumn get decimalDigits => integer()();
  TextColumn get decimalSeparator => text()();
  BoolColumn get isSymbolFirst => boolean()();
  TextColumn get groupSeparator => text()();
  TextColumn get currencySymbol => text()();
  BoolColumn get shouldDisplaySymbol => boolean()();
  TextColumn get exampleFormat => text()();

  @override
  Set<Column<Object>>? get primaryKey => {budgetId};
}

extension AppDatabaseBudgetsX on LocalDatabase {
  Future<void> insertBudgets(List<Budget> budgets) async {
    return await transaction(() async {
      for (final budget in budgets) {
        await into(dbBudgets).insertOnConflictUpdate(
          DbBudgetsCompanion.insert(
            uuid: budget.id,
            name: budget.name,
            firstMonth: Value(budget.firstMonth),
            lastMonth: Value(budget.lastMonth),
            lastModifiedOn: Value(budget.lastModifiedOn),
          ),
        );
        final currencyFormat = budget.currencyFormat;
        if (currencyFormat != null) {
          await into(dbCurrencyFormats).insertOnConflictUpdate(
            DbCurrencyFormatsCompanion.insert(
              budgetId: budget.id,
              isoCode: currencyFormat.isoCode,
              decimalDigits: currencyFormat.decimalDigits,
              decimalSeparator: currencyFormat.decimalSeparator,
              isSymbolFirst: currencyFormat.isSymbolFirst,
              groupSeparator: currencyFormat.groupSeparator,
              currencySymbol: currencyFormat.currencySymbol,
              shouldDisplaySymbol: currencyFormat.shouldDisplaySymbol,
              exampleFormat: currencyFormat.exampleFormat,
            ),
          );
        }
      }
    });
  }

  Stream<List<Budget>> watchBudgets() {
    final query = select(dbBudgets).join([
      leftOuterJoin(dbCurrencyFormats, dbCurrencyFormats.budgetId.equalsExp(dbBudgets.uuid)),
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        final budget = row.readTable(dbBudgets);
        final currencyFormat = row.readTableOrNull(dbCurrencyFormats);
        return Budget(
          id: budget.uuid,
          name: budget.name,
          lastModifiedOn: budget.lastModifiedOn,
          firstMonth: budget.firstMonth,
          lastMonth: budget.lastMonth,
          currencyFormat: currencyFormat != null
              ? CurrencyFormat(
                  isoCode: currencyFormat.isoCode,
                  decimalDigits: currencyFormat.decimalDigits,
                  decimalSeparator: currencyFormat.decimalSeparator,
                  isSymbolFirst: currencyFormat.isSymbolFirst,
                  groupSeparator: currencyFormat.groupSeparator,
                  currencySymbol: currencyFormat.currencySymbol,
                  shouldDisplaySymbol: currencyFormat.shouldDisplaySymbol,
                  exampleFormat: currencyFormat.exampleFormat,
                )
              : null,
        );
      }).toList();
    });
  }

  Future<Budget?> getBudgetById(String id) {
    return transaction(() async {
      final budget = await (select(
        dbBudgets,
      )..where((tbl) => tbl.uuid.equals(id))).getSingleOrNull();
      if (budget == null) return null;
      final currencyFormat = await (select(
        dbCurrencyFormats,
      )..where((tbl) => tbl.budgetId.equals(id))).getSingleOrNull();
      return Budget(
        id: budget.uuid,
        name: budget.name,
        lastModifiedOn: budget.lastModifiedOn,
        firstMonth: budget.firstMonth,
        lastMonth: budget.lastMonth,
        currencyFormat: currencyFormat != null
            ? CurrencyFormat(
                isoCode: currencyFormat.isoCode,
                decimalDigits: currencyFormat.decimalDigits,
                decimalSeparator: currencyFormat.decimalSeparator,
                isSymbolFirst: currencyFormat.isSymbolFirst,
                groupSeparator: currencyFormat.groupSeparator,
                currencySymbol: currencyFormat.currencySymbol,
                shouldDisplaySymbol: currencyFormat.shouldDisplaySymbol,
                exampleFormat: currencyFormat.exampleFormat,
              )
            : null,
      );
    });
  }
}
