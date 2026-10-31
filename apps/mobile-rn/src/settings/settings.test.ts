import {
  Settings,
  getSetting,
  migrate,
  setSetting,
  type DatabaseAdapter,
  type ReadName,
} from '@lumy/data';
import { openNodeDatabase } from '@lumy/data/testing';
import { QueryClient } from '@tanstack/react-query';
import { afterEach, beforeEach, describe, expect, it } from 'vitest';

// The modules themselves rather than `@/data`, whose barrel reaches the Expo
// adapter and so the Expo runtime, which cannot load outside a Metro bundle.
import { subscribeToDatabaseChanges } from '@/data/liveQueries';
import { queryKey } from '@/data/queryKeys';

/**
 * A setting is written and the screens reading it go stale, against a real
 * database rather than a stubbed callback.
 *
 * This is the half of the settings store that is about the app: the store
 * itself is tested in `@lumy/data`, and what is asserted here is that a write
 * travels the same invalidation path the ledger does. Without it the Flutter
 * app's answer — a stream per setting — would be the only way a screen could
 * notice, and the whole point of putting settings in SQLite is that it is not.
 *
 * No renderer: `useSetting` builds the key, calls `useLiveQuery`, and returns
 * the value, which leaves nothing to assert about it that TanStack Query does
 * not already guarantee.
 */

const BUDGET = 'budget-1';

function invalidated(queryClient: QueryClient): ReadName[] {
  return queryClient
    .getQueryCache()
    .findAll({ stale: true })
    .map((query) => query.queryKey[0] as ReadName)
    .sort();
}

describe('writing a setting', () => {
  let db: DatabaseAdapter;
  let queryClient: QueryClient;
  let unsubscribe: () => void;
  let commits: { reads: readonly ReadName[]; tables: readonly string[] }[];

  /** A cached query per read, so an invalidation has something to hit. */
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

  it('makes the settings read stale and nothing else', async () => {
    await cacheOneOfEach(['getSetting', 'totals', 'listTransactions', 'sumBy']);
    expect(invalidated(queryClient)).toEqual([]);

    await setSetting(db, Settings.themePreference, 'light');

    // A setting says nothing about the ledger, so every read over it keeps the
    // data it has. The Flutter app had no equivalent of this distinction: its
    // settings and its transactions were separate stream stacks entirely.
    expect(invalidated(queryClient)).toEqual(['getSetting']);
    expect(commits.map((commit) => commit.tables)).toEqual([['settings']]);
  });

  it('reports one invalidation per write, not one per setting read', async () => {
    // The key leads with the read's name, so invalidating `['getSetting']`
    // reaches every cached setting at once and the subscriber never has to
    // know which keys exist.
    await queryClient.fetchQuery({
      queryKey: queryKey('getSetting', '', Settings.themePreference.key),
      queryFn: () => Promise.resolve('dark'),
      staleTime: Infinity,
    });
    await queryClient.fetchQuery({
      queryKey: queryKey('getSetting', BUDGET, Settings.spendTrackerOrder.key),
      queryFn: () => Promise.resolve([]),
      staleTime: Infinity,
    });

    await setSetting(db, Settings.spendTrackerOrder, ['a'], BUDGET);

    expect(invalidated(queryClient)).toEqual(['getSetting', 'getSetting']);
    expect(commits).toHaveLength(1);
  });

  it('is what the next read returns', async () => {
    // The adapter and the accessors the app uses are the ones the data
    // package tests, so this is about the two meeting rather than about the
    // store: a write through the app's path is readable through it.
    await setSetting(db, Settings.selectedBudgetId, BUDGET);

    expect(await getSetting(db, Settings.selectedBudgetId)).toBe(BUDGET);
  });
});
