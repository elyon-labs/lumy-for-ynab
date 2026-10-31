import { StyleSheet, View } from 'react-native';

import {
  PERIOD_TYPES,
  Settings,
  THEME_PREFERENCES,
  rebuildLedgerForBudget,
  totals,
  type DatabaseAdapter,
} from '@lumy/data';
import { DEFAULT_CURRENCY_FORMAT, milliunits } from '@lumy/money';
import { Spacing } from '@lumy/theme';
import { Button, Card, ListRow, Money, Screen, SectionHeader, Text } from '@lumy/ui';

import { useDatabase, useDatabaseState, useLiveQuery } from '@/data';
import { useSelectedPeriod, useSetting } from '@/settings';

/**
 * A placeholder so the skeleton runs, standing in until the navigation shell
 * replaces it.
 *
 * What it is for now is the one thing the node tests cannot cover: that the
 * Expo adapter, the schema, and the change notification all work on a device.
 * The button writes a transaction and the figures above it change without
 * anything asking them to, which is the whole of the app's reactivity in one
 * tap.
 */
const DEMO_BUDGET = 'demo-budget';

export default function Index() {
  const state = useDatabaseState();

  return (
    <Screen title="Lumy">
      <View style={styles.body}>
        <SectionHeader title="Getting started" />
        <Card>
          <Text weight="semibold">Nothing here yet</Text>
          <Text tone="muted">
            The budget, reports, and settings tabs arrive with the navigation shell.
          </Text>
        </Card>

        <SectionHeader title="Database" />
        <Card flush>
          <ListRow
            title="SQLite"
            accessory={
              <Text tone="muted">
                {state.status === 'ready' ? state.database.sqliteVersion : state.status}
              </Text>
            }
          />
          <ListRow
            title="Schema"
            accessory={
              <Text tone="muted">
                {state.status === 'ready' ? String(state.database.schema) : state.status}
              </Text>
            }
          />
          {state.status === 'failed' ? (
            <ListRow title="Error" subtitle={state.error.message} destructive />
          ) : null}
        </Card>

        <StoredSettings />

        {state.status === 'ready' ? <LiveLedger /> : null}
      </View>
    </Screen>
  );
}

/**
 * The settings store, and the one part of it the node tests cannot reach.
 *
 * Tapping the appearance row writes one row to the settings table. Nothing
 * tells the theme to change: the write notifies, the subscriber invalidates
 * the settings read, `AppThemeProvider` re-reads it, and the whole screen
 * repaints. The period row is the same path reaching a resolved date range.
 */
function StoredSettings() {
  const { value: preference, setValue: setPreference } = useSetting(Settings.themePreference);
  const { period, range, setPeriod } = useSelectedPeriod();

  const nextPreference =
    THEME_PREFERENCES[(THEME_PREFERENCES.indexOf(preference) + 1) % THEME_PREFERENCES.length];
  const nextPeriodType = PERIOD_TYPES[(PERIOD_TYPES.indexOf(period.type) + 1) % PERIOD_TYPES.length];

  return (
    <>
      <SectionHeader title="Settings" />
      <Card flush>
        <ListRow
          title="Appearance"
          subtitle="Stored in SQLite, read back through the same invalidation as the ledger"
          accessory={<Text tone="muted">{preference}</Text>}
          onPress={() => {
            void setPreference(nextPreference);
          }}
        />
        <ListRow
          title="Period"
          subtitle={`${range.from} to ${range.to}`}
          accessory={<Text tone="muted">{period.type}</Text>}
          onPress={() => {
            // Custom carries its own dates, which there is no picker for yet.
            void setPeriod(
              nextPeriodType === 'custom' ? { type: 'thisMonth' } : { type: nextPeriodType },
            );
          }}
        />
      </Card>
    </>
  );
}

/**
 * Reads the ledger and re-reads it when something writes to it.
 *
 * Nothing here subscribes to anything. The figures come from a query key, and
 * the one subscriber in `liveQueries.ts` invalidates that key when a commit
 * touches a table the read depends on.
 */
function LiveLedger() {
  const { adapter } = useDatabase();
  const { data } = useLiveQuery('totals', DEMO_BUDGET, [], (db) =>
    totals(db, { budgetId: DEMO_BUDGET }),
  );

  return (
    <>
      <SectionHeader title="Ledger" />
      <Card flush>
        <ListRow
          title="Inflow"
          accessory={
            <Money
              amount={data?.inflow ?? milliunits(0)}
              format={DEFAULT_CURRENCY_FORMAT}
              colorBySign
            />
          }
        />
        <ListRow
          title="Outflow"
          accessory={
            <Money
              amount={data?.outflow ?? milliunits(0)}
              format={DEFAULT_CURRENCY_FORMAT}
              colorBySign
            />
          }
        />
        <ListRow title="Entries" accessory={<Text tone="muted">{data?.count ?? 0}</Text>} />
      </Card>
      <Button
        label="Add a transaction"
        onPress={() => {
          void addDemoTransaction(adapter);
        }}
      />
    </>
  );
}

/**
 * Writes one transaction and re-derives the ledger for it.
 *
 * Stands in for the sync engine on a device. It goes through the adapter's
 * transaction, so it produces exactly the notification a real sync page
 * produces.
 */
async function addDemoTransaction(db: DatabaseAdapter): Promise<void> {
  const id = `demo-${Date.now()}`;
  const outflow = Math.random() < 0.8;

  await db.transaction(async (tx) => {
    await tx.run(
      `INSERT INTO budgets (id, name) VALUES (?, ?)
       ON CONFLICT (id) DO NOTHING`,
      [DEMO_BUDGET, 'Demo'],
    );
    await tx.run(
      `INSERT INTO accounts (id, budget_id, name, type, on_budget, closed, deleted, balance)
       VALUES (?, ?, 'Demo account', 'checking', 1, 0, 0, 0)
       ON CONFLICT (id) DO NOTHING`,
      ['demo-account', DEMO_BUDGET],
    );
    await tx.run(
      `INSERT INTO category_groups (id, budget_id, name, hidden, deleted, sort_order)
       VALUES (?, ?, 'Demo group', 0, 0, 0)
       ON CONFLICT (id) DO NOTHING`,
      ['demo-group', DEMO_BUDGET],
    );
    await tx.run(
      `INSERT INTO categories
         (id, budget_id, category_group_id, name, hidden, deleted, sort_order)
       VALUES (?, ?, 'demo-group', 'Demo category', 0, 0, 0)
       ON CONFLICT (id) DO NOTHING`,
      ['demo-category', DEMO_BUDGET],
    );
    await tx.run(
      `INSERT INTO transactions
         (id, budget_id, date, account_id, amount, category_id, cleared, approved, deleted)
       VALUES (?, ?, date('now'), 'demo-account', ?, 'demo-category', 'cleared', 1, 0)`,
      [id, DEMO_BUDGET, outflow ? -Math.ceil(Math.random() * 25_000) : 250_000],
    );

    await rebuildLedgerForBudget(tx, DEMO_BUDGET);
  });
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
