import type { Milliunits } from '@lumy/money';

import type { Queryable, SqlValue } from '../adapters/types';

/**
 * The targets health report: how a category's spending compares with what its
 * target asks for, per month.
 *
 * Two different kinds of work, kept apart on purpose.
 *
 * Turning a target into a monthly amount is arithmetic over one category row's
 * own columns — YNAB states a target as a balance plus a cadence, and a weekly
 * target of £50 is a different monthly number from a yearly one. That is a
 * per-row derivation, not an aggregate, and it is a dozen cases over three
 * columns. It lives in TypeScript, where it can be read and unit-tested; in
 * the Flutter app the same `switch` lived behind two getters on a model and had
 * no tests at all.
 *
 * The aggregate — what was actually spent per category over a window — stays
 * in SQL, which is the part that would otherwise scan the ledger once per
 * category. Each category gets its own window, so the two are joined as a
 * table of values rather than queried per category.
 */

/** YNAB's `goal_cadence`, which the app calls a target cadence. */
const CADENCE_MONTHLY = 1;
const CADENCE_WEEKLY = 2;
const CADENCE_YEARLY = 13;
const CADENCE_EVERY_TWO_YEARS = 14;

/** Weeks in an average month, which is how YNAB's own weekly targets convert. */
const WEEKS_PER_MONTH = 4.35;

/** Days in an average month, used to turn a target's date range into months. */
const DAYS_PER_MONTH = 30.44;

/** YNAB's `goal_type`. */
export type TargetType = 'TB' | 'TBD' | 'MF' | 'NEED' | 'DEBT';

/** The target fields of one category, as stored. */
export interface CategoryTarget {
  type: string | null;
  balance: number | null;
  cadence: number | null;
  cadenceFrequency: number | null;
  /** YYYY-MM-01. */
  creationMonth: string | null;
  /** YYYY-MM-01. */
  month: string | null;
}

/** Whole months between two YYYY-MM-01 dates, rounded up, as YNAB's own maths does. */
function monthsBetween(from: string, to: string): number {
  const days = (Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) / 86_400_000;

  return Math.ceil(days / DAYS_PER_MONTH);
}

/**
 * How often the target comes due, in months.
 *
 * Null when the target says nothing a monthly figure can be built from: a
 * target balance with no date has no cadence at all, and a weekly target that
 * works out at one month or less is already monthly.
 */
export function monthsInTargetCadence(target: CategoryTarget): number | null {
  switch (target.type) {
    case 'TBD':
      return target.creationMonth === null || target.month === null
        ? null
        : monthsBetween(target.creationMonth, target.month);

    case 'MF':
      return target.balance === null ? null : 1;

    case 'NEED':
    // DEBT behaves as NEED does. YNAB does not document it.
    case 'DEBT': {
      if (target.cadence === null || target.balance === null) return null;

      if (target.cadence === CADENCE_MONTHLY) return target.cadenceFrequency ?? 1;
      if (target.cadence === CADENCE_WEEKLY) {
        if (target.cadenceFrequency === null) return null;
        const months = Math.ceil((1 / WEEKS_PER_MONTH) * target.cadenceFrequency);

        return months <= 1 ? null : months;
      }
      if (target.cadence === CADENCE_YEARLY) return (target.cadenceFrequency ?? 1) * 12;
      if (target.cadence === CADENCE_EVERY_TWO_YEARS) {
        return (target.cadenceFrequency ?? 1) * 24;
      }

      // YNAB's cadences 3–12 mean "every N months", and N is the cadence.
      if (target.cadence >= 3 && target.cadence <= 12) return target.cadence;

      return null;
    }

    default:
      // A plain target balance has no date, so no monthly figure follows from
      // it, and a category with no target has nothing to convert.
      return null;
  }
}

/**
 * What the target asks for each month.
 *
 * Integer division throughout, because the figure is milliunits and a target
 * split across months cannot ask for a fraction of one.
 */
export function monthlyNeededForTarget(target: CategoryTarget): number | null {
  const balance = target.balance;

  switch (target.type) {
    case 'TBD': {
      if (target.creationMonth === null || target.month === null || balance === null) return null;

      return Math.trunc(balance / monthsBetween(target.creationMonth, target.month));
    }

    case 'MF':
      return balance ?? 0;

    case 'NEED':
    case 'DEBT': {
      if (target.cadence === null || balance === null) return null;

      if (target.cadence >= 3 && target.cadence <= 12) {
        return Math.trunc(balance / target.cadence);
      }
      if (target.cadence === CADENCE_MONTHLY) {
        return target.cadenceFrequency === null
          ? balance
          : Math.trunc(balance / target.cadenceFrequency);
      }
      if (target.cadence === CADENCE_WEEKLY) {
        return target.cadenceFrequency === null
          ? Math.ceil(balance * WEEKS_PER_MONTH)
          : Math.ceil(Math.trunc(balance / target.cadenceFrequency) * WEEKS_PER_MONTH);
      }
      if (target.cadence === CADENCE_YEARLY) {
        return target.cadenceFrequency === null
          ? Math.trunc(balance / 12)
          : Math.trunc(Math.trunc(balance / target.cadenceFrequency) / 12);
      }
      if (target.cadence === CADENCE_EVERY_TWO_YEARS) {
        return target.cadenceFrequency === null
          ? Math.trunc(balance / 24)
          : Math.trunc(Math.trunc(balance / (target.cadenceFrequency * 2)) / 12);
      }

      return null;
    }

    default:
      return null;
  }
}

/** A category has a recurring target when it repeats on a cadence. */
export function hasRecurringTarget(target: CategoryTarget): boolean {
  return target.type !== null && target.cadence !== null && target.cadence > 0;
}

export interface CategoryTargetHealth {
  categoryId: string;
  categoryName: string;
  categoryGroupId: string;
  /** What the target asks for each month. Positive. */
  monthlyNeeded: Milliunits;
  /** Average spend per month over the window. Negative. */
  monthlySpent: Milliunits;
  /**
   * `monthlyNeeded + monthlySpent`, so negative means overspending.
   *
   * The addition is a subtraction: spend is stored negative.
   */
  gap: Milliunits;
  /** How many months the average was taken over, which differs per category. */
  monthsAveraged: number;
}

export interface TargetHealthReport {
  /** `needsAttention` when any category is overspending its target. */
  status: 'healthy' | 'needsAttention';
  /** Worst gap first. Categories with no spending are left out. */
  categories: readonly CategoryTargetHealth[];
}

interface CategoryRow {
  id: string;
  name: string;
  category_group_id: string;
  target_type: string | null;
  target_balance: number | null;
  target_cadence: number | null;
  target_cadence_frequency: number | null;
  target_creation_month: string | null;
  target_month: string | null;
}

export interface TargetHealthOptions {
  budgetId: string;
  /** The period the report is for. YYYY-MM-DD. */
  from: string;
  to: string;
}

/** Whole months the range spans, counting both ends. */
function monthsInRange(from: string, to: string): number {
  const [fromYear, fromMonth] = from.split('-').map(Number);
  const [toYear, toMonth] = to.split('-').map(Number);

  return Math.max(1, (toYear - fromYear) * 12 + (toMonth - fromMonth) + 1);
}

/** The date `months` before `to`, as YYYY-MM-DD. */
function subtractMonths(to: string, months: number): string {
  const date = new Date(`${to}T00:00:00Z`);
  date.setUTCMonth(date.getUTCMonth() - months);

  return date.toISOString().slice(0, 10);
}

/**
 * Each recurring target against what the category actually spent.
 *
 * A category whose target comes due less often than the period is long is
 * averaged over its own cadence instead — an annual target measured over three
 * months would otherwise look like twelve times the overspend it is. So each
 * category carries its own window, and the windows are joined into the
 * aggregate as a table of values: one query, whatever the budget's shape.
 */
export async function targetHealth(
  db: Queryable,
  options: TargetHealthOptions,
): Promise<TargetHealthReport> {
  const rows = await db.all<CategoryRow>(
    `SELECT
       id, name, category_group_id,
       target_type, target_balance, target_cadence, target_cadence_frequency,
       target_creation_month, target_month
     FROM categories
     WHERE budget_id = ? AND deleted = 0 AND hidden = 0 AND target_type IS NOT NULL`,
    [options.budgetId],
  );

  const periodMonths = monthsInRange(options.from, options.to);

  const windows = rows.flatMap((row) => {
    const target: CategoryTarget = {
      type: row.target_type,
      balance: row.target_balance,
      cadence: row.target_cadence,
      cadenceFrequency: row.target_cadence_frequency,
      creationMonth: row.target_creation_month,
      month: row.target_month,
    };
    if (!hasRecurringTarget(target)) return [];

    const monthlyNeeded = monthlyNeededForTarget(target);
    if (monthlyNeeded === null) return [];

    const cadenceMonths = monthsInTargetCadence(target);
    const useCadence = cadenceMonths !== null && cadenceMonths > periodMonths;
    const monthsAveraged = useCadence ? cadenceMonths : periodMonths;

    return [
      {
        row,
        monthlyNeeded,
        monthsAveraged,
        from: useCadence ? subtractMonths(options.to, cadenceMonths) : options.from,
      },
    ];
  });

  if (windows.length === 0) return { status: 'healthy', categories: [] };

  // The values table first, then the two parameters the join carries, which is
  // the order the statement reads them in.
  const params: SqlValue[] = windows.flatMap((window) => [window.row.id, window.from]);
  params.push(options.budgetId, options.to);

  const spent = await db.all<{ category_id: string; total: number }>(
    `WITH windows(category_id, from_date) AS (VALUES ${windows
      .map(() => '(?, ?)')
      .join(', ')})
     SELECT w.category_id AS category_id, COALESCE(SUM(e.amount), 0) AS total
     FROM windows w
     LEFT JOIN ledger_entries e
       ON e.category_id = w.category_id
       AND e.budget_id = ?
       AND e.is_expense = 1
       AND e.date >= w.from_date
       AND e.date <= ?
     GROUP BY w.category_id`,
    params,
  );

  const totalByCategory = new Map(spent.map((row) => [row.category_id, row.total]));

  const categories = windows
    .map((window): CategoryTargetHealth => {
      const total = totalByCategory.get(window.row.id) ?? 0;
      const monthlySpent = Math.trunc(total / window.monthsAveraged);

      return {
        categoryId: window.row.id,
        categoryName: window.row.name,
        categoryGroupId: window.row.category_group_id,
        monthlyNeeded: window.monthlyNeeded as Milliunits,
        monthlySpent: monthlySpent as Milliunits,
        gap: (window.monthlyNeeded + monthlySpent) as Milliunits,
        monthsAveraged: window.monthsAveraged,
      };
    })
    // A category nothing was spent in says nothing about the health of its
    // target, and would otherwise sit at the healthy end of every report.
    .filter((category) => category.monthlySpent < 0)
    .sort((a, b) => a.gap - b.gap);

  return {
    status: categories.some((category) => category.gap < 0) ? 'needsAttention' : 'healthy',
    categories,
  };
}
