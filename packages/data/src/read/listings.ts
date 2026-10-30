import type { Milliunits } from '@lumy/money';

import type { Queryable, SqlValue } from '../adapters/types';
import {
  compileCondition,
  conditionForFilter,
  type CompiledStatement,
  type LedgerCondition,
  type LedgerFilter,
} from './conditions';

export type { CompiledStatement };

/**
 * The listings: the only reads in this package that return rows.
 *
 * Both are keyset-paginated and both return render-ready rows — names already
 * joined, date-group headers already decided. A screen holds one page and
 * renders it; nothing above here maps, groups, or sorts. Amounts come back as
 * milliunits, because formatting needs the budget's currency format and that
 * belongs to `@lumy/money`.
 *
 * Keyset rather than offset, because an offset re-counts everything it skips
 * and shifts under a sync that lands between two pages. The cursor is the last
 * row's own sort key, so the next page continues from a row rather than from a
 * position.
 */

/** Where a page left off: the sort key of its last row. */
export interface LedgerCursor {
  /** YYYY-MM-DD. */
  date: string;
  /** The entry id for an entry listing, the transaction id for a transaction one. */
  id: string;
}

export interface Page<T> {
  rows: readonly T[];
  /** Pass to the next call. Null when the page was the last one. */
  nextCursor: LedgerCursor | null;
}

export interface ListOptions {
  budgetId: string;
  /** The flat form. Ignored when `condition` is given. */
  filter?: LedgerFilter;
  /** The tree form, which is what a spend tracker stores. */
  condition?: LedgerCondition;
  limit: number;
  cursor?: LedgerCursor | null;
}

export interface LedgerEntryRow {
  entryId: string;
  transactionId: string;
  isSubtransaction: boolean;
  /** YYYY-MM-DD. */
  date: string;
  /** YYYY-MM-01. */
  month: string;
  accountId: string;
  accountName: string | null;
  payeeId: string | null;
  payeeName: string | null;
  categoryId: string | null;
  categoryName: string | null;
  categoryGroupId: string | null;
  categoryGroupName: string | null;
  amount: Milliunits;
  memo: string | null;
  flagColor: string | null;
  isTransfer: boolean;
  isIncome: boolean;
  isExpense: boolean;
  isStartingBalance: boolean;
  /** True on the first row of a date group, so the list renders its header. */
  startsDateGroup: boolean;
}

export interface TransactionRow {
  transactionId: string;
  date: string;
  month: string;
  accountId: string;
  accountName: string | null;
  payeeId: string | null;
  payeeName: string | null;
  /** The category when one leaf matched. Null for a split, which has no single one. */
  categoryId: string | null;
  categoryName: string | null;
  /** Matching leaves. More than one is a split; the row labels itself from this. */
  legCount: number;
  /** The sum of the matching leaves, which is what a drilldown shows. */
  amount: Milliunits;
  memo: string | null;
  flagColor: string | null;
  isTransfer: boolean;
  startsDateGroup: boolean;
}

/**
 * The page's own condition, from whichever form the caller used.
 *
 * The tree wins when both are given, because it is the more specific of the
 * two; a caller passes one or the other.
 */
function conditionFor(options: ListOptions): LedgerCondition {
  return options.condition ?? conditionForFilter(options.filter ?? {});
}

/**
 * Where the keyset picks up, as a row-value comparison.
 *
 * `(date, id) < (?, ?)` rather than `date < ? OR (date = ? AND id < ?)`,
 * because SQLite reads a row-value comparison straight off an index on the
 * same pair, where the `OR` form makes it a scan and a sort.
 */
function cursorClause(column: string, cursor: LedgerCursor | null | undefined): CompiledStatement {
  if (cursor === null || cursor === undefined) return { sql: '1', params: [] };

  return { sql: `(date, ${column}) < (?, ?)`, params: [cursor.date, cursor.id] };
}

/**
 * Whether a row opens a date group.
 *
 * Computed in SQL so a screen never walks a page to decide where its headers
 * go. The window runs over the page rather than over everything that matched,
 * which is why the page is selected in a subquery first — a window over the
 * whole filtered set would have to read all of it before the `LIMIT` could
 * apply, and pagination would stop meaning anything.
 *
 * `LAG` is null for the page's first row, so the comparison falls back to the
 * cursor's date. Without that, the first row of every page after the first
 * would claim a header the previous page already rendered.
 */
function startsDateGroup(table: string, idColumn: string): string {
  return `${table}.date IS NOT COALESCE(
         LAG(${table}.date) OVER (ORDER BY ${table}.date DESC, ${table}.${idColumn} DESC), ?)`;
}

/** One more row than asked for, so the page knows whether another follows. */
function paginate<T>(
  rows: readonly T[],
  limit: number,
  cursorOf: (row: T) => LedgerCursor,
): Page<T> {
  if (rows.length <= limit) return { rows, nextCursor: null };

  const page = rows.slice(0, limit);

  return { rows: page, nextCursor: cursorOf(page[page.length - 1]) };
}

interface EntryRecord {
  entry_id: string;
  transaction_id: string;
  is_subtransaction: number;
  date: string;
  month: string;
  account_id: string;
  account_name: string | null;
  payee_id: string | null;
  payee_name: string | null;
  category_id: string | null;
  category_name: string | null;
  category_group_id: string | null;
  category_group_name: string | null;
  amount: number;
  memo: string | null;
  flag_color: string | null;
  is_transfer: number;
  is_income: number;
  is_expense: number;
  is_starting_balance: number;
  starts_date_group: number;
}

/**
 * The statement a ledger-entry page runs.
 *
 * Exported so a test can hold the statement that ships to its query plan,
 * rather than a transcription of it that could drift.
 */
export function ledgerEntryPageStatement(options: ListOptions): CompiledStatement {
  const condition = compileCondition(conditionFor(options));
  const cursor = cursorClause('entry_id', options.cursor);

  return {
    sql: `WITH page AS (
       SELECT *
       FROM ledger_entries
       WHERE budget_id = ? AND ${condition.sql} AND ${cursor.sql}
       ORDER BY date DESC, entry_id DESC
       LIMIT ?
     )
     SELECT
       e.entry_id, e.transaction_id, e.is_subtransaction, e.date, e.month,
       e.account_id, a.name AS account_name,
       e.payee_id, e.payee_name,
       e.category_id, c.name AS category_name,
       e.category_group_id, g.name AS category_group_name,
       e.amount, e.memo, e.flag_color,
       e.is_transfer, e.is_income, e.is_expense, e.is_starting_balance,
       ${startsDateGroup('e', 'entry_id')} AS starts_date_group
     FROM page e
     LEFT JOIN accounts a ON a.id = e.account_id
     LEFT JOIN categories c ON c.id = e.category_id
     LEFT JOIN category_groups g ON g.id = e.category_group_id
     ORDER BY e.date DESC, e.entry_id DESC`,
    params: [
      options.budgetId,
      ...condition.params,
      ...cursor.params,
      options.limit + 1,
      options.cursor?.date ?? null,
    ],
  };
}

/**
 * A page of spendable leaves, newest first.
 *
 * What a category, payee, or spend-tracker drilldown shows: one row per thing
 * that was attributed to a category, so a split appears as its legs rather
 * than as a sum nobody can break down.
 */
export async function listLedgerEntries(
  db: Queryable,
  options: ListOptions,
): Promise<Page<LedgerEntryRow>> {
  const statement = ledgerEntryPageStatement(options);
  const rows = await db.all<EntryRecord>(statement.sql, statement.params);

  return paginate(
    rows.map(
      (row): LedgerEntryRow => ({
        entryId: row.entry_id,
        transactionId: row.transaction_id,
        isSubtransaction: row.is_subtransaction === 1,
        date: row.date,
        month: row.month,
        accountId: row.account_id,
        accountName: row.account_name,
        payeeId: row.payee_id,
        payeeName: row.payee_name,
        categoryId: row.category_id,
        categoryName: row.category_name,
        categoryGroupId: row.category_group_id,
        categoryGroupName: row.category_group_name,
        amount: row.amount as Milliunits,
        memo: row.memo,
        flagColor: row.flag_color,
        isTransfer: row.is_transfer === 1,
        isIncome: row.is_income === 1,
        isExpense: row.is_expense === 1,
        isStartingBalance: row.is_starting_balance === 1,
        startsDateGroup: row.starts_date_group === 1,
      }),
    ),
    options.limit,
    (row) => ({ date: row.date, id: row.entryId }),
  );
}

interface TransactionRecord {
  transaction_id: string;
  date: string;
  month: string;
  account_id: string;
  account_name: string | null;
  payee_id: string | null;
  payee_name: string | null;
  category_id: string | null;
  category_name: string | null;
  leg_count: number;
  amount: number;
  memo: string | null;
  flag_color: string | null;
  is_transfer: number;
  starts_date_group: number;
}

/**
 * The statement a transaction page runs.
 *
 * The condition appears twice, and deliberately. The first selects which
 * transactions the page covers; the second decides which of their leaves the
 * row is about, so a category drilldown sums only the leaves in that category
 * rather than the whole transaction.
 *
 * The second step does not repeat `budget_id`. A transaction id identifies a
 * row of `transactions` outright, so the predicate would be redundant — and
 * carrying it made the planner drive the join from the budget's entries and
 * look the page up with an automatic index, which is the whole budget scanned
 * to render fifty rows.
 */
export function transactionPageStatement(options: ListOptions): CompiledStatement {
  const condition = compileCondition(conditionFor(options));
  const cursor = cursorClause('transaction_id', options.cursor);

  return {
    sql: `WITH page AS (
       SELECT date, transaction_id
       FROM ledger_entries
       WHERE budget_id = ? AND ${condition.sql} AND ${cursor.sql}
       GROUP BY date, transaction_id
       ORDER BY date DESC, transaction_id DESC
       LIMIT ?
     ),
     grouped AS (
       SELECT
         e.transaction_id, e.date, e.month, e.account_id,
         MIN(e.entry_id) AS first_entry_id,
         e.payee_id, e.payee_name, e.memo, e.flag_color, e.is_transfer,
         CASE WHEN COUNT(*) = 1 THEN e.category_id END AS category_id,
         COUNT(*) AS leg_count,
         SUM(e.amount) AS amount
       FROM page p
       JOIN ledger_entries e ON e.transaction_id = p.transaction_id
       WHERE ${condition.sql}
       GROUP BY e.transaction_id
     )
     SELECT
       t.transaction_id, t.date, t.month,
       t.account_id, a.name AS account_name,
       t.payee_id, t.payee_name,
       t.category_id, c.name AS category_name,
       t.leg_count, t.amount, t.memo, t.flag_color, t.is_transfer,
       ${startsDateGroup('t', 'transaction_id')} AS starts_date_group
     FROM grouped t
     LEFT JOIN accounts a ON a.id = t.account_id
     LEFT JOIN categories c ON c.id = t.category_id
     ORDER BY t.date DESC, t.transaction_id DESC`,
    params: [
      options.budgetId,
      ...condition.params,
      ...cursor.params,
      options.limit + 1,
      ...condition.params,
      options.cursor?.date ?? null,
    ],
  };
}

/**
 * A page of transactions, newest first.
 *
 * The transaction screen's listing. It is built over `ledger_entries` rather
 * than the raw tables — nothing above the sync engine reads those — so a
 * transaction here is the group of its matching leaves. That is also what
 * makes a filtered list read correctly: ask for one category and a split comes
 * back carrying only what it spent in that category, which is the number the
 * drilldown is about.
 *
 * The fields a group cannot have one of — payee, memo, flag — are taken from
 * the leaf with the lowest entry id. SQLite guarantees that bare columns beside
 * a single `min()` come from the row that produced it, and for all but a split
 * with per-leg payee overrides there is only one answer anyway.
 */
export async function listTransactions(
  db: Queryable,
  options: ListOptions,
): Promise<Page<TransactionRow>> {
  const statement = transactionPageStatement(options);
  const rows = await db.all<TransactionRecord>(statement.sql, statement.params);

  return paginate(
    rows.map(
      (row): TransactionRow => ({
        transactionId: row.transaction_id,
        date: row.date,
        month: row.month,
        accountId: row.account_id,
        accountName: row.account_name,
        payeeId: row.payee_id,
        payeeName: row.payee_name,
        categoryId: row.category_id,
        categoryName: row.category_name,
        legCount: row.leg_count,
        amount: row.amount as Milliunits,
        memo: row.memo,
        flagColor: row.flag_color,
        isTransfer: row.is_transfer === 1,
        startsDateGroup: row.starts_date_group === 1,
      }),
    ),
    options.limit,
    (row) => ({ date: row.date, id: row.transactionId }),
  );
}
