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
  seedPayee,
  seedSubtransaction,
  seedTransaction,
  type Harness,
} from '../testing';
import { savingsRateByMonth, sumBy, totals } from './aggregates';

describe('the aggregates', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;

    await seedBudget(db);
    await seedAccount(db, { id: 'checking', name: 'Checking' });
    await seedAccount(db, { id: 'savings', name: 'Savings' });
    await seedPayee(db, { id: 'grocer', name: 'Grocer' });
    await seedPayee(db, { id: 'employer', name: 'Employer' });
    await seedCategoryGroup(db, { id: 'everyday', name: 'Everyday Expenses' });
    await seedCategoryGroup(db, { id: 'internal', name: 'Internal Master Category' });
    await seedCategory(db, { id: 'food', name: 'Groceries', categoryGroupId: 'everyday' });
    await seedCategory(db, { id: 'fun', name: 'Fun Money', categoryGroupId: 'everyday' });
    await seedCategory(db, {
      id: 'ready',
      name: 'Inflow: Ready to Assign',
      categoryGroupId: 'internal',
    });

    // September: one wage, one shop. October: a split and a second shop.
    await seedTransaction(db, {
      id: 'wage-sep',
      accountId: 'checking',
      date: '2026-09-01',
      payeeId: 'employer',
      categoryId: 'ready',
      amount: 300_000,
    });
    await seedTransaction(db, {
      id: 'shop-sep',
      accountId: 'checking',
      date: '2026-09-10',
      payeeId: 'grocer',
      categoryId: 'food',
      amount: -4_000,
    });
    await seedTransaction(db, {
      id: 'split-oct',
      accountId: 'checking',
      date: '2026-10-02',
      payeeId: 'grocer',
      amount: -10_000,
    });
    await seedSubtransaction(db, {
      id: 'split-food',
      transactionId: 'split-oct',
      categoryId: 'food',
      amount: -3_000,
    });
    await seedSubtransaction(db, {
      id: 'split-fun',
      transactionId: 'split-oct',
      categoryId: 'fun',
      amount: -7_000,
    });
    await seedTransaction(db, {
      id: 'shop-oct',
      accountId: 'savings',
      date: '2026-10-20',
      payeeId: 'grocer',
      categoryId: 'food',
      amount: -2_500,
    });

    await rebuildLedgerForBudget(db, BUDGET_ID);
  });

  afterEach(async () => {
    await harness.close();
  });

  describe('grouping', () => {
    it('sums spend by month', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'month',
        condition: { test: 'isExpense' },
      });

      expect(rows).toEqual([
        { key: '2026-09-01', name: null, month: null, total: -4_000, count: 1 },
        { key: '2026-10-01', name: null, month: null, total: -12_500, count: 3 },
      ]);
    });

    it('sums spend by category, naming each one', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'category',
        condition: { test: 'isExpense' },
      });

      expect(rows).toEqual([
        { key: 'food', name: 'Groceries', month: null, total: -9_500, count: 3 },
        { key: 'fun', name: 'Fun Money', month: null, total: -7_000, count: 1 },
      ]);
    });

    it('counts a split as its legs, each under its own category', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'category',
        filter: { from: '2026-10-01', to: '2026-10-31', classifications: ['expense'] },
      });

      expect(rows).toEqual([
        { key: 'food', name: 'Groceries', month: null, total: -5_500, count: 2 },
        { key: 'fun', name: 'Fun Money', month: null, total: -7_000, count: 1 },
      ]);
    });

    it('sums by category group', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'categoryGroup',
        condition: { test: 'isExpense' },
      });

      expect(rows).toEqual([
        { key: 'everyday', name: 'Everyday Expenses', month: null, total: -16_500, count: 4 },
      ]);
    });

    it('sums income by payee', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'payee',
        condition: { test: 'isIncome' },
      });

      expect(rows).toEqual([
        { key: 'employer', name: 'Employer', month: null, total: 300_000, count: 1 },
      ]);
    });

    it('sums by account', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'account',
        condition: { test: 'isExpense' },
      });

      expect(rows).toEqual([
        { key: 'checking', name: 'Checking', month: null, total: -14_000, count: 3 },
        { key: 'savings', name: 'Savings', month: null, total: -2_500, count: 1 },
      ]);
    });

    it('breaks a group down by month when asked', async () => {
      const rows = await sumBy(db, {
        budgetId: BUDGET_ID,
        by: 'category',
        withMonth: true,
        condition: { test: 'isExpense' },
      });

      expect(rows).toEqual([
        { key: 'food', name: 'Groceries', month: '2026-09-01', total: -4_000, count: 1 },
        { key: 'food', name: 'Groceries', month: '2026-10-01', total: -5_500, count: 2 },
        { key: 'fun', name: 'Fun Money', month: '2026-10-01', total: -7_000, count: 1 },
      ]);
    });

    it('groups the entries that have none of whatever it is under null', async () => {
      await seedTransaction(db, {
        id: 'mystery',
        accountId: 'checking',
        date: '2026-10-25',
        amount: -900,
      });
      await rebuildLedgerForBudget(db, BUDGET_ID);

      const rows = await sumBy(db, { budgetId: BUDGET_ID, by: 'category' });

      expect(rows[0]).toEqual({ key: null, name: null, month: null, total: -900, count: 1 });
    });
  });

  describe('transfers', () => {
    beforeEach(async () => {
      await seedTransaction(db, {
        id: 'out',
        accountId: 'checking',
        date: '2026-10-15',
        amount: -50_000,
        transferAccountId: 'savings',
        transferTransactionId: 'in',
      });
      await seedTransaction(db, {
        id: 'in',
        accountId: 'savings',
        date: '2026-10-15',
        amount: 50_000,
        transferAccountId: 'checking',
        transferTransactionId: 'out',
      });
      await rebuildLedgerForBudget(db, BUDGET_ID);
    });

    it('counts both sides by default, which is what a balance needs', async () => {
      const both = await totals(db, {
        budgetId: BUDGET_ID,
        condition: { test: 'isTransfer' },
      });

      expect(both.count).toBe(2);
      expect(both.total).toBe(0);
    });

    it('counts one side for a flow total, so a movement is not doubled', async () => {
      const elected = await totals(db, {
        budgetId: BUDGET_ID,
        condition: { test: 'isTransfer' },
        transfers: 'canonicalSide',
      });

      expect(elected.count).toBe(1);
    });

    it('drops them when asked', async () => {
      const without = await totals(db, {
        budgetId: BUDGET_ID,
        condition: { test: 'isTransfer' },
        transfers: 'exclude',
      });

      expect(without.count).toBe(0);
    });
  });

  describe('totals', () => {
    it('splits inflow from outflow in one read', async () => {
      const result = await totals(db, { budgetId: BUDGET_ID });

      expect(result).toEqual({
        total: 283_500,
        count: 5,
        inflow: 300_000,
        outflow: -16_500,
      });
    });

    it('answers zero rather than null for a window with nothing in it', async () => {
      const result = await totals(db, {
        budgetId: BUDGET_ID,
        filter: { from: '2020-01-01', to: '2020-12-31' },
      });

      expect(result).toEqual({ total: 0, count: 0, inflow: 0, outflow: 0 });
    });
  });

  describe('the savings rate', () => {
    it('is the share of income that was not spent', async () => {
      const rows = await savingsRateByMonth(db, {
        budgetId: BUDGET_ID,
        from: '2026-09-01',
        to: '2026-10-01',
      });

      expect(rows).toEqual([
        {
          month: '2026-09-01',
          income: 300_000,
          expenses: -4_000,
          // 296,000 of 300,000 kept.
          rate: (296_000 / 300_000) * 100,
        },
        { month: '2026-10-01', income: 0, expenses: -12_500, rate: 0 },
      ]);
    });

    it('is zero when there was no income to divide by', async () => {
      const rows = await savingsRateByMonth(db, {
        budgetId: BUDGET_ID,
        from: '2026-10-01',
        to: '2026-10-01',
      });

      expect(rows[0].rate).toBe(0);
    });

    it('is a hundred when there was income and no spending', async () => {
      const rows = await savingsRateByMonth(db, {
        budgetId: BUDGET_ID,
        from: '2026-09-01',
        to: '2026-09-01',
        condition: { test: 'not', of: { test: 'hasCategoryId', ids: ['food'] } },
      });

      expect(rows[0]).toMatchObject({ income: 300_000, expenses: 0, rate: 100 });
    });

    it('returns a row for every month in the range, including the empty ones', async () => {
      const rows = await savingsRateByMonth(db, {
        budgetId: BUDGET_ID,
        from: '2026-07-01',
        to: '2026-10-01',
      });

      expect(rows.map((row) => row.month)).toEqual([
        '2026-07-01',
        '2026-08-01',
        '2026-09-01',
        '2026-10-01',
      ]);
    });
  });
});
