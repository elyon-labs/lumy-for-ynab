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
import { accountBalancesOverTime, daysBuffer, netWorthOverTime } from './balances';

/**
 * These all turn on one idea: a balance is rolled back from what YNAB reports
 * now, not summed up from the ledger. So the fixtures state the account's
 * current balance and the transactions behind it, and the tests check that
 * subtracting the latter from the former lands where it should.
 */
describe('balances over time', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;

    await seedBudget(db);
    await seedCategoryGroup(db, { id: 'everyday', name: 'Everyday' });
    await seedCategory(db, { id: 'food', name: 'Groceries', categoryGroupId: 'everyday' });
  });

  afterEach(async () => {
    await harness.close();
  });

  describe('one account', () => {
    beforeEach(async () => {
      // Balance now is 70,000. Spent 10,000 in September and 20,000 in October.
      await seedAccount(db, { id: 'checking', name: 'Checking', balance: 70_000 });
      await seedTransaction(db, {
        id: 'sep',
        accountId: 'checking',
        date: '2026-09-15',
        categoryId: 'food',
        amount: -10_000,
      });
      await seedTransaction(db, {
        id: 'oct',
        accountId: 'checking',
        date: '2026-10-15',
        categoryId: 'food',
        amount: -20_000,
      });
      await rebuildLedgerForBudget(db, BUDGET_ID);
    });

    it('rolls back from the balance YNAB reports now', async () => {
      const rows = await accountBalancesOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-08-01',
        to: '2026-10-01',
      });

      expect(rows.map((row) => [row.month, row.balance])).toEqual([
        // Before either month's spending.
        ['2026-08-01', 100_000],
        // After September, before October.
        ['2026-09-01', 90_000],
        ['2026-10-01', 70_000],
      ]);
    });

    it('ends a range in the past at that month, not at today', async () => {
      const rows = await accountBalancesOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-09-01',
        to: '2026-09-01',
      });

      // 70,000 now, plus the 20,000 October has not spent yet.
      expect(rows.map((row) => row.balance)).toEqual([90_000]);
    });

    it('returns a point for a month with no activity', async () => {
      const rows = await accountBalancesOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-06-01',
        to: '2026-08-01',
      });

      expect(rows.map((row) => [row.month, row.balance])).toEqual([
        ['2026-06-01', 100_000],
        ['2026-07-01', 100_000],
        ['2026-08-01', 100_000],
      ]);
    });
  });

  describe('net worth', () => {
    beforeEach(async () => {
      await seedAccount(db, { id: 'checking', name: 'Checking', balance: 70_000 });
      await seedAccount(db, {
        id: 'card',
        name: 'Card',
        type: 'creditCard',
        balance: -30_000,
      });
      await seedTransaction(db, {
        id: 'spend',
        accountId: 'card',
        date: '2026-10-05',
        categoryId: 'food',
        amount: -30_000,
      });
      await rebuildLedgerForBudget(db, BUDGET_ID);
    });

    it('splits assets from liabilities', async () => {
      const rows = await netWorthOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-01',
      });

      expect(rows).toEqual([
        { month: '2026-10-01', assets: 70_000, liabilities: -30_000, netWorth: 40_000 },
      ]);
    });

    it('asks which side an account was on at the time, not which side it is on now', async () => {
      const rows = await netWorthOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-09-01',
        to: '2026-10-01',
      });

      // The card was at zero in September — an asset of nothing rather than a
      // liability — and only became a debt once October's spending landed.
      expect(rows).toEqual([
        { month: '2026-09-01', assets: 70_000, liabilities: 0, netWorth: 70_000 },
        { month: '2026-10-01', assets: 70_000, liabilities: -30_000, netWorth: 40_000 },
      ]);
    });

    it('nets an internal transfer to nothing', async () => {
      await seedAccount(db, { id: 'savings', name: 'Savings', balance: 50_000 });
      await seedTransaction(db, {
        id: 'out',
        accountId: 'checking',
        date: '2026-10-20',
        amount: -50_000,
        transferAccountId: 'savings',
        transferTransactionId: 'in',
      });
      await seedTransaction(db, {
        id: 'in',
        accountId: 'savings',
        date: '2026-10-20',
        amount: 50_000,
        transferAccountId: 'checking',
        transferTransactionId: 'out',
      });
      await rebuildLedgerForBudget(db, BUDGET_ID);

      const rows = await netWorthOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-09-01',
        to: '2026-10-01',
      });

      // The transfer moves 50,000 between two accounts in scope, so net worth
      // is the same before and after it.
      expect(rows.map((row) => row.netWorth)).toEqual([120_000, 90_000]);
    });

    it('covers only the accounts it was given', async () => {
      const rows = await netWorthOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-01',
        accountIds: ['checking'],
      });

      expect(rows).toEqual([
        { month: '2026-10-01', assets: 70_000, liabilities: 0, netWorth: 70_000 },
      ]);
    });

    it('leaves out a closed account unless asked for it', async () => {
      await seedAccount(db, { id: 'old', name: 'Old', balance: 5_000, closed: true });

      const without = await netWorthOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-01',
      });
      const with_ = await netWorthOverTime(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-01',
        includeClosed: true,
      });

      expect(without[0].assets).toBe(70_000);
      expect(with_[0].assets).toBe(75_000);
    });
  });

  describe('the days buffer', () => {
    beforeEach(async () => {
      await seedAccount(db, { id: 'checking', name: 'Checking', balance: 100_000 });
      // 31,000 spent across October, which is 31 days.
      for (let day = 1; day <= 31; day += 1) {
        await seedTransaction(db, {
          id: `day-${day}`,
          accountId: 'checking',
          date: `2026-10-${String(day).padStart(2, '0')}`,
          categoryId: 'food',
          amount: -1_000,
        });
      }
      await rebuildLedgerForBudget(db, BUDGET_ID);
    });

    it('divides the balance by the average daily spend', async () => {
      const result = await daysBuffer(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-31',
      });

      expect(result.totalSpend).toBe(-31_000);
      expect(result.dailyOutflow).toBe(-1_000);
      expect(result.totalBalance).toBe(100_000);
      expect(result.currentBuffer).toBe(100);
    });

    it('reports a point per month, with the buffer at each', async () => {
      const result = await daysBuffer(db, {
        budgetId: BUDGET_ID,
        from: '2026-09-01',
        to: '2026-10-31',
      });

      // 61 days from 1 September to 31 October, 31,000 spent across them, so
      // 508 a day once truncated.
      expect(result.dailyOutflow).toBe(-508);
      expect(result.series.map((point) => [point.month, point.balance, point.buffer])).toEqual([
        ['2026-09-01', 131_000, 131_000 / 508],
        ['2026-10-01', 100_000, 100_000 / 508],
      ]);
    });

    it('answers nothing rather than infinity when there was no spending', async () => {
      const result = await daysBuffer(db, {
        budgetId: BUDGET_ID,
        from: '2026-08-01',
        to: '2026-08-31',
      });

      expect(result.totalSpend).toBe(0);
      expect(result.dailyOutflow).toBe(0);
      expect(result.currentBuffer).toBeNull();
      expect(result.series.every((point) => point.buffer === null)).toBe(true);
    });

    it('narrows the spending the average is taken over, not the balance', async () => {
      await seedCategory(db, { id: 'fun', name: 'Fun', categoryGroupId: 'everyday' });
      await seedTransaction(db, {
        id: 'treat',
        accountId: 'checking',
        date: '2026-10-10',
        categoryId: 'fun',
        amount: -31_000,
      });
      await rebuildLedgerForBudget(db, BUDGET_ID);

      const result = await daysBuffer(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-31',
        filter: { categoryIds: ['food'] },
      });

      // Only the food spending counts toward the rate, but the balance still
      // reflects every transaction in the account.
      expect(result.totalSpend).toBe(-31_000);
      expect(result.totalBalance).toBe(100_000);
    });
  });
});
