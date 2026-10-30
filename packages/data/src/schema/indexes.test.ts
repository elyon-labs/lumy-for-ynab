import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { BUDGET_ID, createHarness, type Harness } from '../testing';

/**
 * Every index in the schema, with the query it exists for.
 *
 * An index nobody's query plan reaches for is weight on every write for
 * nothing, so each one here is held to a plan that uses it. The list is also
 * checked against the schema, which is what stops an index arriving without a
 * query to justify it.
 */
const INDEXED_QUERIES: Record<string, string> = {
  accounts_by_budget: `
    SELECT id, name, balance FROM accounts
    WHERE budget_id = ? AND deleted = 0
    ORDER BY name`,

  payees_by_budget: `
    SELECT id, name FROM payees
    WHERE budget_id = ? AND deleted = 0
    ORDER BY name`,

  category_groups_by_budget: `
    SELECT id, name FROM category_groups
    WHERE budget_id = ?
    ORDER BY sort_order`,

  categories_by_group: `
    SELECT id, name FROM categories
    WHERE category_group_id = ?
    ORDER BY sort_order`,

  // The target health report, which reads every category in the budget once
  // rather than walking the groups.
  categories_by_budget: `
    SELECT id, target_type, target_balance FROM categories
    WHERE budget_id = ? AND deleted = 0`,

  // The budget tab, and the month the chart aggregates are grouped by.
  category_months_by_month: `
    SELECT category_id, budgeted, activity, balance FROM category_months
    WHERE budget_id = ? AND month = ?`,

  // The ledger derivation's matched-import test: a transaction that is some
  // other transaction's match contributes nothing, and this is the only
  // direction the question can be asked from.
  transactions_by_match: `
    SELECT 1 FROM transactions
    WHERE matched_transaction_id = ?`,

  // The snapshot diff and the repair rebuild, both of which read the budget's
  // transactions in date order a page at a time.
  transactions_by_budget: `
    SELECT id, date, amount FROM transactions
    WHERE budget_id = ? AND date BETWEEN ? AND ?
    ORDER BY date`,

  // Child-set reconciliation, which runs once per parent on every delta page.
  subtransactions_by_transaction: `
    SELECT id, amount, category_id FROM subtransactions
    WHERE transaction_id = ?`,

  subtransactions_by_budget: `
    SELECT id FROM subtransactions
    WHERE budget_id = ?`,

  // The recurring timeline, which walks forward from today.
  scheduled_transactions_by_budget: `
    SELECT id, date_next, amount FROM scheduled_transactions
    WHERE budget_id = ? AND date_next >= ?
    ORDER BY date_next`,

  scheduled_subtransactions_by_parent: `
    SELECT id, amount FROM scheduled_subtransactions
    WHERE scheduled_transaction_id = ?`,

  scheduled_subtransactions_by_budget: `
    SELECT id FROM scheduled_subtransactions
    WHERE budget_id = ?`,

  // The loan figures for one budget, which the days-buffer and net-worth
  // charts read alongside the accounts.
  account_debt_months_by_budget: `
    SELECT account_id, month, interest_rate FROM account_debt_months
    WHERE budget_id = ?`,

  // The transaction list's page, read straight off the index: the keyset
  // cursor is the same (date, entry_id) the key is ordered by.
  ledger_by_date: `
    SELECT entry_id, date, amount FROM ledger_entries
    WHERE budget_id = ? AND (date, entry_id) < (?, ?)
    ORDER BY date DESC, entry_id DESC
    LIMIT 50`,

  // The transaction list's page. A transaction is a group of entries, so its
  // keyset is `(date, transaction_id)` and the group has to come off the index
  // already ordered — `ledger_by_date` ends in `entry_id` and would sort.
  ledger_by_date_transaction: `
    SELECT date, transaction_id FROM ledger_entries
    WHERE budget_id = ? AND (date, transaction_id) < (?, ?)
    GROUP BY date, transaction_id
    ORDER BY date DESC, transaction_id DESC
    LIMIT 50`,

  // Spend and income by category, one row per (month, category).
  ledger_by_category_month: `
    SELECT month, category_id, SUM(amount) AS total FROM ledger_entries
    WHERE budget_id = ? AND month BETWEEN ? AND ?
    GROUP BY month, category_id`,

  // Income by payee, one row per (month, payee).
  ledger_by_payee_month: `
    SELECT month, payee_id, SUM(amount) AS total FROM ledger_entries
    WHERE budget_id = ? AND month BETWEEN ? AND ?
    GROUP BY month, payee_id`,

  // Account balances over time, which net worth and days buffer walk.
  ledger_by_account_date: `
    SELECT account_id, date, SUM(amount) AS total FROM ledger_entries
    WHERE budget_id = ? AND account_id = ? AND date <= ?
    GROUP BY account_id, date`,

  // Category group rollups.
  ledger_by_group_month: `
    SELECT category_group_id, month, SUM(amount) AS total FROM ledger_entries
    WHERE budget_id = ? AND category_group_id = ?
    GROUP BY category_group_id, month`,

  // The rebuild's delete, which runs once per page.
  ledger_by_transaction: `
    SELECT entry_id FROM ledger_entries
    WHERE transaction_id = ?`,

  // Spend by month, the hot path. The partial index carries only the rows
  // that pass the predicate every one of these queries also carries.
  ledger_spend_by_month: `
    SELECT month, SUM(amount) AS total FROM ledger_entries
    WHERE budget_id = ? AND is_expense = 1
    GROUP BY month`,
};

/** A parameter for every `?` in the statement. The values do not matter. */
function placeholders(sql: string): string[] {
  return Array.from({ length: sql.split('?').length - 1 }, () => BUDGET_ID);
}

async function queryPlan(db: DatabaseAdapter, sql: string): Promise<string> {
  const rows = await db.all<{ detail: string }>(
    `EXPLAIN QUERY PLAN ${sql}`,
    placeholders(sql),
  );

  return rows.map((row) => row.detail).join('\n');
}

describe('indexes', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeAll(async () => {
    harness = await createHarness();
    db = harness.db;
  });

  afterAll(async () => {
    await harness.close();
  });

  it.each(Object.keys(INDEXED_QUERIES))('%s is used by the query it exists for', async (name) => {
    const plan = await queryPlan(db, INDEXED_QUERIES[name]);

    expect(plan, plan).toContain(name);
  });

  it.each(
    Object.entries(INDEXED_QUERIES).filter(([, sql]) => sql.includes('ORDER BY')),
  )('%s orders without sorting', async (_name, sql) => {
    const plan = await queryPlan(db, sql);

    // A temp b-tree means the index covered the filter but not the order, and
    // the rows get sorted in memory after all.
    expect(plan, plan).not.toContain('USE TEMP B-TREE');
  });

  it('has no index without a query', async () => {
    const rows = await db.all<{ name: string }>(
      `SELECT name FROM sqlite_master
       WHERE type = 'index' AND name NOT LIKE 'sqlite_%'
       ORDER BY name`,
    );

    expect(rows.map((row) => row.name).sort()).toEqual(Object.keys(INDEXED_QUERIES).sort());
  });
});
