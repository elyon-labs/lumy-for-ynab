import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { rebuildLedgerForTransactions } from '../ledger';
import {
  BUDGET_ID,
  createHarness,
  seedAccount,
  seedBudget,
  seedCategory,
  seedCategoryGroup,
  seedCategoryMonth,
  seedPayee,
  seedSubtransaction,
  seedTransaction,
  type Harness,
} from '../testing';

const EXPECTED_TABLES = [
  'account_debt_months',
  'accounts',
  'budgets',
  'categories',
  'category_groups',
  'category_months',
  'currency_formats',
  'ledger_entries',
  'months',
  'payees',
  'scheduled_subtransactions',
  'scheduled_transactions',
  'server_knowledge',
  'subtransactions',
  'transactions',
];

async function tableNames(db: DatabaseAdapter): Promise<string[]> {
  const rows = await db.all<{ name: string }>(
    `SELECT name FROM sqlite_master
     WHERE type = 'table' AND name NOT LIKE 'sqlite_%' AND name <> 'schema_migrations'
     ORDER BY name`,
  );

  return rows.map((row) => row.name);
}

async function count(db: DatabaseAdapter, table: string): Promise<number> {
  const row = await db.get<{ n: number }>(`SELECT COUNT(*) AS n FROM ${table}`);

  return row?.n ?? 0;
}

describe('the schema', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
  });

  afterEach(async () => {
    await harness.close();
  });

  it('creates every YNAB entity table', async () => {
    expect(await tableNames(db)).toEqual(EXPECTED_TABLES);
  });

  describe('budget scoping', () => {
    it('discards a budget and everything cached under it in one delete', async () => {
      // This is the whole of the repair path: no list of tables to keep in
      // step with the schema as it grows.
      await seedBudget(db);
      const account = await seedAccount(db, { id: 'account-1' });
      await seedPayee(db, { id: 'payee-1' });
      const group = await seedCategoryGroup(db, { id: 'group-1' });
      const category = await seedCategory(db, { id: 'category-1', categoryGroupId: group });
      await seedCategoryMonth(db, { categoryId: category, month: '2026-10-01' });
      const transaction = await seedTransaction(db, { id: 'txn-1', accountId: account });
      await seedSubtransaction(db, { id: 'sub-1', transactionId: transaction });
      await rebuildLedgerForTransactions(db, [transaction]);
      await db.run(
        `INSERT INTO server_knowledge (budget_id, resource, knowledge, synced_at)
         VALUES (?, 'transactions', 42, '2026-10-29T00:00:00Z')`,
        [BUDGET_ID],
      );

      await db.run('DELETE FROM budgets WHERE id = ?', [BUDGET_ID]);

      for (const table of EXPECTED_TABLES) {
        expect(await count(db, table), table).toBe(0);
      }
    });

    it('refuses a row scoped to a budget that is not there', async () => {
      await expect(seedAccount(db, { id: 'account-1' })).rejects.toThrow(/FOREIGN KEY/i);
    });
  });

  describe('split transactions', () => {
    beforeEach(async () => {
      await seedBudget(db);
      await seedAccount(db, { id: 'account-1' });
    });

    it('takes the legs with the parent', async () => {
      await seedTransaction(db, { id: 'txn-1', accountId: 'account-1' });
      await seedSubtransaction(db, { id: 'sub-1', transactionId: 'txn-1' });
      await seedSubtransaction(db, { id: 'sub-2', transactionId: 'txn-1' });

      await db.run('DELETE FROM transactions WHERE id = ?', ['txn-1']);

      // The stale-subtransaction bug in the Flutter app is a leg that outlives
      // what it belonged to; here it cannot.
      expect(await count(db, 'subtransactions')).toBe(0);
    });

    it('refuses a leg with no parent', async () => {
      await expect(
        seedSubtransaction(db, { id: 'sub-1', transactionId: 'txn-missing' }),
      ).rejects.toThrow(/FOREIGN KEY/i);
    });
  });

  describe('category months', () => {
    it('survives the category row being rewritten', async () => {
      // The categories payload is the one YNAB only ever sends whole, so the
      // writer may replace that table outright. Month balances must not go
      // with it.
      await seedBudget(db);
      const group = await seedCategoryGroup(db, { id: 'group-1' });
      await seedCategory(db, { id: 'category-1', categoryGroupId: group });
      await seedCategoryMonth(db, { categoryId: 'category-1', month: '2026-09-01', activity: -100 });

      await db.run('DELETE FROM categories');

      expect(await count(db, 'category_months')).toBe(1);
    });

    it('holds one row per category and month', async () => {
      await seedBudget(db);
      const group = await seedCategoryGroup(db, { id: 'group-1' });
      await seedCategory(db, { id: 'category-1', categoryGroupId: group });
      await seedCategoryMonth(db, { categoryId: 'category-1', month: '2026-09-01' });

      await expect(
        seedCategoryMonth(db, { categoryId: 'category-1', month: '2026-09-01' }),
      ).rejects.toThrow(/UNIQUE/i);
    });
  });

  describe('server knowledge', () => {
    beforeEach(async () => {
      await seedBudget(db);
    });

    async function advance(resource: string, knowledge: number, month = ''): Promise<void> {
      await db.run(
        `INSERT INTO server_knowledge (budget_id, resource, month, knowledge, synced_at)
         VALUES (?, ?, ?, ?, '2026-10-29T00:00:00Z')
         ON CONFLICT (budget_id, resource, month) DO UPDATE SET knowledge = excluded.knowledge`,
        [BUDGET_ID, resource, month, knowledge],
      );
    }

    it('holds one row per resource however often it is advanced', async () => {
      // A nullable month would not do this: SQLite treats nulls in a primary
      // key as distinct, so each sync would leave its own row behind and the
      // next one would have several answers to choose from.
      await advance('transactions', 1);
      await advance('transactions', 2);
      await advance('transactions', 3);

      const rows = await db.all<{ knowledge: number }>(
        'SELECT knowledge FROM server_knowledge WHERE resource = ?',
        ['transactions'],
      );

      expect(rows).toEqual([{ knowledge: 3 }]);
    });

    it('keeps month-scoped resources apart', async () => {
      await advance('categories', 10, '2026-09-01');
      await advance('categories', 11, '2026-10-01');

      expect(await count(db, 'server_knowledge')).toBe(2);
    });

    it('keeps resources apart', async () => {
      await advance('transactions', 1);
      await advance('accounts', 1);

      expect(await count(db, 'server_knowledge')).toBe(2);
    });
  });

  describe('cross-resource references', () => {
    it('accepts a transaction whose payee and category have not arrived yet', async () => {
      // Delta pages arrive one resource at a time and in no fixed order, so a
      // transaction naming a payee the client has not fetched is ordinary
      // rather than a violation. Those columns are deliberately not foreign
      // keys; the ledger resolves them at derivation time.
      await seedBudget(db);
      await seedAccount(db, { id: 'account-1' });

      await seedTransaction(db, {
        id: 'txn-1',
        accountId: 'account-1',
        payeeId: 'payee-not-synced',
        categoryId: 'category-not-synced',
      });

      expect(await count(db, 'transactions')).toBe(1);
    });
  });
});
