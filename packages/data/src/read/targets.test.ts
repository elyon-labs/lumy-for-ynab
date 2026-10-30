import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter, SqlValue } from '../adapters/types';
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
import {
  monthlyNeededForTarget,
  monthsInTargetCadence,
  targetHealth,
  type CategoryTarget,
} from './targets';

function aTarget(target: Partial<CategoryTarget> = {}): CategoryTarget {
  return {
    type: null,
    balance: null,
    cadence: null,
    cadenceFrequency: null,
    creationMonth: null,
    month: null,
    ...target,
  };
}

describe('a target as a monthly amount', () => {
  describe('monthly funding', () => {
    it('asks for its balance every month', () => {
      expect(monthlyNeededForTarget(aTarget({ type: 'MF', balance: 50_000 }))).toBe(50_000);
      expect(monthsInTargetCadence(aTarget({ type: 'MF', balance: 50_000 }))).toBe(1);
    });
  });

  describe('a balance by a date', () => {
    it('spreads the balance over the months between creation and the target', () => {
      const target = aTarget({
        type: 'TBD',
        balance: 120_000,
        creationMonth: '2026-01-01',
        month: '2027-01-01',
      });

      // 365 days over 30.44 rounds up to 12 months.
      expect(monthsInTargetCadence(target)).toBe(12);
      expect(monthlyNeededForTarget(target)).toBe(10_000);
    });

    it('says nothing without both dates', () => {
      const target = aTarget({ type: 'TBD', balance: 120_000, month: '2027-01-01' });

      expect(monthlyNeededForTarget(target)).toBeNull();
    });
  });

  describe('a needed amount', () => {
    it.each([
      ['monthly, every month', { cadence: 1, cadenceFrequency: null }, 50_000, 1],
      ['monthly, every third month', { cadence: 1, cadenceFrequency: 3 }, 16_666, 3],
      ['every four months', { cadence: 4, cadenceFrequency: null }, 12_500, 4],
      // 50,000 a week is 4.35 weeks' worth a month, rounded up.
      ['weekly', { cadence: 2, cadenceFrequency: null }, 217_500, null],
      ['every second week', { cadence: 2, cadenceFrequency: 2 }, 108_750, null],
      ['yearly', { cadence: 13, cadenceFrequency: null }, 4_166, 12],
      ['every second year', { cadence: 13, cadenceFrequency: 2 }, 2_083, 24],
      ['every two years', { cadence: 14, cadenceFrequency: null }, 2_083, 24],
    ])('converts %s', (_name, cadence, needed, months) => {
      const target = aTarget({ type: 'NEED', balance: 50_000, ...cadence });

      expect(monthlyNeededForTarget(target)).toBe(needed);
      expect(monthsInTargetCadence(target)).toBe(months);
    });

    it('treats a debt target the same way, which is what YNAB does', () => {
      const need = aTarget({ type: 'NEED', balance: 50_000, cadence: 1 });
      const debt = aTarget({ type: 'DEBT', balance: 50_000, cadence: 1 });

      expect(monthlyNeededForTarget(debt)).toBe(monthlyNeededForTarget(need));
    });
  });

  describe('a plain target balance', () => {
    it('has no monthly amount, because it has no date to spread over', () => {
      expect(monthlyNeededForTarget(aTarget({ type: 'TB', balance: 50_000 }))).toBeNull();
      expect(monthsInTargetCadence(aTarget({ type: 'TB', balance: 50_000 }))).toBeNull();
    });
  });

  it('has nothing to say about a category with no target', () => {
    expect(monthlyNeededForTarget(aTarget())).toBeNull();
  });
});

describe('the target health report', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  async function seedTargetCategory(
    id: string,
    name: string,
    target: Partial<CategoryTarget>,
  ): Promise<void> {
    await seedCategory(db, { id, name, categoryGroupId: 'everyday' });
    const filled = aTarget(target);
    const values: Record<string, SqlValue> = {
      target_type: filled.type,
      target_balance: filled.balance,
      target_cadence: filled.cadence,
      target_cadence_frequency: filled.cadenceFrequency,
      target_creation_month: filled.creationMonth,
      target_month: filled.month,
    };
    const assignments = Object.keys(values)
      .map((column) => `${column} = ?`)
      .join(', ');

    await db.run(`UPDATE categories SET ${assignments} WHERE id = ?`, [
      ...Object.values(values),
      id,
    ]);
  }

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;

    await seedBudget(db);
    await seedAccount(db, { id: 'checking', name: 'Checking' });
    await seedCategoryGroup(db, { id: 'everyday', name: 'Everyday' });
  });

  afterEach(async () => {
    await harness.close();
  });

  it('compares the monthly target with the monthly average spend', async () => {
    await seedTargetCategory('food', 'Groceries', {
      type: 'MF',
      balance: 40_000,
      cadence: 1,
    });
    // 90,000 over three months is 30,000 a month, which is inside the target.
    for (const month of ['08', '09', '10']) {
      await seedTransaction(db, {
        id: `shop-${month}`,
        accountId: 'checking',
        date: `2026-${month}-10`,
        categoryId: 'food',
        amount: -30_000,
      });
    }
    await rebuildLedgerForBudget(db, BUDGET_ID);

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-08-01',
      to: '2026-10-31',
    });

    expect(report.status).toBe('healthy');
    expect(report.categories).toEqual([
      {
        categoryId: 'food',
        categoryName: 'Groceries',
        categoryGroupId: 'everyday',
        monthlyNeeded: 40_000,
        monthlySpent: -30_000,
        gap: 10_000,
        monthsAveraged: 3,
      },
    ]);
  });

  it('needs attention when a category is overspending its target', async () => {
    await seedTargetCategory('food', 'Groceries', { type: 'MF', balance: 10_000, cadence: 1 });
    await seedTransaction(db, {
      id: 'shop',
      accountId: 'checking',
      date: '2026-10-10',
      categoryId: 'food',
      amount: -30_000,
    });
    await rebuildLedgerForBudget(db, BUDGET_ID);

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-10-01',
      to: '2026-10-31',
    });

    expect(report.status).toBe('needsAttention');
    expect(report.categories[0]).toMatchObject({ monthlySpent: -30_000, gap: -20_000 });
  });

  it('averages an annual target over its own cadence, not over a short period', async () => {
    await seedTargetCategory('insurance', 'Insurance', {
      type: 'NEED',
      balance: 120_000,
      cadence: 13,
    });
    // The whole year's premium, paid once, eleven months ago.
    await seedTransaction(db, {
      id: 'premium',
      accountId: 'checking',
      date: '2026-01-15',
      categoryId: 'insurance',
      amount: -120_000,
    });
    await rebuildLedgerForBudget(db, BUDGET_ID);

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-10-01',
      to: '2026-10-31',
    });

    // Averaged over twelve months it matches the target exactly. Averaged over
    // the one-month period it would have read as twelve times the overspend.
    expect(report.categories[0]).toMatchObject({
      monthlyNeeded: 10_000,
      monthlySpent: -10_000,
      monthsAveraged: 12,
    });
    expect(report.status).toBe('healthy');
  });

  it('leaves out a category nothing was spent in', async () => {
    await seedTargetCategory('food', 'Groceries', { type: 'MF', balance: 40_000, cadence: 1 });
    await seedTargetCategory('fun', 'Fun Money', { type: 'MF', balance: 20_000, cadence: 1 });
    await seedTransaction(db, {
      id: 'shop',
      accountId: 'checking',
      date: '2026-10-10',
      categoryId: 'food',
      amount: -10_000,
    });
    await rebuildLedgerForBudget(db, BUDGET_ID);

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-10-01',
      to: '2026-10-31',
    });

    expect(report.categories.map((category) => category.categoryId)).toEqual(['food']);
  });

  it('puts the worst gap first', async () => {
    await seedTargetCategory('food', 'Groceries', { type: 'MF', balance: 40_000, cadence: 1 });
    await seedTargetCategory('fun', 'Fun Money', { type: 'MF', balance: 5_000, cadence: 1 });
    await seedTransaction(db, {
      id: 'shop',
      accountId: 'checking',
      date: '2026-10-10',
      categoryId: 'food',
      amount: -10_000,
    });
    await seedTransaction(db, {
      id: 'treat',
      accountId: 'checking',
      date: '2026-10-11',
      categoryId: 'fun',
      amount: -30_000,
    });
    await rebuildLedgerForBudget(db, BUDGET_ID);

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-10-01',
      to: '2026-10-31',
    });

    expect(report.categories.map((category) => category.categoryId)).toEqual(['fun', 'food']);
  });

  it('ignores a category whose target does not recur', async () => {
    await seedTargetCategory('holiday', 'Holiday', { type: 'TB', balance: 500_000 });
    await seedTransaction(db, {
      id: 'flight',
      accountId: 'checking',
      date: '2026-10-10',
      categoryId: 'holiday',
      amount: -100_000,
    });
    await rebuildLedgerForBudget(db, BUDGET_ID);

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-10-01',
      to: '2026-10-31',
    });

    expect(report.categories).toEqual([]);
    expect(report.status).toBe('healthy');
  });

  it('reads nothing when the budget has no targets at all', async () => {
    await seedCategory(db, { id: 'food', name: 'Groceries', categoryGroupId: 'everyday' });

    const report = await targetHealth(db, {
      budgetId: BUDGET_ID,
      from: '2026-10-01',
      to: '2026-10-31',
    });

    expect(report).toEqual({ status: 'healthy', categories: [] });
  });
});
