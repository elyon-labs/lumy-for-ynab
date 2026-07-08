part of 'local_database.dart';

enum GoalType { saveAmount, debtPayoff, spendLessThan }

class DbGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get budgetId => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdDate => dateTime()();
  TextColumn get type => textEnum<GoalType>()();
}

class DbDebtPayoffGoalsMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  DateTimeColumn get targetDate => dateTime().nullable()();
}

class DbDebtPayoffGoalsAccounts extends Table {
  IntColumn get goalId => integer()();
  TextColumn get accountId => text()();
  IntColumn get originalBalance => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {goalId, accountId};
}
