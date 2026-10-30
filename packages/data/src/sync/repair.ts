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
