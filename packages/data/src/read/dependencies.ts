/**
 * Which tables each read depends on.
 *
 * This is the other half of reactivity. The adapter reports the tables a
 * committed transaction wrote to; this says which reads those tables make
 * stale. One app-level subscriber puts the two together and invalidates the
 * affected query keys — no observable-query layer, no stream per view, no
 * manual fan-out.
 *
 * It lives beside the SQL it mirrors rather than in the app, because it is a
 * statement about what a query reads and that is knowable only here. A test
 * holds each declaration to the statement it describes, so a join added to a
 * query cannot quietly stop invalidating.
 */

export type ReadName =
  | 'listLedgerEntries'
  | 'listTransactions'
  | 'sumBy'
  | 'totals'
  | 'savingsRateByMonth'
  | 'accountBalancesOverTime'
  | 'totalBalanceOverTime'
  | 'netWorthOverTime'
  | 'daysBuffer'
  | 'targetHealth'
  | 'getSetting';

export const READ_TABLES: Record<ReadName, readonly string[]> = {
  listLedgerEntries: ['ledger_entries', 'accounts', 'categories', 'category_groups'],
  listTransactions: ['ledger_entries', 'accounts', 'categories'],
  // The union of what every grouping joins, because the declaration is per
  // read and the grouping is a parameter. A payee rename invalidating a
  // category rollup is a refetch that was not needed; a category rename not
  // invalidating a category rollup is a wrong number on screen.
  sumBy: ['ledger_entries', 'accounts', 'categories', 'category_groups', 'payees'],
  totals: ['ledger_entries'],
  savingsRateByMonth: ['ledger_entries'],
  accountBalancesOverTime: ['ledger_entries', 'accounts'],
  totalBalanceOverTime: ['ledger_entries', 'accounts'],
  netWorthOverTime: ['ledger_entries', 'accounts'],
  // Composed: a spend total and a balance series.
  daysBuffer: ['ledger_entries', 'accounts'],
  // The categories read carries the targets; the aggregate carries the spend.
  targetHealth: ['ledger_entries', 'categories'],
  // The one read that is not about the ledger. It is declared here like any
  // other so that a screen showing a setting re-reads it when the setting is
  // written, with nothing registered per screen.
  getSetting: ['settings'],
};

export const READ_NAMES = Object.keys(READ_TABLES) as ReadName[];

/**
 * The reads a committed write makes stale.
 *
 * Sorted, so a subscriber's invalidations are in a stable order and a test can
 * state the whole expected set rather than a set of memberships.
 */
export function readsAffectedBy(tables: readonly string[]): ReadName[] {
  const changed = new Set(tables);

  return READ_NAMES.filter((name) =>
    READ_TABLES[name].some((table) => changed.has(table)),
  ).sort();
}

/**
 * Every table any read depends on.
 *
 * A write to a table outside this set changes nothing a screen is showing —
 * `server_knowledge` and `schema_migrations` are the cases — so the subscriber
 * can ignore the notification outright rather than compute an empty answer.
 */
export const READ_DEPENDENCY_TABLES: readonly string[] = [
  ...new Set(READ_NAMES.flatMap((name) => READ_TABLES[name])),
].sort();
