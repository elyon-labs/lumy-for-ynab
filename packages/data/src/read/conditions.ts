import type { SqlValue } from '../adapters/types';

/**
 * The one way anything in this app says which ledger entries it means.
 *
 * A transaction screen's filters, a chart's source, and a spend tracker's
 * saved rule are the same question asked three ways, and in the Flutter app
 * they were three mechanisms: `TransactionFilter` closures, the
 * `FilterReq` / `DateRangeReq` / `AccountsView` request hierarchy, and the
 * `TransactionCondition` tree with its own evaluator. All three collapse into
 * this, because all three end as a `WHERE` clause.
 *
 * The tree is plain data, so a spend tracker's stored condition is this
 * structure rather than a translation of it.
 */

export type LedgerCondition =
  /** Every branch must match. Empty matches everything. */
  | { readonly test: 'all'; readonly of: readonly LedgerCondition[] }
  /** Any branch may match. Empty matches nothing. */
  | { readonly test: 'any'; readonly of: readonly LedgerCondition[] }
  | { readonly test: 'not'; readonly of: LedgerCondition }
  /** Inclusive on both ends. Either end may be omitted. */
  | { readonly test: 'dateRange'; readonly from?: string | null; readonly to?: string | null }
  | { readonly test: 'hasAccountId'; readonly ids: readonly string[] }
  | { readonly test: 'hasPayeeId'; readonly ids: readonly (string | null)[] }
  | { readonly test: 'hasCategoryId'; readonly ids: readonly (string | null)[] }
  | { readonly test: 'hasCategoryGroupId'; readonly ids: readonly (string | null)[] }
  /** `null` means unflagged, which is what YNAB sends as both null and `''`. */
  | { readonly test: 'hasFlagColor'; readonly colors: readonly (string | null)[] }
  | { readonly test: 'hasMemoKeyword'; readonly keyword: string }
  | { readonly test: 'isIncome' }
  | { readonly test: 'isExpense' }
  | { readonly test: 'isInflow' }
  | { readonly test: 'isOutflow' }
  | { readonly test: 'isTransfer' }
  | { readonly test: 'isStartingBalance' };

/** A statement and the values bound to it, in the order it reads them. */
export interface CompiledStatement {
  sql: string;
  params: readonly SqlValue[];
}

export interface CompiledCondition {
  /** A boolean expression over the columns of `ledger_entries`. */
  sql: string;
  params: readonly SqlValue[];
}

/**
 * The identities of the two combinators.
 *
 * `all` of nothing is true and `any` of nothing is false, which is what makes
 * an empty filter mean "no filter" and an empty choice mean "nothing chosen"
 * without a special case at any call site.
 */
const MATCHES_EVERYTHING = '1';
const MATCHES_NOTHING = '0';

/** The character that escapes a literal `%` or `_` in a `LIKE` pattern. */
const LIKE_ESCAPE = '\\';

function escapeForLike(keyword: string): string {
  return keyword
    .replaceAll(LIKE_ESCAPE, `${LIKE_ESCAPE}${LIKE_ESCAPE}`)
    .replaceAll('%', `${LIKE_ESCAPE}%`)
    .replaceAll('_', `${LIKE_ESCAPE}_`);
}

/**
 * Forces a leaf to two values.
 *
 * SQL is three-valued, and every nullable column here can make a comparison
 * answer null rather than false: `category_id IN ('food')` is null for an
 * uncategorised entry, and `memo LIKE '%rent%'` is null for an entry with no
 * memo. At the top of a `WHERE` null and false behave alike, so a positive
 * test is unharmed — but `NOT null` is null, so negating one of those would
 * drop exactly the rows the negation should keep. An entry with no memo
 * certainly does not contain the keyword.
 */
function definite(sql: string): string {
  return `COALESCE(${sql}, 0)`;
}

/**
 * How a column is written into the statement.
 *
 * An aggregate joins `categories`, `payees`, and `accounts`, and those carry
 * columns of their own named `budget_id`, `category_group_id`, and `name`. So
 * a caller that joins anything passes the alias of `ledger_entries`, and every
 * column the compiler emits is qualified with it.
 */
export interface CompileOptions {
  /** The alias of `ledger_entries` in the statement this clause goes into. */
  table?: string;
}

/** `column IN (…)`, with `null` in the list meaning the column is null. */
function matchesAnyOf(
  column: string,
  values: readonly (string | null)[],
  nullable: boolean,
): CompiledCondition {
  if (values.length === 0) return { sql: MATCHES_NOTHING, params: [] };

  const ids = values.filter((value): value is string => value !== null);
  const wantsNull = ids.length !== values.length;

  const parts: string[] = [];
  const params: SqlValue[] = [];

  if (ids.length > 0) {
    parts.push(`${column} IN (${ids.map(() => '?').join(', ')})`);
    params.push(...ids);
  }
  if (wantsNull) parts.push(`${column} IS NULL`);

  const sql = parts.length === 1 ? parts[0] : `(${parts.join(' OR ')})`;

  return { sql: nullable && ids.length > 0 ? definite(sql) : sql, params };
}

function combine(
  branches: readonly LedgerCondition[],
  operator: 'AND' | 'OR',
  empty: string,
  options: CompileOptions,
): CompiledCondition {
  if (branches.length === 0) return { sql: empty, params: [] };

  const compiled = branches.map((branch) => compileCondition(branch, options));
  if (compiled.length === 1) return compiled[0];

  return {
    sql: `(${compiled.map((branch) => branch.sql).join(` ${operator} `)})`,
    params: compiled.flatMap((branch) => branch.params),
  };
}

/**
 * Compiles a condition to a parameterised boolean expression.
 *
 * Every value is bound rather than interpolated, so a memo keyword a user
 * typed cannot become SQL. The column names are the engine's own and are the
 * only thing written into the statement.
 */
export function compileCondition(
  condition: LedgerCondition,
  options: CompileOptions = {},
): CompiledCondition {
  const column = (name: string): string =>
    options.table === undefined ? name : `${options.table}.${name}`;

  switch (condition.test) {
    case 'all':
      return combine(condition.of, 'AND', MATCHES_EVERYTHING, options);

    case 'any':
      return combine(condition.of, 'OR', MATCHES_NOTHING, options);

    case 'not': {
      const inner = compileCondition(condition.of, options);

      return { sql: `NOT ${inner.sql}`, params: inner.params };
    }

    case 'dateRange': {
      const parts: string[] = [];
      const params: SqlValue[] = [];
      if (condition.from != null) {
        parts.push(`${column('date')} >= ?`);
        params.push(condition.from);
      }
      if (condition.to != null) {
        parts.push(`${column('date')} <= ?`);
        params.push(condition.to);
      }
      if (parts.length === 0) return { sql: MATCHES_EVERYTHING, params: [] };

      return { sql: parts.length === 1 ? parts[0] : `(${parts.join(' AND ')})`, params };
    }

    case 'hasAccountId':
      // `account_id` is not nullable: a leg is always in its parent's account.
      return matchesAnyOf(column('account_id'), condition.ids, false);

    case 'hasPayeeId':
      return matchesAnyOf(column('payee_id'), condition.ids, true);

    case 'hasCategoryId':
      return matchesAnyOf(column('category_id'), condition.ids, true);

    case 'hasCategoryGroupId':
      return matchesAnyOf(column('category_group_id'), condition.ids, true);

    case 'hasFlagColor':
      return matchesAnyOf(column('flag_color'), condition.colors, true);

    case 'hasMemoKeyword':
      // Case-insensitive for ASCII, which is what SQLite's `LIKE` does without
      // ICU. Neither driver carries ICU, so a keyword that differs from the
      // memo only outside ASCII will not match.
      return {
        sql: definite(`${column('memo')} LIKE ? ESCAPE '${LIKE_ESCAPE}'`),
        params: [`%${escapeForLike(condition.keyword)}%`],
      };

    case 'isIncome':
      return { sql: `${column('is_income')} = 1`, params: [] };

    case 'isExpense':
      return { sql: `${column('is_expense')} = 1`, params: [] };

    case 'isTransfer':
      return { sql: `${column('is_transfer')} = 1`, params: [] };

    case 'isStartingBalance':
      return { sql: `${column('is_starting_balance')} = 1`, params: [] };

    // Inflow and outflow are the sign of the amount, where income and expense
    // are the classification. A refund is an inflow and not income.
    case 'isInflow':
      return { sql: `${column('amount')} > 0`, params: [] };

    case 'isOutflow':
      return { sql: `${column('amount')} < 0`, params: [] };
  }
}

/**
 * The flat form a screen passes, which becomes a condition tree.
 *
 * Every field present is a branch of one `all`. This is the shape the
 * Flutter request-object hierarchy existed to carry, and it is plain
 * parameters here because a hook takes parameters.
 */
export interface LedgerFilter {
  /** Inclusive. */
  from?: string | null;
  /** Inclusive. */
  to?: string | null;
  accountIds?: readonly string[];
  payeeIds?: readonly (string | null)[];
  categoryIds?: readonly (string | null)[];
  categoryGroupIds?: readonly (string | null)[];
  flagColors?: readonly (string | null)[];
  memoKeyword?: string;
  /** Any of these, so a screen can ask for income or inflow in one filter. */
  classifications?: readonly (
    | 'income'
    | 'expense'
    | 'inflow'
    | 'outflow'
    | 'transfer'
    | 'startingBalance'
  )[];
}

const CLASSIFICATION_TESTS = {
  income: 'isIncome',
  expense: 'isExpense',
  inflow: 'isInflow',
  outflow: 'isOutflow',
  transfer: 'isTransfer',
  startingBalance: 'isStartingBalance',
} as const;

/** Builds the condition tree a filter describes. */
export function conditionForFilter(filter: LedgerFilter): LedgerCondition {
  const of: LedgerCondition[] = [];

  if (filter.from != null || filter.to != null) {
    of.push({ test: 'dateRange', from: filter.from, to: filter.to });
  }
  if (filter.accountIds !== undefined) of.push({ test: 'hasAccountId', ids: filter.accountIds });
  if (filter.payeeIds !== undefined) of.push({ test: 'hasPayeeId', ids: filter.payeeIds });
  if (filter.categoryIds !== undefined) of.push({ test: 'hasCategoryId', ids: filter.categoryIds });
  if (filter.categoryGroupIds !== undefined) {
    of.push({ test: 'hasCategoryGroupId', ids: filter.categoryGroupIds });
  }
  if (filter.flagColors !== undefined) of.push({ test: 'hasFlagColor', colors: filter.flagColors });
  if (filter.memoKeyword !== undefined) {
    of.push({ test: 'hasMemoKeyword', keyword: filter.memoKeyword });
  }
  if (filter.classifications !== undefined) {
    of.push({
      test: 'any',
      of: filter.classifications.map((name) => ({ test: CLASSIFICATION_TESTS[name] }) as const),
    });
  }

  return { test: 'all', of };
}
