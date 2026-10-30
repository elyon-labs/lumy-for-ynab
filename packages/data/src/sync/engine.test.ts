import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import {
  BUDGET_ID,
  aBudget,
  aCategory,
  aCategoryGroup,
  aMonth,
  aMonthDetail,
  aPayee,
  aScheduledTransaction,
  aTransaction,
  anAccount,
  createHarness,
  createStubClient,
  type Harness,
  type StubClient,
  type StubScript,
} from '../testing';
import { createSyncEngine, type SyncEngine, type SyncProgress } from './engine';
import { readKnowledge } from './knowledge';

const EVERYDAY = aCategoryGroup('everyday', 'Everyday Expenses', [
  aCategory('food', 'Groceries', 'everyday'),
  aCategory('fun', 'Fun Money', 'everyday'),
]);

const INTERNAL = aCategoryGroup('internal', 'Internal Master Category', [
  aCategory('ready', 'Inflow: Ready to Assign', 'internal'),
]);

/** A script with everything a budget needs, so a test states only its subject. */
function aScript(script: StubScript = {}): StubScript {
  return {
    budgets: [aBudget()],
    accounts: [{ entities: [anAccount('checking', { name: 'Checking' })], serverKnowledge: 10 }],
    payees: [
      { entities: [aPayee('grocer', 'Grocer'), aPayee('opening', 'Starting Balance')], serverKnowledge: 20 },
    ],
    categories: [{ entities: [EVERYDAY, INTERNAL], serverKnowledge: 30 }],
    months: [{ entities: [aMonth('2026-10-01')], serverKnowledge: 40 }],
    transactions: [{ entities: [], serverKnowledge: 50 }],
    scheduledTransactions: [{ entities: [], serverKnowledge: 60 }],
    ...script,
  };
}

/**
 * An adapter that fails once a statement binds a given id.
 *
 * Standing in for the write that goes wrong on a real device — a disk that is
 * full, a constraint a future schema adds — because what the rules are about
 * is what the database holds afterwards, not what caused it.
 */
function failingOn(db: DatabaseAdapter, id: string): DatabaseAdapter {
  return {
    ...db,
    transaction: (work) =>
      db.transaction((tx) =>
        work({
          ...tx,
          async run(sql, params = []) {
            await tx.run(sql, params);
            if (params.includes(id)) throw new Error('the write failed');
          },
        }),
      ),
  };
}

interface EntryRow {
  entry_id: string;
  transaction_id: string;
  payee_name: string | null;
  category_id: string | null;
  category_group_id: string | null;
  amount: number;
  is_income: number;
  is_expense: number;
}

describe('the sync engine', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let client: StubClient;
  let engine: SyncEngine;
  let progress: SyncProgress[];

  async function build(
    script: StubScript = {},
    engineOptions: { chunkSize?: number; db?: DatabaseAdapter } = {},
  ): Promise<void> {
    client = createStubClient(aScript(script));
    progress = [];
    engine = createSyncEngine({
      db: engineOptions.db ?? db,
      client,
      chunkSize: engineOptions.chunkSize,
      now: () => new Date('2026-10-29T12:00:00.000Z'),
      onProgress: (event) => progress.push(event),
    });
  }

  async function entries(): Promise<EntryRow[]> {
    return db.all<EntryRow>(
      'SELECT entry_id, transaction_id, payee_name, category_id, category_group_id, amount, is_income, is_expense FROM ledger_entries ORDER BY entry_id',
    );
  }

  async function knowledge(resource: string, month?: string): Promise<number | undefined> {
    const record = await readKnowledge(db, { budgetId: BUDGET_ID, resource, month });

    return record?.knowledge;
  }

  async function count(table: string): Promise<number> {
    const row = await db.get<{ total: number }>(`SELECT COUNT(*) AS total FROM ${table}`);

    return row?.total ?? 0;
  }

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
    await build();
  });

  afterEach(async () => {
    await harness.close();
  });

  describe('a first sync', () => {
    it('writes the budget it was asked for before anything references it', async () => {
      await engine.syncBudget(BUDGET_ID);

      const budget = await db.get<{ name: string }>('SELECT name FROM budgets WHERE id = ?', [
        BUDGET_ID,
      ]);
      expect(budget?.name).toBe('Test Budget');
      expect(client.requests[0]?.resource).toBe('budgets');
    });

    it('asks every resource without knowledge, having none', async () => {
      await engine.syncBudget(BUDGET_ID);

      for (const resource of [
        'accounts',
        'payees',
        'categories',
        'months',
        'transactions',
        'scheduled_transactions',
      ]) {
        expect(client.lastRequestFor(resource)?.lastKnowledgeOfServer).toBeUndefined();
      }
    });

    it('reports every resource as a full fetch', async () => {
      const report = await engine.syncBudget(BUDGET_ID);

      expect(report.resources.map((result) => result.mode)).toEqual(Array(6).fill('full'));
    });

    it('stores what each resource said', async () => {
      await engine.syncBudget(BUDGET_ID);

      expect(await knowledge('accounts')).toBe(10);
      expect(await knowledge('payees')).toBe(20);
      expect(await knowledge('categories')).toBe(30);
      expect(await knowledge('months')).toBe(40);
      expect(await knowledge('transactions')).toBe(50);
      expect(await knowledge('scheduled_transactions')).toBe(60);
    });

    it('refuses a budget the token cannot see', async () => {
      await expect(engine.syncBudget('not-mine')).rejects.toThrow(/does not list a budget/);
    });

    it('fetches payees and categories before transactions, so names resolve', async () => {
      await build({
        transactions: [
          {
            entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
            serverKnowledge: 50,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);

      expect(await entries()).toMatchObject([
        { entry_id: 'tx-1', payee_name: 'Grocer', category_group_id: 'everyday', is_expense: 1 },
      ]);
    });
  });

  describe('a delta sync', () => {
    beforeEach(async () => {
      await engine.syncBudget(BUDGET_ID);
    });

    it('sends what each resource last reported', async () => {
      await engine.syncBudget(BUDGET_ID);

      expect(client.lastRequestFor('accounts')?.lastKnowledgeOfServer).toBe(10);
      expect(client.lastRequestFor('transactions')?.lastKnowledgeOfServer).toBe(50);
    });

    it('never sends knowledge for categories, whose ordering is its payload', async () => {
      await engine.syncBudget(BUDGET_ID);

      const asked = client.requests.filter((request) => request.resource === 'categories');
      expect(asked).toHaveLength(2);
      expect(asked.every((request) => request.lastKnowledgeOfServer === undefined)).toBe(true);
    });

    it('advances knowledge on an empty page, so the window is not re-fetched forever', async () => {
      await build({ transactions: [{ entities: [], serverKnowledge: 99 }] });
      await engine.syncBudget(BUDGET_ID);

      expect(await knowledge('transactions')).toBe(99);
    });

    it('ignores stored knowledge when asked for a full snapshot', async () => {
      await engine.syncBudget(BUDGET_ID, { full: true });

      expect(client.lastRequestFor('transactions')?.lastKnowledgeOfServer).toBeUndefined();
      expect(client.lastRequestFor('months')?.lastKnowledgeOfServer).toBeUndefined();
    });
  });

  describe('replaying a page', () => {
    it('changes nothing', async () => {
      const page = {
        entities: [
          aTransaction({
            id: 'tx-1',
            payeeId: 'grocer',
            subtransactions: [
              { id: 'sub-1', categoryId: 'food', amount: -3_000 },
              { id: 'sub-2', categoryId: 'fun', amount: -7_000 },
            ],
          }),
        ],
        serverKnowledge: 50,
      };

      await build({ transactions: [page, page] });

      await engine.syncBudget(BUDGET_ID);
      const first = await entries();

      await engine.syncBudget(BUDGET_ID);

      expect(await entries()).toEqual(first);
      expect(await count('transactions')).toBe(1);
      expect(await count('subtransactions')).toBe(2);
    });
  });

  describe('a split that loses a leg', () => {
    beforeEach(async () => {
      await build({
        transactions: [
          {
            entities: [
              aTransaction({
                id: 'tx-1',
                amount: -10_000,
                payeeId: 'grocer',
                subtransactions: [
                  { id: 'sub-1', categoryId: 'food', amount: -3_000 },
                  { id: 'sub-2', categoryId: 'fun', amount: -7_000 },
                ],
              }),
            ],
            serverKnowledge: 50,
          },
          {
            // YNAB does not report the removed leg at all. It simply stops
            // sending it, which is the payload the Flutter writer got wrong.
            entities: [
              aTransaction({
                id: 'tx-1',
                amount: -3_000,
                payeeId: 'grocer',
                subtransactions: [{ id: 'sub-1', categoryId: 'food', amount: -3_000 }],
              }),
            ],
            serverKnowledge: 51,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
    });

    it('removes the stale subtransaction row', async () => {
      await engine.syncBudget(BUDGET_ID);

      const rows = await db.all<{ id: string }>('SELECT id FROM subtransactions ORDER BY id');
      expect(rows.map((row) => row.id)).toEqual(['sub-1']);
    });

    it('removes the stale ledger entry, so the amount stops being counted twice', async () => {
      expect((await entries()).map((entry) => entry.entry_id)).toEqual(['sub-1', 'sub-2']);

      await engine.syncBudget(BUDGET_ID);

      expect(await entries()).toMatchObject([{ entry_id: 'sub-1', amount: -3_000 }]);
    });
  });

  describe('a split reduced to a simple transaction', () => {
    it('leaves the parent as the only leaf', async () => {
      await build({
        transactions: [
          {
            entities: [
              aTransaction({
                id: 'tx-1',
                payeeId: 'grocer',
                subtransactions: [
                  { id: 'sub-1', categoryId: 'food', amount: -3_000 },
                  { id: 'sub-2', categoryId: 'fun', amount: -7_000 },
                ],
              }),
            ],
            serverKnowledge: 50,
          },
          {
            entities: [
              aTransaction({ id: 'tx-1', amount: -10_000, payeeId: 'grocer', categoryId: 'food' }),
            ],
            serverKnowledge: 51,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      await engine.syncBudget(BUDGET_ID);

      expect(await entries()).toMatchObject([
        { entry_id: 'tx-1', transaction_id: 'tx-1', amount: -10_000, category_id: 'food' },
      ]);
      expect(await count('subtransactions')).toBe(0);
    });
  });

  describe('a transaction marked deleted', () => {
    it('keeps the row and drops the entry', async () => {
      await build({
        transactions: [
          {
            entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
            serverKnowledge: 50,
          },
          {
            entities: [
              aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food', deleted: true }),
            ],
            serverKnowledge: 51,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      await engine.syncBudget(BUDGET_ID);

      expect(await count('transactions')).toBe(1);
      expect(await entries()).toEqual([]);
    });
  });

  describe('a failed write', () => {
    it('leaves knowledge unadvanced, so the same window is asked for again', async () => {
      await build({
        transactions: [{ entities: [], serverKnowledge: 50, error: new Error('YNAB is down') }],
      });

      await expect(engine.syncBudget(BUDGET_ID)).rejects.toThrow('YNAB is down');

      expect(await knowledge('transactions')).toBeUndefined();
      // The resources that completed before it keep what they learned.
      expect(await knowledge('payees')).toBe(20);
    });

    it('rolls the whole page back, raw rows and ledger together', async () => {
      await build(
        {
          transactions: [
            {
              entities: [
                aTransaction({
                  id: 'tx-1',
                  subtransactions: [{ id: 'sub-1', categoryId: 'food' }],
                }),
              ],
              serverKnowledge: 50,
            },
          ],
        },
        { db: failingOn(db, 'sub-1') },
      );

      await expect(engine.syncBudget(BUDGET_ID)).rejects.toThrow('the write failed');

      expect(await count('transactions')).toBe(0);
      expect(await count('subtransactions')).toBe(0);
      expect(await count('ledger_entries')).toBe(0);
      expect(await knowledge('transactions')).toBeUndefined();
    });
  });

  describe('a full snapshot', () => {
    function manyTransactions(total: number) {
      return Array.from({ length: total }, (_, index) =>
        aTransaction({ id: `tx-${index}`, categoryId: 'food', payeeId: 'grocer' }),
      );
    }

    it('writes in chunks and advances knowledge only once', async () => {
      await build({ transactions: [{ entities: manyTransactions(250), serverKnowledge: 50 }] }, {
        chunkSize: 100,
      });

      await engine.syncBudget(BUDGET_ID);

      expect(await count('ledger_entries')).toBe(250);
      expect(await knowledge('transactions')).toBe(50);

      const committed = progress.filter(
        (event) => event.resource === 'transactions' && event.phase === 'writing',
      );
      expect(committed.map((event) => event.written)).toEqual([0, 100, 200, 250]);
    });

    it('leaves knowledge unadvanced when a later chunk fails', async () => {
      await build(
        { transactions: [{ entities: manyTransactions(150), serverKnowledge: 50 }] },
        // `tx-120` falls in the second chunk, so the first has committed by
        // the time the write fails.
        { chunkSize: 100, db: failingOn(db, 'tx-120') },
      );

      await expect(engine.syncBudget(BUDGET_ID)).rejects.toThrow();

      expect(await knowledge('transactions')).toBeUndefined();
      // The first chunk stands, and a re-sync of the same window simply
      // rewrites it: every statement is an upsert by id.
      expect(await count('transactions')).toBe(100);
    });

    it('resolves a match that arrives in a later chunk than the transaction it displaces', async () => {
      const imported = aTransaction({ id: 'tx-0', categoryId: 'food', payeeId: 'grocer' });
      const claimant = aTransaction({
        id: 'tx-120',
        categoryId: 'food',
        payeeId: 'grocer',
        matchedTransactionId: 'tx-0',
      });
      const transactions = manyTransactions(150);
      transactions[0] = imported;
      transactions[120] = claimant;

      await build({ transactions: [{ entities: transactions, serverKnowledge: 50 }] }, {
        chunkSize: 100,
      });

      await engine.syncBudget(BUDGET_ID);

      const displaced = await db.get(
        'SELECT 1 FROM ledger_entries WHERE transaction_id = ?',
        ['tx-0'],
      );
      expect(displaced).toBeUndefined();
      expect(await count('ledger_entries')).toBe(149);
    });
  });

  describe('a renamed payee', () => {
    it('re-derives the entries that resolved against it', async () => {
      await build({
        payees: [
          { entities: [aPayee('grocer', 'Grocer')], serverKnowledge: 20 },
          { entities: [aPayee('grocer', 'Corner Shop')], serverKnowledge: 21 },
        ],
        transactions: [
          {
            entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
            serverKnowledge: 50,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      expect((await entries())[0]?.payee_name).toBe('Grocer');

      await engine.syncBudget(BUDGET_ID);

      expect((await entries())[0]?.payee_name).toBe('Corner Shop');
    });

    it('reclassifies a transaction renamed to Starting Balance', async () => {
      await build({
        payees: [
          { entities: [aPayee('opening', 'Opening')], serverKnowledge: 20 },
          { entities: [aPayee('opening', 'Starting Balance')], serverKnowledge: 21 },
        ],
        transactions: [
          {
            entities: [
              aTransaction({ id: 'tx-1', payeeId: 'opening', categoryId: 'ready', amount: 50_000 }),
            ],
            serverKnowledge: 50,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      expect((await entries())[0]?.is_income).toBe(1);

      await engine.syncBudget(BUDGET_ID);

      const entry = await db.get<{ is_income: number; is_starting_balance: number }>(
        'SELECT is_income, is_starting_balance FROM ledger_entries WHERE entry_id = ?',
        ['tx-1'],
      );
      expect(entry).toEqual({ is_income: 0, is_starting_balance: 1 });
    });

    it('leaves the ledger alone when no name changed', async () => {
      await build({
        transactions: [
          {
            entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
            serverKnowledge: 50,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      const before = harness.changes.length;

      await engine.syncBudget(BUDGET_ID);

      const rebuilt = harness.changes
        .slice(before)
        .filter((tables) => tables.includes('ledger_entries'));
      expect(rebuilt).toEqual([]);
    });
  });

  describe('a category moved to another group', () => {
    it('re-derives the entries that resolved its group', async () => {
      const moved = aCategoryGroup('other', 'Other', [aCategory('food', 'Groceries', 'other')]);

      await build({
        categories: [
          { entities: [EVERYDAY, INTERNAL], serverKnowledge: 30 },
          { entities: [moved, INTERNAL], serverKnowledge: 31 },
        ],
        transactions: [
          {
            entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
            serverKnowledge: 50,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      expect((await entries())[0]?.category_group_id).toBe('everyday');

      await engine.syncBudget(BUDGET_ID);

      expect((await entries())[0]?.category_group_id).toBe('other');
    });
  });

  describe('the categories payload', () => {
    it('takes its ordering from the array position', async () => {
      await engine.syncBudget(BUDGET_ID);

      const groups = await db.all<{ id: string; sort_order: number }>(
        'SELECT id, sort_order FROM category_groups ORDER BY sort_order',
      );
      expect(groups).toEqual([
        { id: 'everyday', sort_order: 0 },
        { id: 'internal', sort_order: 1 },
      ]);

      const categories = await db.all<{ id: string; sort_order: number }>(
        'SELECT id, sort_order FROM categories WHERE category_group_id = ? ORDER BY sort_order',
        ['everyday'],
      );
      expect(categories).toEqual([
        { id: 'food', sort_order: 0 },
        { id: 'fun', sort_order: 1 },
      ]);
    });
  });

  describe("an account's loan months", () => {
    it('reconciles the set, because YNAB sends the maps whole', async () => {
      await build({
        accounts: [
          {
            entities: [
              anAccount('loan', {
                type: 'autoLoan',
                debtMonths: [
                  { month: '2026-09-01', interestRate: 4_000, minimumPayment: 20_000, escrowAmount: null },
                  { month: '2026-10-01', interestRate: 4_000, minimumPayment: 20_000, escrowAmount: null },
                ],
              }),
            ],
            serverKnowledge: 10,
          },
          {
            entities: [
              anAccount('loan', {
                type: 'autoLoan',
                debtMonths: [
                  { month: '2026-10-01', interestRate: 3_500, minimumPayment: 20_000, escrowAmount: null },
                ],
              }),
            ],
            serverKnowledge: 11,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      expect(await count('account_debt_months')).toBe(2);

      await engine.syncBudget(BUDGET_ID);

      const rows = await db.all<{ month: string; interest_rate: number }>(
        'SELECT month, interest_rate FROM account_debt_months ORDER BY month',
      );
      expect(rows).toEqual([{ month: '2026-10-01', interest_rate: 3_500 }]);
    });
  });

  describe('scheduled transactions', () => {
    it('reconciles their legs the same way', async () => {
      await build({
        scheduledTransactions: [
          {
            entities: [
              aScheduledTransaction({
                id: 'sched-1',
                subtransactions: [{ id: 'sched-sub-1', categoryId: 'food' }],
              }),
            ],
            serverKnowledge: 60,
          },
          {
            entities: [aScheduledTransaction({ id: 'sched-1' })],
            serverKnowledge: 61,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      expect(await count('scheduled_subtransactions')).toBe(1);

      await engine.syncBudget(BUDGET_ID);

      expect(await count('scheduled_subtransactions')).toBe(0);
      expect(await count('scheduled_transactions')).toBe(1);
    });
  });

  describe("one month's detail", () => {
    it('fills every category figure for that month', async () => {
      await build({
        monthDetail: [
          aMonthDetail('2026-10-01', [
            aCategory('food', 'Groceries', 'everyday', {
              budgeted: 50_000,
              activity: -20_000,
              balance: 30_000,
            }),
          ]),
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');

      const rows = await db.all<{ category_id: string; budgeted: number; balance: number }>(
        'SELECT category_id, budgeted, balance FROM category_months WHERE month = ?',
        ['2026-10-01'],
      );
      expect(rows).toEqual([{ category_id: 'food', budgeted: 50_000, balance: 30_000 }]);
      expect(await readKnowledge(db, {
        budgetId: BUDGET_ID,
        resource: 'month_detail',
        month: '2026-10-01',
      })).toEqual({ knowledge: 0, syncedAt: '2026-10-29T12:00:00.000Z' });
    });

    it('reconciles the month, so a category that stopped appearing goes', async () => {
      await build({
        monthDetail: [
          aMonthDetail('2026-10-01', [
            aCategory('food', 'Groceries', 'everyday'),
            aCategory('fun', 'Fun Money', 'everyday'),
          ]),
          aMonthDetail('2026-10-01', [aCategory('food', 'Groceries', 'everyday')]),
        ],
      });

      await engine.syncBudget(BUDGET_ID);
      await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');
      expect(await count('category_months')).toBe(2);

      await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');

      expect(await count('category_months')).toBe(1);
    });
  });

  describe('change notification', () => {
    it('reports one set of tables per committed page', async () => {
      await build({
        transactions: [
          {
            entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
            serverKnowledge: 50,
          },
        ],
      });

      await engine.syncBudget(BUDGET_ID);

      const ledgerCommits = harness.changes.filter((tables) => tables.includes('ledger_entries'));
      expect(ledgerCommits).toHaveLength(1);
      expect(ledgerCommits[0]).toContain('transactions');
      expect(ledgerCommits[0]).toContain('server_knowledge');
    });
  });
});
