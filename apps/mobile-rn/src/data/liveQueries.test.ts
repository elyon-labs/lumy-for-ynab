import { createSyncEngine, migrate, type DatabaseAdapter, type ReadName } from '@lumy/data';
import {
  aBudget,
  aCategory,
  aCategoryGroup,
  aPayee,
  aTransaction,
  anAccount,
  createStubClient,
  openNodeDatabase,
  type StubScript,
} from '@lumy/data/testing';
import { QueryClient } from '@tanstack/react-query';
import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import { subscribeToDatabaseChanges } from './liveQueries';
import { queryKey } from './queryKeys';

/**
 * The app's reactivity, tested against a real sync into a real database.
 *
 * The node adapter is the same one the data package's own tests use and the
 * same statements the device runs, so what is asserted here is that a sync
 * page lands and the right query keys go stale — not that a stub called a
 * callback.
 *
 * No renderer. Everything with a decision in it is here: the mapping from
 * changed tables to reads, and the invalidation. `useLiveQuery` builds a key
 * and calls `useQuery`, which is thin enough that there is nothing left to
 * assert about it that TanStack Query does not already guarantee.
 */

const BUDGET = 'budget-1';

const EVERYDAY = aCategoryGroup('everyday', 'Everyday Expenses', [
  aCategory('food', 'Groceries', 'everyday'),
]);

function aScript(script: StubScript = {}): StubScript {
  return {
    budgets: [aBudget({ id: BUDGET })],
    accounts: [{ entities: [anAccount('checking', { name: 'Checking' })], serverKnowledge: 10 }],
    payees: [{ entities: [aPayee('grocer', 'Grocer')], serverKnowledge: 20 }],
    categories: [{ entities: [EVERYDAY], serverKnowledge: 30 }],
    months: [{ entities: [], serverKnowledge: 40 }],
    transactions: [{ entities: [], serverKnowledge: 50 }],
    scheduledTransactions: [{ entities: [], serverKnowledge: 60 }],
    ...script,
  };
}

/** Every read whose cached data a commit threw away. */
function invalidated(queryClient: QueryClient): ReadName[] {
  return queryClient
    .getQueryCache()
    .findAll({ stale: true })
    .map((query) => query.queryKey[0] as ReadName)
    .sort();
}

describe('database changes', () => {
  let db: DatabaseAdapter;
  let queryClient: QueryClient;
  let unsubscribe: () => void;
  let commits: { reads: readonly ReadName[]; tables: readonly string[] }[];

  /** A query cached under each read, so an invalidation has something to hit. */
  async function cacheOneOfEach(reads: readonly ReadName[]): Promise<void> {
    for (const read of reads) {
      await queryClient.fetchQuery({
        queryKey: queryKey(read, BUDGET),
        queryFn: () => Promise.resolve(read),
        staleTime: Infinity,
      });
    }
  }

  beforeEach(async () => {
    db = openNodeDatabase();
    await migrate(db);

    queryClient = new QueryClient({
      defaultOptions: { queries: { staleTime: Infinity, retry: false } },
    });
    commits = [];
    unsubscribe = subscribeToDatabaseChanges(db, queryClient, {
      onInvalidate: (reads, tables) => commits.push({ reads, tables }),
    });
  });

  afterEach(async () => {
    unsubscribe();
    queryClient.clear();
    await db.close();
  });

  it('invalidates exactly the reads a transactions page touched', async () => {
    await cacheOneOfEach([
      'totals',
      'listLedgerEntries',
      'netWorthOverTime',
      'targetHealth',
      'savingsRateByMonth',
    ]);
    expect(invalidated(queryClient)).toEqual([]);

    const engine = createSyncEngine({
      db,
      client: createStubClient(
        aScript({
          transactions: [
            {
              entities: [aTransaction({ id: 'tx-1', payeeId: 'grocer', categoryId: 'food' })],
              serverKnowledge: 50,
            },
          ],
        }),
      ),
    });
    await engine.syncBudget(BUDGET);

    // Every read over the ledger is stale, because the ledger was rebuilt.
    expect(invalidated(queryClient)).toEqual([
      'listLedgerEntries',
      'netWorthOverTime',
      'savingsRateByMonth',
      'targetHealth',
      'totals',
    ]);
  });

  it('leaves a read alone when nothing it depends on was written', async () => {
    await cacheOneOfEach(['totals', 'savingsRateByMonth']);

    await db.run('INSERT INTO budgets (id, name) VALUES (?, ?)', [BUDGET, 'Budget']);

    // `months` is a table no read depends on, so a page of it is invisible.
    await db.transaction((tx) =>
      tx.run(
        `INSERT INTO months (budget_id, month, income, budgeted, activity, to_be_budgeted, deleted)
         VALUES (?, '2026-10-01', 0, 0, 0, 0, 0)`,
        [BUDGET],
      ),
    );

    expect(invalidated(queryClient)).toEqual([]);
    expect(commits).toEqual([]);
  });

  it('reports nothing for a write that only advanced server knowledge', async () => {
    await db.run('INSERT INTO budgets (id, name) VALUES (?, ?)', [BUDGET, 'Budget']);
    commits = [];

    await db.transaction((tx) =>
      tx.run(
        `INSERT INTO server_knowledge (budget_id, resource, month, knowledge, synced_at)
         VALUES (?, 'transactions', '', 1, '2026-10-31T00:00:00Z')`,
        [BUDGET],
      ),
    );

    expect(commits).toEqual([]);
  });

  it('invalidates the name-resolving reads when a payee is renamed', async () => {
    await cacheOneOfEach(['sumBy', 'totals']);

    await db.transaction(async (tx) => {
      await tx.run('INSERT INTO budgets (id, name) VALUES (?, ?)', [BUDGET, 'Budget']);
      await tx.run('INSERT INTO payees (id, budget_id, name, deleted) VALUES (?, ?, ?, 0)', [
        'grocer',
        BUDGET,
        'Corner Shop',
      ]);
    });

    // `totals` reads no names, so a rename cannot change what it returns.
    expect(invalidated(queryClient)).toEqual(['sumBy']);
  });

  it('reports one invalidation per committed transaction, not per statement', async () => {
    await cacheOneOfEach(['totals']);

    const engine = createSyncEngine({
      db,
      client: createStubClient(aScript()),
      chunkSize: 500,
    });
    await engine.syncBudget(BUDGET);

    // Three of the sync's commits wrote a table some read depends on. The
    // budget list is not one of them: nothing reads `budgets` or
    // `currency_formats` yet, so writing them invalidates nothing. Nor are the
    // empty month, transaction, and scheduled pages, which advanced server
    // knowledge and touched nothing else.
    expect(commits.map((commit) => commit.tables)).toEqual([
      ['account_debt_months', 'accounts', 'server_knowledge'],
      ['payees', 'server_knowledge'],
      ['categories', 'category_groups', 'server_knowledge'],
    ]);
  });

  it('stops listening when it is unsubscribed', async () => {
    await cacheOneOfEach(['sumBy']);
    await db.run('INSERT INTO budgets (id, name) VALUES (?, ?)', [BUDGET, 'Budget']);
    unsubscribe();

    // A write a live subscriber would have reported, so the silence below is
    // the unsubscribe and not the write being uninteresting.
    await db.transaction((tx) =>
      tx.run('INSERT INTO payees (id, budget_id, name, deleted) VALUES (?, ?, ?, 0)', [
        'grocer',
        BUDGET,
        'Grocer',
      ]),
    );

    expect(invalidated(queryClient)).toEqual([]);
    expect(commits).toEqual([]);
  });
});
