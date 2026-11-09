import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { createSyncEngine } from '../sync/engine';
import { aBudget, createHarness, createStubClient, type Harness } from '../testing';
import { listBudgets } from './budgets';

/**
 * The budget picker's source.
 *
 * It reads the table rather than YNAB, and `syncBudgetList` is what fills it.
 * So the ordering is asserted here, in SQL, rather than in a sort the screen
 * applies after the fact.
 */

describe('the stored budget list', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
  });

  afterEach(async () => {
    await harness.close();
  });

  it('is empty before anything has been fetched', async () => {
    expect(await listBudgets(db)).toEqual([]);
  });

  it('carries each budget’s name and currency', async () => {
    const engine = createSyncEngine({
      db,
      client: createStubClient({
        budgets: [aBudget({ id: 'budget-1', name: 'Household' })],
      }),
    });

    await engine.syncBudgetList();

    expect(await listBudgets(db)).toEqual([
      { id: 'budget-1', name: 'Household', isoCode: 'USD', lastModifiedOn: '2026-10-29T00:00:00Z' },
    ]);
  });

  it('puts the most recently used first', async () => {
    const engine = createSyncEngine({
      db,
      client: createStubClient({
        budgets: [
          aBudget({ id: 'older', name: 'Older', lastModifiedOn: '2026-01-01T00:00:00Z' }),
          aBudget({ id: 'newer', name: 'Newer', lastModifiedOn: '2026-10-01T00:00:00Z' }),
        ],
      }),
    });

    await engine.syncBudgetList();

    expect((await listBudgets(db)).map((budget) => budget.id)).toEqual(['newer', 'older']);
  });

  it('sorts a budget with no timestamp to the end rather than the top', async () => {
    const engine = createSyncEngine({
      db,
      client: createStubClient({
        budgets: [
          aBudget({ id: 'unknown', name: 'Unknown', lastModifiedOn: null }),
          aBudget({ id: 'known', name: 'Known', lastModifiedOn: '2026-01-01T00:00:00Z' }),
        ],
      }),
    });

    await engine.syncBudgetList();

    // An absent timestamp is not the oldest answer, it is no answer — and
    // ordering by the column alone would sort it ahead of every budget that
    // has one, which is the opposite of what it means.
    expect((await listBudgets(db)).map((budget) => budget.id)).toEqual(['known', 'unknown']);
  });

  it('breaks a tie by name, so the list does not reorder between renders', async () => {
    const engine = createSyncEngine({
      db,
      client: createStubClient({
        budgets: [
          aBudget({ id: 'b', name: 'Beta', lastModifiedOn: '2026-01-01T00:00:00Z' }),
          aBudget({ id: 'a', name: 'Alpha', lastModifiedOn: '2026-01-01T00:00:00Z' }),
        ],
      }),
    });

    await engine.syncBudgetList();

    expect((await listBudgets(db)).map((budget) => budget.id)).toEqual(['a', 'b']);
  });

  it('keeps a budget YNAB sent no currency format for', async () => {
    const engine = createSyncEngine({
      db,
      client: createStubClient({
        budgets: [aBudget({ id: 'budget-1', currencyFormat: null })],
      }),
    });

    await engine.syncBudgetList();

    // The join is a left join for this: a budget with no format is still a
    // budget someone can choose, and dropping it would leave them unable to.
    expect(await listBudgets(db)).toMatchObject([{ id: 'budget-1', isoCode: null }]);
  });
});
