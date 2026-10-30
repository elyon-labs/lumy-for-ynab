import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import {
  BUDGET_ID,
  aBudget,
  aCategory,
  aCategoryGroup,
  aMonth,
  aPayee,
  aTransaction,
  anAccount,
  createHarness,
  createStubClient,
  seedSubtransaction,
  type Harness,
  type StubClient,
  type StubScript,
} from '../testing';
import { createSyncEngine, type SyncEngine } from './engine';
import { BUDGET_SCOPED_TABLES, discardBudgetData } from './repair';
import type { Divergence } from './verify';

const EVERYDAY = aCategoryGroup('everyday', 'Everyday Expenses', [
  aCategory('food', 'Groceries', 'everyday'),
  aCategory('fun', 'Fun Money', 'everyday'),
]);

const SPLIT = aTransaction({
  id: 'tx-1',
  amount: -10_000,
  payeeId: 'grocer',
  subtransactions: [
    { id: 'sub-1', categoryId: 'food', amount: -3_000 },
    { id: 'sub-2', categoryId: 'fun', amount: -7_000 },
  ],
});

const SIMPLE = aTransaction({ id: 'tx-2', payeeId: 'grocer', categoryId: 'food' });

/**
 * A script that answers the same snapshot however often it is asked.
 *
 * Verification fetches without knowledge, exactly as a first sync does, so the
 * two read the same pages — which is what lets a test sync a budget and then
 * ask whether it agrees with the server it just read.
 */
function aScript(script: StubScript = {}): StubScript {
  const page = <T,>(entities: readonly T[], serverKnowledge: number) =>
    Array.from({ length: 4 }, () => ({ entities, serverKnowledge }));

  return {
    budgets: [aBudget()],
    accounts: page([anAccount('checking', { name: 'Checking' })], 10),
    payees: page([aPayee('grocer', 'Grocer')], 20),
    categories: page([EVERYDAY], 30),
    months: page([aMonth('2026-10-01')], 40),
    transactions: page([SPLIT, SIMPLE], 50),
    scheduledTransactions: page([], 60),
    ...script,
  };
}

describe('verification', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let client: StubClient;
  let engine: SyncEngine;

  function build(script: StubScript = {}): void {
    client = createStubClient(aScript(script));
    engine = createSyncEngine({
      db,
      client,
      now: () => new Date('2026-10-29T12:00:00.000Z'),
    });
  }

  function sorted(divergences: readonly Divergence[]): readonly Divergence[] {
    return [...divergences].sort((a, b) =>
      `${a.entity}:${a.id}`.localeCompare(`${b.entity}:${b.id}`),
    );
  }

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
    build();
  });

  afterEach(async () => {
    await harness.close();
  });

  describe('a budget that has just synced', () => {
    beforeEach(async () => {
      await engine.syncBudget(BUDGET_ID);
    });

    it('agrees with the snapshot', async () => {
      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.divergences).toEqual([]);
      expect(report.consistent).toBe(true);
    });

    it('says what it compared, so a clean report is still evidence', async () => {
      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.counts.transactions).toEqual({ local: 2, remote: 2 });
      expect(report.counts.subtransactions).toEqual({ local: 2, remote: 2 });
      expect(report.counts.ledger_entries).toEqual({ local: 3, remote: 3 });
      expect(report.checkedAt).toBe('2026-10-29T12:00:00.000Z');
    });
  });

  describe('a client that has never synced', () => {
    it('reports everything the snapshot holds as missing', async () => {
      await engine.syncBudgetList();

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.consistent).toBe(false);
      expect(report.counts.transactions).toEqual({ local: 0, remote: 2 });
      expect(report.divergences).toContainEqual({
        entity: 'transactions',
        id: 'tx-1',
        kind: 'missing',
      });
    });
  });

  describe('the Flutter stale-subtransaction bug', () => {
    /**
     * The writer that upserts a parent's legs instead of reconciling them.
     *
     * A split that loses a leg leaves the old row behind with `deleted = 0`,
     * where it keeps being counted and keeps being shown. Reproduced by
     * writing that row directly rather than through the engine, because the
     * engine cannot produce it.
     */
    beforeEach(async () => {
      await engine.syncBudget(BUDGET_ID);
      await seedSubtransaction(db, {
        id: 'sub-gone',
        transactionId: 'tx-1',
        categoryId: 'fun',
        amount: -7_000,
      });
    });

    it('is reported against the snapshot as a row YNAB does not have', async () => {
      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.divergences).toContainEqual({
        entity: 'subtransactions',
        id: 'sub-gone',
        kind: 'unexpected',
      });
      expect(report.counts.subtransactions).toEqual({ local: 3, remote: 2 });
    });

    it('cannot occur through the engine, which reconciles the set', async () => {
      await engine.syncBudget(BUDGET_ID, { full: true });

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);
      expect(report.consistent).toBe(true);
    });

    it('is repaired, and the ledger with it', async () => {
      await engine.repairBudget(BUDGET_ID);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);
      expect(report.divergences).toEqual([]);
      expect(report.counts.ledger_entries).toEqual({ local: 3, remote: 3 });
    });
  });

  describe('the Flutter advanced-knowledge bug', () => {
    /**
     * Knowledge that moved past data the client never wrote.
     *
     * In the Flutter app this came of advancing `last_knowledge_of_server` in
     * a batch that was not atomic with the data write, so a partial failure
     * left the client convinced it held transactions it had never stored —
     * and no delta would ever mention them again. Reproduced by writing the
     * knowledge row directly, because the engine only ever writes it with the
     * data it describes.
     */
    beforeEach(async () => {
      // The first transactions request carries the knowledge the client
      // wrongly claims and so comes back empty, exactly as YNAB answers a
      // client that is already past the window. Every request after it is a
      // snapshot, which is what verification and repair make.
      build({
        transactions: [
          { entities: [], serverKnowledge: 500 },
          { entities: [SPLIT, SIMPLE], serverKnowledge: 500 },
          { entities: [SPLIT, SIMPLE], serverKnowledge: 500 },
          { entities: [SPLIT, SIMPLE], serverKnowledge: 500 },
        ],
      });

      await engine.syncBudgetList();
      await db.run(
        `INSERT INTO server_knowledge (budget_id, resource, month, knowledge, synced_at)
         VALUES (?, 'transactions', '', 500, '2026-10-29T00:00:00Z')`,
        [BUDGET_ID],
      );
    });

    it('is invisible to a delta sync, which is why it needs verifying', async () => {
      await engine.syncBudget(BUDGET_ID);

      const row = await db.get<{ total: number }>('SELECT COUNT(*) AS total FROM transactions');
      expect(row?.total).toBe(0);
    });

    it('is reported against the snapshot', async () => {
      await engine.syncBudget(BUDGET_ID);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.consistent).toBe(false);
      expect(sorted(report.divergences)).toContainEqual({
        entity: 'transactions',
        id: 'tx-1',
        kind: 'missing',
      });
    });

    it('is repaired, because knowledge is discarded with the rows it describes', async () => {
      await engine.syncBudget(BUDGET_ID);

      await engine.repairBudget(BUDGET_ID);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);
      expect(report.consistent).toBe(true);
    });
  });

  describe('the ledger check', () => {
    beforeEach(async () => {
      await engine.syncBudget(BUDGET_ID);
    });

    it('reports an entry the raw rows no longer imply', async () => {
      await db.run('DELETE FROM subtransactions WHERE id = ?', ['sub-2']);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.divergences).toContainEqual({
        entity: 'ledger_entries',
        id: 'sub-2',
        kind: 'unexpected',
      });
    });

    it('reports an entry that was never derived', async () => {
      await db.run('DELETE FROM ledger_entries WHERE entry_id = ?', ['sub-1']);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.divergences).toContainEqual({
        entity: 'ledger_entries',
        id: 'sub-1',
        kind: 'missing',
      });
      expect(report.counts.ledger_entries).toEqual({ local: 2, remote: 3 });
    });

    it('reports an entry whose numbers drifted from the row it came from', async () => {
      await db.run('UPDATE ledger_entries SET amount = ? WHERE entry_id = ?', [-1, 'sub-1']);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.divergences).toContainEqual({
        entity: 'ledger_entries',
        id: 'sub-1',
        kind: 'different',
      });
    });

    it('leaves no trace of the table it derived into', async () => {
      await engine.verifyAgainstSnapshot(BUDGET_ID);

      const table = await db.get(
        "SELECT name FROM temp.sqlite_master WHERE type = 'table' AND name = 'ledger_check'",
      );
      expect(table).toBeUndefined();
    });
  });

  describe('a field that drifted', () => {
    it('is reported with the columns that disagree', async () => {
      await engine.syncBudget(BUDGET_ID);
      await db.run('UPDATE accounts SET name = ?, closed = 1 WHERE id = ?', [
        'Renamed',
        'checking',
      ]);

      const report = await engine.verifyAgainstSnapshot(BUDGET_ID);

      expect(report.divergences).toContainEqual({
        entity: 'accounts',
        id: 'checking',
        kind: 'different',
        columns: ['name', 'closed'],
      });
    });
  });
});

describe('repair', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let engine: SyncEngine;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
    engine = createSyncEngine({ db, client: createStubClient(aScript()) });
    await engine.syncBudget(BUDGET_ID);
  });

  afterEach(async () => {
    await harness.close();
  });

  async function remaining(table: string, budgetId = BUDGET_ID): Promise<number> {
    const row = await db.get<{ total: number }>(
      `SELECT COUNT(*) AS total FROM ${table} WHERE budget_id = ?`,
      [budgetId],
    );

    return row?.total ?? 0;
  }

  it('covers every budget-scoped table in the schema', async () => {
    const tables = await db.all<{ name: string }>(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
    );

    const scoped: string[] = [];
    for (const { name } of tables) {
      const columns = await db.all<{ name: string }>(
        `SELECT name FROM pragma_table_info('${name}')`,
      );
      if (columns.some((column) => column.name === 'budget_id')) scoped.push(name);
    }

    expect(scoped.length).toBeGreaterThan(0);
    expect([...scoped].sort()).toEqual([...BUDGET_SCOPED_TABLES].sort());
  });

  it('empties the budget, its knowledge, and its ledger', async () => {
    expect(await remaining('ledger_entries')).toBe(3);

    await db.transaction((tx) => discardBudgetData(tx, BUDGET_ID));

    for (const table of BUDGET_SCOPED_TABLES) {
      expect(await remaining(table)).toBe(0);
    }
    expect(await db.get('SELECT 1 FROM budgets WHERE id = ?', [BUDGET_ID])).toBeUndefined();
  });

  it('reports the discarded tables, so nothing keeps showing data that has gone', async () => {
    const before = harness.changes.length;

    await db.transaction((tx) => discardBudgetData(tx, BUDGET_ID));

    const announced = harness.changes.slice(before).flat();
    expect(announced).toContain('ledger_entries');
    expect(announced).toContain('transactions');
    expect(announced).toContain('server_knowledge');
    expect(announced).toContain('budgets');
  });

  it('syncs the budget again from scratch', async () => {
    const report = await engine.repairBudget(BUDGET_ID);

    expect(report.resources.every((resource) => resource.mode === 'full')).toBe(true);
    expect(await remaining('ledger_entries')).toBe(3);
  });

  it('leaves another budget alone', async () => {
    const other = 'budget-2';
    await db.run('INSERT INTO budgets (id, name) VALUES (?, ?)', [other, 'Other']);
    await db.run('INSERT INTO payees (id, budget_id, name, deleted) VALUES (?, ?, ?, 0)', [
      'other-payee',
      other,
      'Someone',
    ]);

    await engine.repairBudget(BUDGET_ID);

    expect(await remaining('payees', other)).toBe(1);
  });
});
