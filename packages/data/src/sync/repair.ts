import type { Queryable } from '../adapters/types';

/**
 * Discarding a budget's cached YNAB data.
 *
 * This replaces the Flutter practice of bumping the Drift schema version to
 * force a refetch — the reason four of its migrations exist at all. A client
 * that can throw its cache away and sync again does not need a schema change
 * to recover from a bad write.
 *
 * Only YNAB's data goes. Nothing the user configured — category views, spend
 * trackers, frugal months, templates — is stored here; it lives in Supabase
 * and is untouched.
 */

/**
 * Every table a budget's data occupies, children before parents.
 *
 * Deleting the `budgets` row alone would be enough, because every table below
 * cascades from it. They are listed anyway for two reasons: a cascade is
 * invisible to change notification, which is derived from the statements that
 * ran, so a repair that leaned on it would leave every screen showing data
 * that is no longer there; and an explicit list is something a test can hold
 * to the schema, which a cascade is not.
 *
 * `BUDGET_SCOPED_TABLES` is checked against the schema itself — a table with a
 * `budget_id` column that is missing here fails that test rather than
 * surviving a repair.
 */
export const BUDGET_SCOPED_TABLES: readonly string[] = [
  'ledger_entries',
  'subtransactions',
  'transactions',
  'scheduled_subtransactions',
  'scheduled_transactions',
  'category_months',
  'categories',
  'category_groups',
  'payees',
  'account_debt_months',
  'accounts',
  'months',
  'currency_formats',
  'server_knowledge',
];

/**
 * Deletes a budget's cached YNAB data, including its server knowledge.
 *
 * Knowledge goes with the rows it describes, which is what makes the next sync
 * take the full-snapshot path without being told to.
 */
export async function discardBudgetData(tx: Queryable, budgetId: string): Promise<void> {
  for (const table of BUDGET_SCOPED_TABLES) {
    await tx.run(`DELETE FROM ${table} WHERE budget_id = ?`, [budgetId]);
  }

  await tx.run('DELETE FROM budgets WHERE id = ?', [budgetId]);
}

/**
 * Deletes every budget's cached YNAB data.
 *
 * What "delete all synced data" means, and the choice is deliberate: all of it,
 * not the selected budget's. Switching budget leaves the previous one's rows
 * where they are, so a per-budget delete would reclaim nothing someone could
 * see and would leave the figure the screen quotes as "all" untrue.
 * `repairBudget` is the per-budget act, and it re-downloads rather than
 * removes.
 *
 * One transaction rather than one per budget, unlike a snapshot write. There
 * is no network in it and nothing partway through is a state worth being left
 * in: a delete-all that stopped between budgets would leave one budget's data
 * behind with its knowledge gone, which is the shape of the Flutter bug this
 * engine exists to make impossible.
 *
 * Only YNAB's data goes. Category views, spend trackers, frugal months, and
 * templates are in Supabase, and `settings` — the theme, the period, the
 * selected budget, the chart order — is in this database but not scoped by
 * `budget_id`, so none of it is touched.
 */
export async function discardAllYnabData(tx: Queryable): Promise<void> {
  for (const table of BUDGET_SCOPED_TABLES) {
    await tx.run(`DELETE FROM ${table}`);
  }

  await tx.run('DELETE FROM budgets');
}
