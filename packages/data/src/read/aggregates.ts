import type { Milliunits } from '@lumy/money';

import type { Queryable, SqlValue } from '../adapters/types';
import {
  compileCondition,
  conditionForFilter,
  type CompiledStatement,
  type LedgerCondition,
  type LedgerFilter,
} from './conditions';

/**
 * The aggregates: every number the app shows that is not a row of a list.
 *
 * Each is one query, and SQLite computes it. Nothing here reads entries into
 * JavaScript to add them up — that is the work the Flutter app did on every
 * stream emission, once per payee and again once per category, each pass
 * re-walking the whole transaction list.
 *
 * The grouping keys are bounded by the budget's structure: one row per month,
 * per category, per payee, per account. A result does not grow with the
 * number of transactions, which is what makes these safe to return whole.
 */

export interface AggregateOptions {
  budgetId: string;
  /** The flat form. Ignored when `condition` is given. */
  filter?: LedgerFilter;
  /** The tree form, which is what a spend tracker stores. */
  condition?: LedgerCondition;
  /**
   * What to do about the two sides of a transfer.
   *
   * `all` counts both, which is right for a balance: a transfer between two
   * selected accounts nets to zero on its own. `canonicalSide` counts one,
   * which is right for a flow total, where counting both would report a
   * movement between the user's own accounts as twice the money. `exclude`
   * drops transfers entirely.
   */
  transfers?: 'all' | 'canonicalSide' | 'exclude';
}

/**
 * The side of a transfer pair that a flow total counts.
 *
 * `transfer_pair_key` is the two entry ids sorted and joined, so the canonical
 * side is the part before the separator. Reading it out of the key is an
 * expression rather than a lookup — the alternative, a correlated `MIN` over
 * the pair, would run once per row.
 */
function canonicalTransferSide(table: string): string {
  return `(
    ${table}.transfer_pair_key IS NULL
    OR ${table}.entry_id = substr(
         ${table}.transfer_pair_key, 1, instr(${table}.transfer_pair_key, ':') - 1)
  )`;
}

function transferClause(transfers: AggregateOptions['transfers'], table: string): string {
  switch (transfers ?? 'all') {
    case 'all':
      return '1';
    case 'canonicalSide':
      return canonicalTransferSide(table);
    case 'exclude':
      return `${table}.is_transfer = 0`;
  }
}

interface Where {
  sql: string;
  params: readonly SqlValue[];
}

/**
 * The clause every aggregate below shares.
 *
 * `table` is the alias of `ledger_entries`, which the condition's columns are
 * qualified with — an aggregate that joins `categories` or `accounts` has more
 * than one `budget_id` and more than one `name` in scope.
 */
function whereFor(options: AggregateOptions, table = 'e'): Where {
  const condition = compileCondition(
    options.condition ?? conditionForFilter(options.filter ?? {}),
    { table },
  );

  return {
    sql: `${table}.budget_id = ? AND ${condition.sql} AND ${transferClause(
      options.transfers,
      table,
    )}`,
    params: [options.budgetId, ...condition.params],
  };
}

/** What a sum is grouped by. */
export type Grouping = 'month' | 'category' | 'categoryGroup' | 'payee' | 'account';

interface GroupingSql {
  /** The column the group key comes from. */
  key: string;
  /** How the group's display name is resolved. */
  name: string;
  join: string;
}

/**
 * How each grouping reads its key and its name.
 *
 * The name is wrapped in `MIN` throughout. For a category, group, or account
 * it is functionally dependent on the key and the aggregate is a no-op; for a
 * payee it picks one answer where a payee known only by a name on a row could
 * otherwise offer several.
 */
const GROUPINGS: Record<Grouping, GroupingSql> = {
  month: { key: 'e.month', name: 'NULL', join: '' },
  category: {
    key: 'e.category_id',
    name: 'MIN(c.name)',
    join: 'LEFT JOIN categories c ON c.id = e.category_id',
  },
  categoryGroup: {
    key: 'e.category_group_id',
    name: 'MIN(g.name)',
    join: 'LEFT JOIN category_groups g ON g.id = e.category_group_id',
  },
  payee: {
    key: 'e.payee_id',
    name: 'MIN(COALESCE(p.name, e.payee_name))',
    join: 'LEFT JOIN payees p ON p.id = e.payee_id',
  },
  account: {
    key: 'e.account_id',
    name: 'MIN(a.name)',
    join: 'LEFT JOIN accounts a ON a.id = e.account_id',
  },
};

export interface GroupTotal {
  /** The group's id. Null is the entries that have none of whatever it is. */
  key: string | null;
  /** Resolved for display. Null when grouping by month, which names itself. */
  name: string | null;
  /** YYYY-MM-01. Present only when the sum was also broken down by month. */
  month: string | null;
  total: Milliunits;
  /** Entries in the group, so a chart can label a slice with its count. */
  count: number;
}

export interface SumByOptions extends AggregateOptions {
  by: Grouping;
  /** Also breaks the sum down by month, for a series per group. */
  withMonth?: boolean;
}

/**
 * One row per group, with its total.
 *
 * This is the whole of "grouped aggregates by month, category, category group,
 * payee, and account": the grouping is a parameter because the query is
 * otherwise identical, and what makes a result income rather than spend is the
 * condition, not a different function.
 *
 * It replaces `calculateIncomeExpense`'s nested re-scans — group by month,
 * then per month filter income, filter expenses, group by payee, then sum once
 * per payee and once per category — with one statement.
 */
export function sumByStatement(options: SumByOptions): CompiledStatement {
  const grouping = GROUPINGS[options.by];
  const where = whereFor(options);
  const withMonth = options.withMonth === true && options.by !== 'month';
  const monthKey = withMonth ? 'e.month' : 'NULL';
  const groupBy = withMonth ? `e.month, ${grouping.key}` : grouping.key;

  return {
    sql: `SELECT
       ${grouping.key} AS key,
       ${grouping.name} AS name,
       ${monthKey} AS month,
       SUM(e.amount) AS total,
       COUNT(*) AS count
     FROM ledger_entries e
     ${grouping.join}
     WHERE ${where.sql}
     GROUP BY ${groupBy}
     ORDER BY ${withMonth ? 'e.month, ' : ''}${grouping.key}`,
    params: where.params,
  };
}

export async function sumBy(db: Queryable, options: SumByOptions): Promise<GroupTotal[]> {
  const statement = sumByStatement(options);
  const rows = await db.all<{
    key: string | null;
    name: string | null;
    month: string | null;
    total: number;
    count: number;
  }>(statement.sql, statement.params);

  return rows.map((row) => ({
    key: row.key,
    name: row.name,
    month: row.month,
    total: row.total as Milliunits,
    count: row.count,
  }));
}

export interface Totals {
  total: Milliunits;
  count: number;
  /** The sum of the positive amounts, which is money that came in. */
  inflow: Milliunits;
  /** The sum of the negative amounts, so it is negative. */
  outflow: Milliunits;
}

/**
 * The scalars behind a stat tile: one row, four numbers.
 *
 * Inflow and outflow are split here rather than asked for twice, because a
 * screen showing both would otherwise read the same rows twice to get them.
 */
export function totalsStatement(options: AggregateOptions): CompiledStatement {
  const where = whereFor(options);

  return {
    sql: `SELECT
       SUM(e.amount) AS total,
       COUNT(*) AS count,
       SUM(CASE WHEN e.amount > 0 THEN e.amount ELSE 0 END) AS inflow,
       SUM(CASE WHEN e.amount < 0 THEN e.amount ELSE 0 END) AS outflow
     FROM ledger_entries e
     WHERE ${where.sql}`,
    params: where.params,
  };
}

export async function totals(db: Queryable, options: AggregateOptions): Promise<Totals> {
  const statement = totalsStatement(options);
  const row = await db.get<{
    total: number | null;
    count: number;
    inflow: number | null;
    outflow: number | null;
  }>(statement.sql, statement.params);

  return {
    total: (row?.total ?? 0) as Milliunits,
    count: row?.count ?? 0,
    inflow: (row?.inflow ?? 0) as Milliunits,
    outflow: (row?.outflow ?? 0) as Milliunits,
  };
}

/**
 * The months from `from` to `to` inclusive, as rows.
 *
 * A chart needs a point for a month nothing happened in, and a `GROUP BY`
 * cannot produce a row for a group with no rows. Generated rather than
 * computed in JavaScript and passed back down, so a series is one query.
 */
export const MONTH_SPINE = `WITH RECURSIVE month_spine(month) AS (
    SELECT ?
    UNION ALL
    SELECT date(month, '+1 month') FROM month_spine WHERE month < ?
  )`;

export interface MonthRange {
  /** YYYY-MM-01. */
  from: string;
  /** YYYY-MM-01. */
  to: string;
}

export interface SavingsRate {
  month: string;
  income: Milliunits;
  /** Negative, as stored. */
  expenses: Milliunits;
  /**
   * The share of income that was not spent, 0–100.
   *
   * Zero when there was no income, because a rate with nothing to divide by
   * states nothing; 100 when there was income and no spending.
   */
  rate: number;
}

/**
 * The savings rate for each month in a range.
 *
 * `(income + expenses) / income`, clamped to 0–100 — expenses are negative, so
 * the addition is a subtraction. One row per month including the months with
 * no activity, which is what the Month in Review comparison plots against.
 */
export function savingsRateStatement(
  options: AggregateOptions & MonthRange,
): CompiledStatement {
  const where = whereFor(options);

  return {
    // Grouped first, then joined onto the spine. Joining the other way round
    // makes the entries the inner side of the join and reads them once per
    // month in the range rather than once in total.
    sql: `${MONTH_SPINE},
     monthly AS (
       SELECT
         e.month AS month,
         SUM(CASE WHEN e.is_income = 1 THEN e.amount END) AS income,
         SUM(CASE WHEN e.is_expense = 1 THEN e.amount END) AS expenses
       FROM ledger_entries e
       WHERE ${where.sql}
       GROUP BY e.month
     )
     SELECT
       s.month AS month,
       COALESCE(m.income, 0) AS income,
       COALESCE(m.expenses, 0) AS expenses
     FROM month_spine s
     LEFT JOIN monthly m ON m.month = s.month
     ORDER BY s.month`,
    params: [options.from, options.to, ...where.params],
  };
}

export async function savingsRateByMonth(
  db: Queryable,
  options: AggregateOptions & MonthRange,
): Promise<SavingsRate[]> {
  const statement = savingsRateStatement(options);
  const rows = await db.all<{ month: string; income: number; expenses: number }>(
    statement.sql,
    statement.params,
  );

  return rows.map((row) => {
    const income = row.income;
    const expenses = row.expenses;
    const rate =
      income <= 0 ? 0 : expenses >= 0 ? 100 : Math.min(100, Math.max(0, ((income + expenses) / income) * 100));

    return {
      month: row.month,
      income: income as Milliunits,
      expenses: expenses as Milliunits,
      rate,
    };
  });
}
