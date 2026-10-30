import type { Milliunits } from '@lumy/money';

import type { Queryable, SqlValue } from '../adapters/types';
import { MONTH_SPINE, totals, type MonthRange } from './aggregates';
import {
  conditionForFilter,
  type CompiledStatement,
  type LedgerFilter,
} from './conditions';

/**
 * Balances over time, and the two charts built on them.
 *
 * An account's balance is not a sum of the ledger. YNAB reports the balance it
 * holds now, and the ledger may not carry the whole history behind it — a
 * budget whose first month is years before anything this client fetched would
 * add up to the wrong number. So a historical balance is derived by rolling
 * *backwards* from what YNAB says today, subtracting everything that has
 * happened since. That is what the Flutter app did too, one transaction at a
 * time in Dart; here it is a window function.
 *
 *     balance at the end of month M = balance now − every entry after M
 *
 * Expressed as a reverse running sum over the months, which is one pass.
 */

/** Which accounts a balance series covers. */
export interface AccountScope {
  /** Defaults to every account in the budget that is not deleted. */
  accountIds?: readonly string[];
  /** Include accounts YNAB has closed. Defaults to false. */
  includeClosed?: boolean;
}

interface Scope {
  sql: string;
  params: readonly SqlValue[];
}

function accountScope(budgetId: string, scope: AccountScope): Scope {
  const parts = ['budget_id = ?', 'deleted = 0'];
  const params: SqlValue[] = [budgetId];

  if (scope.includeClosed !== true) parts.push('closed = 0');
  if (scope.accountIds !== undefined) {
    parts.push(`id IN (${scope.accountIds.map(() => '?').join(', ')})`);
    params.push(...scope.accountIds);
  }

  return { sql: parts.join(' AND '), params };
}

/**
 * Every account's balance at the end of each month in the range.
 *
 * The grid is one row per account per month, which is bounded by the budget's
 * structure and the window asked for rather than by its transaction count.
 *
 * `after_range` is the correction that makes the last month in range mean what
 * it says. Without it the series would end on today's balance whatever date
 * the range stops at, which is what the Flutter charts did.
 */
const ACCOUNT_BALANCES = `${MONTH_SPINE},
  scoped AS (SELECT id, balance FROM accounts WHERE %SCOPE%),
  monthly AS (
    SELECT account_id, month, SUM(amount) AS delta
    FROM ledger_entries
    WHERE budget_id = ? AND month <= ?
    GROUP BY account_id, month
  ),
  after_range AS (
    SELECT account_id, SUM(amount) AS delta
    FROM ledger_entries
    WHERE budget_id = ? AND month > ?
    GROUP BY account_id
  ),
  grid AS (
    SELECT
      a.id AS account_id,
      s.month AS month,
      a.balance - COALESCE(r.delta, 0) AS balance_at_range_end,
      COALESCE(m.delta, 0) AS delta
    FROM scoped a
    CROSS JOIN month_spine s
    LEFT JOIN monthly m ON m.account_id = a.id AND m.month = s.month
    LEFT JOIN after_range r ON r.account_id = a.id
  ),
  rolled AS (
    SELECT
      account_id,
      month,
      balance_at_range_end - COALESCE(
        SUM(delta) OVER (
          PARTITION BY account_id ORDER BY month DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 0) AS balance
    FROM grid
  )`;

function balanceParams(budgetId: string, range: MonthRange, scope: Scope): SqlValue[] {
  return [
    range.from,
    range.to,
    ...scope.params,
    budgetId,
    range.to,
    budgetId,
    range.to,
  ];
}

export interface AccountBalance {
  accountId: string;
  accountName: string | null;
  /** YYYY-MM-01. */
  month: string;
  balance: Milliunits;
}

/**
 * The three shapes the rollback is read in.
 *
 * Exported so the performance suite can hold the statement that ships to its
 * query plan — an index narrowed back to its old shape shows up there on any
 * machine, where in a timing it shows up only on a slow one.
 */
export function accountBalancesStatement(
  options: MonthRange & AccountScope & { budgetId: string },
): CompiledStatement {
  const scope = accountScope(options.budgetId, options);

  return {
    sql: `${ACCOUNT_BALANCES.replace('%SCOPE%', scope.sql)}
     SELECT r.account_id, a.name AS account_name, r.month, r.balance
     FROM rolled r
     LEFT JOIN accounts a ON a.id = r.account_id
     ORDER BY r.month, a.name`,
    params: balanceParams(options.budgetId, options, scope),
  };
}

/** One row per account per month: what the days-buffer and net-worth charts walk. */
export async function accountBalancesOverTime(
  db: Queryable,
  options: MonthRange & AccountScope & { budgetId: string },
): Promise<AccountBalance[]> {
  const statement = accountBalancesStatement(options);
  const rows = await db.all<{
    account_id: string;
    account_name: string | null;
    month: string;
    balance: number;
  }>(statement.sql, statement.params);

  return rows.map((row) => ({
    accountId: row.account_id,
    accountName: row.account_name,
    month: row.month,
    balance: row.balance as Milliunits,
  }));
}

export interface TotalBalance {
  /** YYYY-MM-01. */
  month: string;
  balance: Milliunits;
}

export function totalBalanceStatement(
  options: MonthRange & AccountScope & { budgetId: string },
): CompiledStatement {
  const scope = accountScope(options.budgetId, options);

  return {
    sql: `${ACCOUNT_BALANCES.replace('%SCOPE%', scope.sql)}
     SELECT month, SUM(balance) AS balance
     FROM rolled
     GROUP BY month
     ORDER BY month`,
    params: balanceParams(options.budgetId, options, scope),
  };
}

/** The accounts in scope added together, one row per month. */
export async function totalBalanceOverTime(
  db: Queryable,
  options: MonthRange & AccountScope & { budgetId: string },
): Promise<TotalBalance[]> {
  const statement = totalBalanceStatement(options);
  const rows = await db.all<{ month: string; balance: number }>(
    statement.sql,
    statement.params,
  );

  return rows.map((row) => ({ month: row.month, balance: row.balance as Milliunits }));
}

export interface NetWorthPoint {
  /** YYYY-MM-01. */
  month: string;
  /** The accounts in credit, summed. */
  assets: Milliunits;
  /** The accounts in debt, summed, so it is negative. */
  liabilities: Milliunits;
  netWorth: Milliunits;
}

/**
 * Net worth for each month in the range.
 *
 * Assets and liabilities are split per account and per month, because which
 * side an account falls on is a question about its balance *then* — a card
 * paid off in March is a liability in February and an asset in April.
 *
 * Transfers need no special handling. A transfer between two accounts in scope
 * appears once on each side and nets to zero, which is correct; one that
 * leaves the scope appears once, which is also correct.
 */
export function netWorthStatement(
  options: MonthRange & AccountScope & { budgetId: string },
): CompiledStatement {
  const scope = accountScope(options.budgetId, options);

  return {
    sql: `${ACCOUNT_BALANCES.replace('%SCOPE%', scope.sql)}
     SELECT
       month,
       SUM(CASE WHEN balance >= 0 THEN balance ELSE 0 END) AS assets,
       SUM(CASE WHEN balance < 0 THEN balance ELSE 0 END) AS liabilities,
       SUM(balance) AS net_worth
     FROM rolled
     GROUP BY month
     ORDER BY month`,
    params: balanceParams(options.budgetId, options, scope),
  };
}

export async function netWorthOverTime(
  db: Queryable,
  options: MonthRange & AccountScope & { budgetId: string },
): Promise<NetWorthPoint[]> {
  const statement = netWorthStatement(options);
  const rows = await db.all<{
    month: string;
    assets: number;
    liabilities: number;
    net_worth: number;
  }>(statement.sql, statement.params);

  return rows.map((row) => ({
    month: row.month,
    assets: row.assets as Milliunits,
    liabilities: row.liabilities as Milliunits,
    netWorth: row.net_worth as Milliunits,
  }));
}

export interface DaysBufferPoint {
  /** YYYY-MM-01. */
  month: string;
  balance: Milliunits;
  /**
   * How many days that balance covers at the period's average spend.
   *
   * Null when there was no spending to divide by — a buffer against nothing
   * is not infinite, it is unanswerable.
   */
  buffer: number | null;
}

export interface DaysBufferResult {
  /** Across the accounts in scope, as YNAB reports them now. */
  totalBalance: Milliunits;
  /** Negative, as stored. */
  totalSpend: Milliunits;
  /** Average spend per day over the range, truncated. Negative. */
  dailyOutflow: Milliunits;
  /** The buffer at the end of the range, floored. Null when nothing was spent. */
  currentBuffer: number | null;
  series: readonly DaysBufferPoint[];
}

/** Whole days from `from` to `to` inclusive, which is what the average divides by. */
function daysInRange(from: string, to: string): number {
  const start = Date.parse(`${from}T00:00:00Z`);
  const end = Date.parse(`${to}T00:00:00Z`);

  return Math.max(1, Math.round((end - start) / 86_400_000) + 1);
}

export interface DaysBufferOptions extends AccountScope, MonthRange {
  budgetId: string;
  /** The date range the average spend is measured over. YYYY-MM-DD. */
  from: string;
  to: string;
  /** Narrows which spending counts, for the chart's category selection. */
  filter?: LedgerFilter;
}

/**
 * How long the money on hand would last at the period's rate of spending.
 *
 * Two numbers and a series: the balance at each month, and that balance over
 * the average daily spend. The spend is whatever the filter selects, so the
 * chart's category selection narrows the denominator and not the balance.
 *
 * `from` and `to` are dates, and the series' months are the months they span.
 */
export async function daysBuffer(
  db: Queryable,
  options: DaysBufferOptions,
): Promise<DaysBufferResult> {
  const monthRange = {
    from: `${options.from.slice(0, 7)}-01`,
    to: `${options.to.slice(0, 7)}-01`,
  };

  const spend = await totals(db, {
    budgetId: options.budgetId,
    condition: {
      test: 'all',
      of: [
        { test: 'isExpense' },
        { test: 'dateRange', from: options.from, to: options.to },
        ...(options.filter === undefined ? [] : [conditionForFilter(options.filter)]),
      ],
    },
  });

  const balances = await totalBalanceOverTime(db, { ...options, ...monthRange });

  const days = daysInRange(options.from, options.to);
  const totalSpend = spend.total;
  // Truncated, not rounded, and toward zero on both sides — the same rule
  // `@lumy/money` applies, so a rate and its negation have equal magnitude.
  const dailyOutflow = totalSpend === 0 ? 0 : Math.trunc(totalSpend / days);
  const perDay = Math.abs(dailyOutflow);

  const series = balances.map((point) => ({
    month: point.month,
    balance: point.balance,
    buffer: perDay === 0 ? null : point.balance / perDay,
  }));

  const last = series[series.length - 1];

  return {
    totalBalance: (last?.balance ?? 0) as Milliunits,
    totalSpend,
    dailyOutflow: dailyOutflow as Milliunits,
    currentBuffer: last?.buffer == null ? null : Math.floor(last.buffer),
    series,
  };
}
