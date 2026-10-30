import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { rebuildLedgerForBudget } from '../ledger';
import {
  BUDGET_ID,
  createHarness,
  seedAccount,
  seedBudget,
  seedCategory,
  seedCategoryGroup,
  seedTransaction,
  type Harness,
} from '../testing';
import * as read from './index';
import { listLedgerEntries, listTransactions } from './listings';

/**
 * The discipline behind goal 2 of the rewrite: no unbounded reads.
 *
 * Every exported function is either an aggregate — a scalar or a set bounded
 * by the budget's structure — or a listing that takes a limit and a cursor.
 * Nothing returns a result whose size grows with the number of entries,
 * because a screen that holds more rows than it renders is the performance
 * problem this engine was built to remove.
 *
 * The map below is the declaration. A function added to the read API without
 * an entry fails this test, which is how the rule survives the surface
 * growing: the author has to say which kind it is.
 */
const KINDS = {
  // Paginated. Takes a limit, returns at most that many rows and a cursor.
  listLedgerEntries: 'listing',
  listTransactions: 'listing',

  // Aggregates. A scalar, or one row per month, category, group, payee, or
  // account — all bounded by the budget's own shape.
  sumBy: 'aggregate',
  totals: 'aggregate',
  savingsRateByMonth: 'aggregate',
  accountBalancesOverTime: 'aggregate',
  totalBalanceOverTime: 'aggregate',
  netWorthOverTime: 'aggregate',
  daysBuffer: 'aggregate',
  targetHealth: 'aggregate',

  // Pure. No database, so nothing to bound: a compiler, a statement builder,
  // or arithmetic over one row's own columns.
  compileCondition: 'pure',
  conditionForFilter: 'pure',
  ledgerEntryPageStatement: 'pure',
  transactionPageStatement: 'pure',
  sumByStatement: 'pure',
  totalsStatement: 'pure',
  savingsRateStatement: 'pure',
  accountBalancesStatement: 'pure',
  totalBalanceStatement: 'pure',
  netWorthStatement: 'pure',
  monthlyNeededForTarget: 'pure',
  monthsInTargetCadence: 'pure',
  hasRecurringTarget: 'pure',
} as const satisfies Record<string, 'listing' | 'aggregate' | 'pure'>;

describe('the read API', () => {
  it('declares every exported function as a listing, an aggregate, or pure', () => {
    const exported = Object.entries(read)
      .filter(([, value]) => typeof value === 'function')
      .map(([name]) => name)
      .sort();

    expect(exported).toEqual(Object.keys(KINDS).sort());
  });

  describe('every listing', () => {
    let harness: Harness;
    let db: DatabaseAdapter;

    beforeEach(async () => {
      harness = await createHarness();
      db = harness.db;

      await seedBudget(db);
      await seedAccount(db, { id: 'checking', name: 'Checking' });
      await seedCategoryGroup(db, { id: 'everyday', name: 'Everyday' });
      await seedCategory(db, { id: 'food', name: 'Groceries', categoryGroupId: 'everyday' });
      for (let index = 0; index < 25; index += 1) {
        await seedTransaction(db, {
          id: `tx-${index}`,
          accountId: 'checking',
          date: `2026-10-${String((index % 28) + 1).padStart(2, '0')}`,
          categoryId: 'food',
        });
      }
      await rebuildLedgerForBudget(db, BUDGET_ID);
    });

    afterEach(async () => {
      await harness.close();
    });

    it.each([
      ['listLedgerEntries', listLedgerEntries],
      ['listTransactions', listTransactions],
    ])('%s returns no more rows than the limit it was given', async (_name, list) => {
      const page = await list(db, { budgetId: BUDGET_ID, limit: 10 });

      expect(page.rows).toHaveLength(10);
      expect(page.nextCursor).not.toBeNull();
    });
  });
});
