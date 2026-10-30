import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import {
  createHarness,
  seedLargeBudget,
  type Harness,
  type LargeBudget,
} from '../testing';
import {
  savingsRateByMonth,
  sumBy,
  sumByStatement,
  totals,
  totalsStatement,
} from './aggregates';
import { daysBuffer, netWorthOverTime, netWorthStatement } from './balances';
import type { CompiledStatement } from './conditions';
import { listLedgerEntries, listTransactions } from './listings';
import { targetHealth } from './targets';

/**
 * The performance budgets from the plan, measured against a budget the size of
 * a real one.
 *
 * These are the numbers that say the engine's premise holds: every figure the
 * app shows comes back from SQL in single-digit to low-double-digit
 * milliseconds over fifty thousand entries. A regression here means an index
 * or a reformulated query, not a cache and not an isolate — that is the whole
 * reason the suite exists rather than a note in a document.
 *
 * Measured as a p95 over repeated runs so one unlucky scheduling slice does
 * not fail the build, with the first run discarded: it pays for preparing the
 * statement, which a screen does once and then never again.
 */

/**
 * The ceilings this suite fails above.
 *
 * Deliberately looser than the measured numbers in the plan, because the
 * timing is the coarse half of the check: it catches an aggregate that has
 * become quadratic, and it has to survive a shared CI runner that can be
 * several times slower than a development machine. The precise half is the
 * query plans asserted below — a dropped or narrowed index changes a plan the
 * same way on every machine, where it changes a timing by an amount that
 * depends on the hardware.
 */
const AGGREGATE_CEILING_MS = 60;
const FIRST_PAGE_CEILING_MS = 25;

const RUNS = 12;

/**
 * The aggregates the suite covers, named so the cases can be collected before
 * the fixture exists.
 */
const AGGREGATE_NAMES = [
  'spend by month',
  'spend by category',
  'spend by category per month',
  'spend by category group',
  'income by payee',
  'spend by account',
  'totals',
  'savings rate by month',
  'net worth over time',
  'days buffer',
  'target health',
  'a filtered total, as a spend tracker asks it',
] as const;

interface Measurement {
  p95: number;
  worst: number;
}

async function measure(work: () => Promise<unknown>): Promise<Measurement> {
  await work();

  const timings: number[] = [];
  for (let run = 0; run < RUNS; run += 1) {
    const started = performance.now();
    await work();
    timings.push(performance.now() - started);
  }
  timings.sort((a, b) => a - b);

  return {
    p95: timings[Math.min(timings.length - 1, Math.ceil(timings.length * 0.95) - 1)],
    worst: timings[timings.length - 1],
  };
}

describe('performance over a large budget', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let budget: LargeBudget;

  beforeAll(async () => {
    harness = await createHarness();
    db = harness.db;
    budget = await seedLargeBudget(db);
  }, 120_000);

  afterAll(async () => {
    await harness.close();
  });

  it('has fifty thousand entries to read', () => {
    expect(budget.entries).toBe(50_000);
  });

  /**
   * Each aggregate, with the number of rows the budget's structure allows.
   *
   * The bound is the point. A result that grows with the number of entries is
   * a result a screen cannot hold, so the count is asserted against what the
   * budget's shape permits and not against what the fixture happens to give.
   *
   * Built when a test runs rather than when the file is collected, because the
   * fixture does not exist until `beforeAll` has made it.
   */
  function aggregates(): {
    name: string;
    run: () => Promise<{ length: number } | object>;
    maxRows: number;
  }[] {
    const range = { from: budget.firstMonth, to: budget.lastMonth };
    const months = 36;
    const categories = budget.categoryIds.length;

    return [
      {
        name: 'spend by month',
        run: () =>
          sumBy(db, {
            budgetId: budget.budgetId,
            by: 'month',
            condition: { test: 'isExpense' },
          }),
        maxRows: months,
      },
      {
        name: 'spend by category',
        run: () =>
          sumBy(db, {
            budgetId: budget.budgetId,
            by: 'category',
            condition: { test: 'isExpense' },
          }),
        maxRows: categories,
      },
      {
        name: 'spend by category per month',
        run: () =>
          sumBy(db, {
            budgetId: budget.budgetId,
            by: 'category',
            withMonth: true,
            condition: { test: 'isExpense' },
          }),
        maxRows: categories * months,
      },
      {
        name: 'spend by category group',
        run: () =>
          sumBy(db, {
            budgetId: budget.budgetId,
            by: 'categoryGroup',
            condition: { test: 'isExpense' },
          }),
        maxRows: budget.categoryGroupIds.length + 1,
      },
      {
        name: 'income by payee',
        run: () =>
          sumBy(db, {
            budgetId: budget.budgetId,
            by: 'payee',
            condition: { test: 'isIncome' },
          }),
        maxRows: budget.payeeIds.length + 1,
      },
      {
        name: 'spend by account',
        run: () =>
          sumBy(db, {
            budgetId: budget.budgetId,
            by: 'account',
            condition: { test: 'isExpense' },
          }),
        maxRows: budget.accountIds.length,
      },
      {
        name: 'totals',
        run: () => totals(db, { budgetId: budget.budgetId, condition: { test: 'isExpense' } }),
        maxRows: 1,
      },
      {
        name: 'savings rate by month',
        run: () => savingsRateByMonth(db, { budgetId: budget.budgetId, ...range }),
        maxRows: months,
      },
      {
        name: 'net worth over time',
        run: () => netWorthOverTime(db, { budgetId: budget.budgetId, ...range }),
        maxRows: months,
      },
      {
        name: 'days buffer',
        run: () =>
          daysBuffer(db, {
            budgetId: budget.budgetId,
            from: budget.firstDate,
            to: budget.lastDate,
          }),
        maxRows: 1,
      },
      {
        name: 'target health',
        run: () =>
          targetHealth(db, {
            budgetId: budget.budgetId,
            from: budget.firstDate,
            to: budget.lastDate,
          }),
        maxRows: 1,
      },
      {
        name: 'a filtered total, as a spend tracker asks it',
        run: () =>
          totals(db, {
            budgetId: budget.budgetId,
            condition: {
              test: 'all',
              of: [
                { test: 'isExpense' },
                { test: 'hasCategoryId', ids: budget.categoryIds.slice(0, 10) },
                { test: 'any', of: [{ test: 'hasFlagColor', colors: ['red', null] }] },
                { test: 'not', of: { test: 'hasMemoKeyword', keyword: 'refund' } },
              ],
            },
          }),
        maxRows: 1,
      },
    ];
  }

  function aggregateNamed(name: string) {
    const found = aggregates().find((aggregate) => aggregate.name === name);
    if (found === undefined) throw new Error(`No aggregate named ${name}.`);

    return found;
  }

  it.each(AGGREGATE_NAMES)('%s stays under its ceiling', async (name) => {
    const measurement = await measure(aggregateNamed(name).run);

    expect(measurement.p95, `p95 ${measurement.p95.toFixed(1)}ms`).toBeLessThan(
      AGGREGATE_CEILING_MS,
    );
  });

  it.each(AGGREGATE_NAMES)('%s returns a bounded result', async (name) => {
    const aggregate = aggregateNamed(name);
    const result = await aggregate.run();
    const rows = Array.isArray(result) ? result.length : 1;

    expect(rows).toBeLessThanOrEqual(aggregate.maxRows);
  });

  it('reads the first page of entries under its ceiling', async () => {
    const measurement = await measure(() =>
      listLedgerEntries(db, { budgetId: budget.budgetId, limit: 50 }),
    );

    expect(measurement.p95, `p95 ${measurement.p95.toFixed(1)}ms`).toBeLessThan(
      FIRST_PAGE_CEILING_MS,
    );
  });

  it('reads the first page of transactions under its ceiling', async () => {
    const measurement = await measure(() =>
      listTransactions(db, { budgetId: budget.budgetId, limit: 50 }),
    );

    expect(measurement.p95, `p95 ${measurement.p95.toFixed(1)}ms`).toBeLessThan(
      FIRST_PAGE_CEILING_MS,
    );
  });

  describe('the plans behind them', () => {
    /**
     * What each hot aggregate must read its answer from.
     *
     * This is the assertion that actually protects the numbers. An index
     * dropped or narrowed shows up here identically on every machine, where
     * in a timing it shows up as a number that may or may not clear a
     * threshold depending on what else the runner is doing.
     */
    const PLANS: { name: string; index: string; noSort?: boolean }[] = [
      { name: 'spend by month', index: 'ledger_spend_by_month', noSort: true },
      { name: 'spend by category per month', index: 'ledger_spend_by_month', noSort: true },
      // Grouped by category alone, the partial index still covers the sum but
      // orders by month first, so the groups are collected afterwards. A sort
      // over a few dozen groups is cheaper than a second index to avoid it.
      { name: 'spend by category', index: 'COVERING INDEX ledger_spend_by_month' },
      { name: 'spend by category group', index: 'ledger_by_group_month', noSort: true },
      { name: 'income by payee per month', index: 'ledger_by_payee_month', noSort: true },
      { name: 'spend by account', index: 'ledger_by_account_month' },
      { name: 'net worth over time', index: 'ledger_by_account_month' },
      // Every chart with a period asks this, and the date range reads off the
      // listing's own index.
      { name: 'a dated expense total', index: 'ledger_by_date_transaction' },
    ];

    /** The statement each named aggregate runs, built against the fixture. */
    function statementFor(name: string): CompiledStatement {
      const range = { from: budget.firstMonth, to: budget.lastMonth };

      switch (name) {
        case 'spend by month':
          return sumByStatement({
            budgetId: budget.budgetId,
            by: 'month',
            condition: { test: 'isExpense' },
          });
        case 'spend by category per month':
          return sumByStatement({
            budgetId: budget.budgetId,
            by: 'category',
            withMonth: true,
            condition: { test: 'isExpense' },
          });
        case 'spend by category':
          return sumByStatement({
            budgetId: budget.budgetId,
            by: 'category',
            condition: { test: 'isExpense' },
          });
        case 'spend by category group':
          return sumByStatement({
            budgetId: budget.budgetId,
            by: 'categoryGroup',
            condition: { test: 'isExpense' },
          });
        case 'income by payee per month':
          return sumByStatement({
            budgetId: budget.budgetId,
            by: 'payee',
            withMonth: true,
            condition: { test: 'isIncome' },
          });
        case 'spend by account':
          return sumByStatement({
            budgetId: budget.budgetId,
            by: 'account',
            condition: { test: 'isExpense' },
          });
        case 'net worth over time':
          return netWorthStatement({ budgetId: budget.budgetId, ...range });
        case 'a dated expense total':
          return totalsStatement({
            budgetId: budget.budgetId,
            condition: {
              test: 'all',
              of: [
                { test: 'isExpense' },
                { test: 'dateRange', from: budget.firstDate, to: budget.lastDate },
              ],
            },
          });
        default:
          throw new Error(`No statement for ${name}.`);
      }
    }

    async function planOf(sql: string, params: readonly unknown[]): Promise<string> {
      const rows = await db.all<{ detail: string }>(
        `EXPLAIN QUERY PLAN ${sql}`,
        params as never,
      );

      return rows.map((row) => row.detail).join('\n');
    }

    it.each(PLANS.map((plan) => [plan.name, plan] as const))(
      '%s reads off its index',
      async (name, plan) => {
        const statement = statementFor(name);
        const detail = await planOf(statement.sql, statement.params);

        expect(detail, detail).toContain(plan.index);
        if (plan.noSort === true) {
          expect(detail, detail).not.toContain('USE TEMP B-TREE');
        }
      },
    );
  });

  it('reads a page deep into the list as fast as the first', async () => {
    // What keyset pagination is for: the thousandth page costs what the first
    // does, where an offset would have counted a thousand pages to get there.
    const first = await listLedgerEntries(db, { budgetId: budget.budgetId, limit: 50 });
    let cursor = first.nextCursor;
    for (let page = 0; page < 20 && cursor !== null; page += 1) {
      cursor = (await listLedgerEntries(db, { budgetId: budget.budgetId, limit: 50, cursor }))
        .nextCursor;
    }

    const measurement = await measure(() =>
      listLedgerEntries(db, { budgetId: budget.budgetId, limit: 50, cursor }),
    );

    expect(measurement.p95, `p95 ${measurement.p95.toFixed(1)}ms`).toBeLessThan(
      FIRST_PAGE_CEILING_MS,
    );
  });
});
