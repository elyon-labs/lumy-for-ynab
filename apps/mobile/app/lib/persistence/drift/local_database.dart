import 'package:blackbird/blackbird.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../features/category_views/domain/models/legacy_category_view.dart';
import '../../features/spend_tracker/domain/models/spend_tracker.dart';
import '../../features/spend_tracker/domain/models/transaction_conditions.dart';
import '../../utils/_local_date.dart';
import '../../utils/_string.dart';
import '../../ynab_api/_category.dart';
import '../../ynab_api/_category_group.dart';
import '../../ynab_api/server_knowledge.dart';
import 'schema_versions.dart';

part 'accounts.dart';
part 'budgets.dart';
part 'category_groups.dart';
part 'category_views.dart';
part 'local_database.g.dart';
part 'frugal_months.dart';
part 'goals.dart';
part 'months.dart';
part 'payees.dart';
part 'scheduled_transactions.dart';
part 'spend_trackers.dart';
part 'transactions.dart';

@DriftDatabase(
  tables: [
    DbBudgets,
    DbCurrencyFormats,
    DbAccounts,
    DbAccountInterestRates,
    DbAccountMinimumPayments,
    DbAccountEscrowAmounts,
    DbPayees,
    DbCategoryGroups,
    DbCategories,
    DbTransactions,
    DbSubTransactions,
    DbScheduledTransactions,
    DbScheduledSubTransactions,
    DbMonths,
    DbAccountKnowledges,
    DbCategoryKnowledges,
    DbPayeeKnowledges,
    DbTransactionKnowledges,
    DbScheduledTransactionKnowledges,
    DbMonthKnowledges,
    DbCategoryViews,
    DbCategoryViewCategories,
    DbCategoryViewCategoryGroups,
    DbLegacySpendTrackers,
    DbQuerySpendTrackers,
    DbSpendTrackerConditions,
    DbSpendTrackerTests,
    DbFrugalMonths,
    DbFrugalMonthCategories,
    DbFrugalMonthAccounts,
    DbGoals,
    DbDebtPayoffGoalsMetadata,
    DbDebtPayoffGoalsAccounts,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(super.e);

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await transaction(() async {
            // Added DbQuerySpendTrackers, DbSpendTrackerConditions,
            // and DbSpendTrackerTests, and renamed DbSpendTrackers to
            // DbLegacySpendTrackers.
            await m.renameTable(schema.dbLegacySpendTrackers, 'db_spend_trackers');
            await m.createTable(schema.dbQuerySpendTrackers);
            await m.createTable(schema.dbSpendTrackerConditions);
            await m.createTable(schema.dbSpendTrackerTests);
          });
        },
        from2To3: (m, schema) async {
          await transaction(() async {
            // Delete all legacy trackers.
            await delete(schema.dbLegacySpendTrackers).go();
          });
        },
        from3To4: (m, schema) async {
          await transaction(() async {
            // Added DbFrugalMonths, DbFrugalMonthCategories, DbFrugalMonthAccounts.
            await m.createTable(schema.dbFrugalMonths);
            await m.createTable(schema.dbFrugalMonthCategories);
            await m.createTable(schema.dbFrugalMonthAccounts);
          });
        },
        from4To5: (m, schema) async {
          await transaction(() async {
            // Added DbMonths and DbMonthKnowledges.
            // Added current month columns to DbCategories.
            await m.createTable(schema.dbMonths);
            await m.createTable(schema.dbMonthKnowledges);
            await m.addColumn(schema.dbCategories, schema.dbCategories.balance);
            await m.addColumn(schema.dbCategories, schema.dbCategories.activity);
            await m.addColumn(schema.dbCategories, schema.dbCategories.budgeted);
            // Delete all category knowledges so they're refetched.
            await delete(dbCategoryKnowledges).go();
          });
        },
        from5To6: (m, schema) async {
          await transaction(() async {
            // Added month column to DbCategoryKnowledges and DbMonthKnowledges.
            await m.addColumn(schema.dbCategoryKnowledges, schema.dbCategoryKnowledges.month);
            await m.addColumn(schema.dbMonthKnowledges, schema.dbMonthKnowledges.month);
          });
        },
        from6To7: (m, schema) async {
          await transaction(() async {
            // Removed `type` from DbCategoryViews, added DbCategoryViewCategoryGroups.
            // ignore: experimental_member_use
            await m.alterTable(TableMigration(schema.dbCategoryViews));
            await m.createTable(schema.dbCategoryViewCategoryGroups);
          });
        },
        from7To8: (m, schema) async {
          await transaction(() async {
            // Added DbAccountInterestRates, DbAccountMinimumPayments, and DbAccountEscrowAmounts.
            await m.createTable(schema.dbAccountInterestRates);
            await m.createTable(schema.dbAccountEscrowAmounts);
            await m.createTable(schema.dbAccountMinimumPayments);

            // Added `is_deleted` column to DbAccounts.
            // Since we want to re-fetch, just drop and re-create.
            await m.drop(schema.dbAccounts);
            await m.createTable(schema.dbAccounts);

            // Delete all account knowledges so they're refetched.
            await delete(schema.dbAccountKnowledges).go();
          });
        },
        from8To9: (m, schema) async {
          await transaction(() async {
            // Added DbGoals and DbDebtPayoffGoalsMetadata.
            await m.createTable(schema.dbGoals);
            await m.createTable(schema.dbDebtPayoffGoalsMetadata);
          });
        },
        from9To10: (m, schema) async {
          await transaction(() async {
            // Removed `account_ids` from DbDebtPayoffGoalsMetadata.
            // ignore: experimental_member_use
            await m.alterTable(TableMigration(schema.dbDebtPayoffGoalsMetadata));
            // Added DbDebtPayoffGoalsAccounts.
            await m.createTable(schema.dbDebtPayoffGoalsAccounts);
          });
        },
        from10To11: (m, schema) async {
          await transaction(() async {
            // Added target columns to DbCategories.
            // Since we want to re-fetch, just drop and re-create.
            await m.drop(schema.dbCategories);
            await m.createTable(schema.dbCategories);
            // Delete all category info so they're refetched.
            await delete(schema.dbCategoryKnowledges).go();
          });
        },
        from11To12: (m, schema) async {
          await transaction(() async {
            // Added DbScheduledTransactions and DbScheduledSubTransactions.
            await m.createTable(schema.dbScheduledTransactions);
            await m.createTable(schema.dbScheduledSubTransactions);
            // Added DbScheduledTransactionKnowledges.
            await m.createTable(schema.dbScheduledTransactionKnowledges);
            // Created idx_scheduled_txn and idx_scheduled_sub_txn indexes
            await m.createIndex(schema.idxScheduledTxn);
            await m.createIndex(schema.idxScheduledSubTxn);
          });
        },
        from12To13: (m, schema) async {
          await transaction(() async {
            // Added DbCategoryGroups.order and DbCategories.order. They'll default to `0`
            // until we re-fetch.
            await m.addColumn(schema.dbCategoryGroups, schema.dbCategoryGroups.order);
            await m.addColumn(schema.dbCategories, schema.dbCategories.order);
          });
        },
        from13To14: (m, schema) async {
          await transaction(() async {
            // Added indexes for reports-tab transaction queries.
            await customStatement('DROP INDEX IF EXISTS idx_txn_budget_deleted_date');
            await customStatement('DROP INDEX IF EXISTS idx_sub_txn_join');
            await m.createIndex(schema.idxTxnBudgetDeletedDate);
            await m.createIndex(schema.idxSubTxnJoin);
          });
        },
      ),
    );
  }
}

extension AppDatabaseX on LocalDatabase {
  Future<void> clearData() async {
    await transaction(() async {
      // Since everything is keyed off of budget id, delete all budgets.
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  Future<void> clearAllBudgetRelatedData() async {
    await transaction(() async {
      await delete(dbTransactionKnowledges).go();
      await delete(dbTransactions).go();
      await delete(dbCategoryKnowledges).go();
      await delete(dbCategories).go();
      await delete(dbAccountKnowledges).go();
      await delete(dbAccounts).go();
      await delete(dbPayeeKnowledges).go();
      await delete(dbPayees).go();
      await delete(dbMonthKnowledges).go();
      await delete(dbMonths).go();
    });
  }
}

extension _QueryX on List<TypedResult> {
  // Parses the rows returned by a JOIN where each row
  // is comprised of columns that can produce T and D when
  // `readTable(orNull)` is called. The result is a map of
  // T2 to a set of D2, which are produced when calling the
  // `transformX` functions on T and D respectively.
  Map<T2, Set<D2>> parseJoin<T, D, T2, D2>(
    TableInfo<Table, T> tableA,
    T2 Function(T) transformA,
    TableInfo<Table, D> tableB,
    D2 Function(T2, D) transformB,
  ) {
    final map = <T2, Set<D2>>{};
    for (final row in this) {
      final key = transformA(row.readTable(tableA));
      final value = row.readTableOrNull(tableB);
      final existing = map[key] ?? {};
      map[key] = value != null ? {...existing, transformB(key, value)} : existing;
    }
    return map;
  }
}
