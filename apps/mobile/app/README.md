## Database Migrations

1. Update the database version

```dart
@override
int get schemaVersion => 6;
```

2. Run build runner

```sh
dart run build_runner build --delete-conflicting-outputs -v
```

3. Export the new schema:

```sh
dart run drift_dev schema dump lib/persistence/local/database.dart drift_schemas/
```

4. Create a migration

```sh
dart run drift_dev schema steps drift_schemas/ lib/persistence/schema_versions.dart
```

5. Use migration steps to update schema

```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // Added DbSpendTrackers2, DbSpendTrackerConditions,
        // and DbSpendTrackerTests
        await m.renameTable(dbLegacySpendTrackers, 'db_spend_trackers');
        await m.createTable(dbQuerySpendTrackers);
        await m.createTable(dbSpendTrackerConditions);
        await m.createTable(dbSpendTrackerTests);
      },
    ),
  );
}
```

6. Generate test helpers

```sh
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
```

7. Add the new version to the array in `database_test.dart`

```dart
group('Database', () {
  for (final version in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]) {
    test('upgrade from v$version to v${version + 1}', () async {
      final connection = await verifier.startAt(version);
      final db = AppDatabase(connection);
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, version + 1);
    });
  }
});
```

## Pending Transactions

We tried omitting transactions whose import IDs begin with `YNAB:P:`, but found that YNAB
sometimes retains one of these as the canonical, long-term transaction. Filtering them therefore
caused real transaction data to disappear, so Lumy preserves them.

From Danielle at YNAB:

> Generally, it is not expected that pending transactions will show up at all in the API because they are not synced down. We have updated the endpoint description in our API documentation to make this more clear. For example, the GET transactions endpoint now states that it "Returns budget transactions, excluding any pending transactions."

> However, there is one exception. When a pending transaction matches with a user-entered transaction, you will see a temporary pending transaction labeled with a "P" in the import_id field (as you suspected, that does indicate a pending transaction!). So here's where things get a little funky.

> After the matching cleared transaction imports, YNAB then rejects the pending match and replaces the matched transaction with the cleared match. This deletes the matched pending transaction, which is why those transactions are automatically cleared out after some time.

> This is on our developer's radar, but because of the system currently in place and the limitations of the API, we don't have a workaround or exact definition of the lifecycle of pending transactions to offer at this time.

## Null CurrencyFormats

From Danielle at YNAB:

> Some budgets return null for the currency format because some budgets have been existing in that state for a while, specifically if the budget is older or was imported via YNAB 4. These older budgets were created or imported in that state, and they never updated to the newer currency processes.

> All newer budgets should always have the full currency defined. If a YNABer is seeing the wrong currency in Lumy due to the currency returning null, we do have a workaround! To get the currency to show up correctly on Lumy, the YNABer can make a change to their currency settings and then change it back, and then the full currency format should show up in the API.

## Updating Payee/Category Names

When updating a payee or category name, the `payeeName` and `categoryName` fields are _not_ updated on `Transaction` objects.

From Danielle:

> According to our developers, when a category or payee name changes, our change detection system does not attribute this change to transactions that point to these entities but instead to the category and/or payee entity. Your noted work-around would probably be the best way to handle this.

## Month-specific endpoints/fields

Endpoints like `/months` and fields like the month-specific balance fields on categories do _not_ update automatically if the entity itself hasn't changed. This means when the month rolls over, these can be out of date if they haven' changed since beginning of the month.

From Danielle:

> The API does not track what month that you last called an endpoint

The current workaround is that we store the last month that these endpoints were called and drop the `last_knowledge_of_server` query parameter if it's not the current month (i.e we're in a new month).
