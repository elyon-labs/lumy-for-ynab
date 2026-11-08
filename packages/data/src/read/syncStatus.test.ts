import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { createSyncEngine, type SyncEngine } from '../sync/engine';
import { SYNC_RESOURCES } from '../sync/resources';
import {
  BUDGET_ID,
  aBudget,
  aCategory,
  aCategoryGroup,
  aMonth,
  aMonthDetail,
  aPayee,
  anAccount,
  createHarness,
  createStubClient,
  type Harness,
  type StubScript,
} from '../testing';
import { hasSyncedData, syncStatus } from './syncStatus';

/**
 * The last-fetch display and the gate on the first-run sync screen.
 *
 * Both are read from `server_knowledge` rather than from a setting, because
 * that row is written in the same transaction as the data it describes. A
 * `last_fetch` preference — what the Flutter app had — can say the client
 * fetched something it never stored, which is exactly the class of bug this
 * engine exists to remove.
 */

const FOOD = aCategory('food', 'Groceries', 'everyday');
const EVERYDAY = aCategoryGroup('everyday', 'Everyday Expenses', [FOOD]);

function aScript(script: StubScript = {}): StubScript {
  return {
    budgets: [aBudget()],
    accounts: [{ entities: [anAccount('checking', { name: 'Checking' })], serverKnowledge: 10 }],
    payees: [{ entities: [aPayee('grocer', 'Grocer')], serverKnowledge: 20 }],
    categories: [{ entities: [EVERYDAY], serverKnowledge: 30 }],
    months: [{ entities: [aMonth('2026-10-01')], serverKnowledge: 40 }],
    transactions: [{ entities: [], serverKnowledge: 50 }],
    scheduledTransactions: [{ entities: [], serverKnowledge: 60 }],
    monthDetail: [aMonthDetail('2026-10-01', [FOOD]), aMonthDetail('2026-09-01', [FOOD])],
    ...script,
  };
}

describe('a budget’s sync status', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let engine: SyncEngine;
  let clock: Date;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
    clock = new Date('2026-11-08T09:00:00.000Z');
    engine = createSyncEngine({
      db,
      client: createStubClient(aScript()),
      now: () => clock,
    });
  });

  afterEach(async () => {
    await harness.close();
  });

  it('names every resource, including the ones never fetched', async () => {
    const status = await syncStatus(db, BUDGET_ID);

    // A resource with no row is the thing the screen exists to show. Leaving
    // it out of the list would read as nothing being wrong.
    expect(status.resources.map((resource) => resource.resource)).toEqual([...SYNC_RESOURCES]);
    expect(status.resources.every((resource) => resource.syncedAt === null)).toBe(true);
    expect(status.lastFetchedAt).toBeNull();
  });

  it('carries each resource’s own knowledge and fetch time', async () => {
    await engine.syncBudget(BUDGET_ID);

    const status = await syncStatus(db, BUDGET_ID);
    const byResource = new Map(status.resources.map((entry) => [entry.resource, entry]));

    expect(byResource.get('accounts')?.knowledge).toBe(10);
    expect(byResource.get('transactions')?.knowledge).toBe(50);
    expect(byResource.get('transactions')?.syncedAt).toBe('2026-11-08T09:00:00.000Z');
  });

  it('reports the most recent fetch as the last fetch', async () => {
    await engine.syncBudget(BUDGET_ID);

    clock = new Date('2026-11-08T11:30:00.000Z');
    await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');

    const status = await syncStatus(db, BUDGET_ID);

    // The newest, not the oldest: the display answers when Lumy last heard
    // from YNAB, and which resource is furthest behind is the list.
    expect(status.lastFetchedAt).toBe('2026-11-08T11:30:00.000Z');
  });

  it('groups the months of detail rather than listing them', async () => {
    await engine.syncBudget(BUDGET_ID);
    await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');
    clock = new Date('2026-11-08T12:00:00.000Z');
    await engine.syncMonthDetail(BUDGET_ID, '2026-09-01');

    const status = await syncStatus(db, BUDGET_ID);

    // One row per month, so this is the only part of the result that is not
    // bounded by the resource list.
    expect(status.monthDetail).toEqual({ months: 2, syncedAt: '2026-11-08T12:00:00.000Z' });
  });

  it('answers only for the budget asked about', async () => {
    await engine.syncBudget(BUDGET_ID);

    const status = await syncStatus(db, 'budget-2');

    expect(status.lastFetchedAt).toBeNull();
  });
});

describe('whether a budget has been synced', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let engine: SyncEngine;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
    engine = createSyncEngine({ db, client: createStubClient(aScript()) });
  });

  afterEach(async () => {
    await harness.close();
  });

  it('is false for a budget nothing has been fetched for', async () => {
    expect(await hasSyncedData(db, BUDGET_ID)).toBe(false);
  });

  it('is true once every resource has landed', async () => {
    await engine.syncBudget(BUDGET_ID);

    expect(await hasSyncedData(db, BUDGET_ID)).toBe(true);
  });

  it('is false while a resource is still missing', async () => {
    await engine.syncBudget(BUDGET_ID);
    // What a first sync that failed partway leaves: the resources before the
    // failure have knowledge rows and the ones after it do not. Answering true
    // to that would drop someone into a shell holding part of a budget.
    await db.run('DELETE FROM server_knowledge WHERE budget_id = ? AND resource = ?', [
      BUDGET_ID,
      'transactions',
    ]);

    expect(await hasSyncedData(db, BUDGET_ID)).toBe(false);
  });

  it('does not let a month of detail stand in for a resource', async () => {
    await engine.syncBudget(BUDGET_ID);
    await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');
    // One resource short, and a month of detail alongside it. Counting every
    // resource in the table rather than only the synced ones would make these
    // six distinct values add up to a synced budget.
    await db.run('DELETE FROM server_knowledge WHERE budget_id = ? AND resource = ?', [
      BUDGET_ID,
      'transactions',
    ]);

    expect(await hasSyncedData(db, BUDGET_ID)).toBe(false);
  });

  it('does not count a month of detail towards it', async () => {
    await engine.syncBudget(BUDGET_ID);
    await engine.syncMonthDetail(BUDGET_ID, '2026-10-01');
    await db.run('DELETE FROM server_knowledge WHERE budget_id = ? AND resource != ?', [
      BUDGET_ID,
      'month_detail',
    ]);

    // Month detail is fetched on demand, so a budget can be fully synced with
    // none of it — and a month of it on its own is not a synced budget.
    expect(await hasSyncedData(db, BUDGET_ID)).toBe(false);
  });

  it('is false again after the data is deleted', async () => {
    await engine.syncBudget(BUDGET_ID);
    await engine.deleteAllSyncedData();

    expect(await hasSyncedData(db, BUDGET_ID)).toBe(false);
  });

  it('is asked of one budget at a time', async () => {
    await engine.syncBudget(BUDGET_ID);

    expect(await hasSyncedData(db, 'budget-2')).toBe(false);
  });
});
