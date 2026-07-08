part of 'local_database.dart';

class DbLegacySpendTrackers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nickName => text().nullable()();
  TextColumn get sourceId => text()();
  TextColumn get budgetId => text()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get type => textEnum<SpendTrackerType>()();
}

class DbQuerySpendTrackers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nickName => text().nullable()();
  IntColumn get conditionId => integer()();
  TextColumn get budgetId => text()();
  BoolColumn get isDeleted => boolean()();
}

class DbSpendTrackerConditions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  IntColumn get parentId => integer().nullable()();
}

class DbSpendTrackerTests extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get conditionId => integer()();
  TextColumn get testType => text()();
  TextColumn get testValue => text().nullable()();
}

class LegacySpendTracker {
  LegacySpendTracker({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.condition,
    this.nickName,
    this.isDeleted = false,
  });

  final int id;
  final String budgetId;
  final String name;
  final String? nickName;
  final bool isDeleted;

  final TransactionCondition condition;
}

extension LegacySpendTrackerTypeX on LegacySpendTracker {
  /// If a user has given a nickname to a tracker, use that instead of the name
  String get preferredName => nickName ?? name;
}

extension AppDatabaseSpendTrackersX on LocalDatabase {
  Future<bool> hasAnyQueriedSpendTrackers() async {
    final query = select(dbQuerySpendTrackers)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Stream<bool> watchHasAnyQueriedSpendTrackers() {
    final query = select(dbQuerySpendTrackers)
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..limit(1);
    return query.watch().map((rows) => rows.isNotEmpty).distinct();
  }

  Future<TransactionCondition> fetchCondition(int id) async {
    final dbCondition = await (select(
      dbSpendTrackerConditions,
    )..where((c) => c.id.equals(id))).getSingle();
    final dbSubConditions = await (select(
      dbSpendTrackerConditions,
    )..where((c) => c.parentId.equals(dbCondition.id))).get();
    final conditionType = ConditionType.values.firstWhere((e) => e.name == dbCondition.type);
    if (dbSubConditions.isNotEmpty) {
      final subConditions = await Future.wait(dbSubConditions.map((c) => fetchCondition(c.id)));
      return switch (conditionType) {
        ConditionType.and => And(subConditions),
        ConditionType.or => Or(subConditions),
        _ => throw UnimplementedError('Unknown condition type: $conditionType'),
      };
    } else {
      final dbTest = await (select(
        dbSpendTrackerTests,
      )..where((t) => t.conditionId.equals(dbCondition.id))).getSingle();
      final tnxTestType = TransactionTestType.values.firstWhere((e) => e.name == dbTest.testType);
      final dbTestValue = dbTest.testValue;
      final test = switch (tnxTestType) {
        TransactionTestType.hasFlagColor => HasFlagColor(dbTestValue!),
        TransactionTestType.hasPayeeId => HasPayeeId(dbTestValue!),
        TransactionTestType.hasCategoryId => HasCategoryId(dbTestValue!),
        TransactionTestType.hasCategoryGroupId => HasCategoryGroupId(dbTestValue!),
        TransactionTestType.hasAccountId => HasAccountId(dbTestValue!),
        TransactionTestType.hasMemoKeyword => HasMemoKeyword(dbTestValue!),
        TransactionTestType.isIncome => const IsIncome(),
        TransactionTestType.isInflow => const IsInflow(),
        TransactionTestType.isExpense => const IsExpense(),
        TransactionTestType.isOutflow => const IsOutflow(),
      };
      return switch (conditionType) {
        ConditionType.isTrue => IsTrue(test),
        ConditionType.isNotTrue => IsNotTrue(test),
        _ => throw UnimplementedError('Unknown condition type: $conditionType'),
      };
    }
  }

  Future<int> deleteSpendTracker(int id) {
    return transaction(() async {
      return await (delete(dbQuerySpendTrackers)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  Future<List<LegacySpendTracker>> fetchAllQueriedSpendTrackers() async {
    final query = select(dbQuerySpendTrackers)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(s) => OrderingTerm(expression: s.name)]);

    final first = await query.get();
    final futures = first.map((row) async {
      final condition = await fetchCondition(row.conditionId);
      return LegacySpendTracker(
        id: row.id,
        budgetId: row.budgetId,
        name: row.name,
        nickName: row.nickName,
        condition: condition,
        isDeleted: row.isDeleted,
      );
    });

    return Future.wait(futures);
  }
}
