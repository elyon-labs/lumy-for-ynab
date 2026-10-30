import { sql } from 'drizzle-orm';
import { index, integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';
import { transactions } from './transactions';

/**
 * One row per spendable leaf: the table every screen reads.
 *
 * YNAB gives two shapes for the same thing. A simple transaction carries its
 * own category and amount; a split's parent carries the sum and no meaningful
 * category while its legs carry the real ones. Every consumer that forgets
 * that double-counts, and every consumer that remembers it writes the branch
 * again. So the branch is taken once, here, at write time: a simple
 * transaction becomes one row, a split becomes one row per live leg, and the
 * parent becomes none.
 *
 * Classification is resolved the same way, which is what the `is_*` columns
 * are. Nothing downstream asks whether a row is a split, because downstream
 * there are no splits.
 *
 * The table is derived, and it is rebuilt rather than patched — delete the
 * entries for a transaction, re-derive them from the raw rows as they now
 * stand. It cannot drift from the raw tables because it is never
 * incrementally edited.
 */
export const ledgerEntries = sqliteTable(
  'ledger_entries',
  {
    /** The subtransaction's id for a leg, the transaction's for a simple one. */
    entryId: text('entry_id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    /** The owning transaction, always — a leg carries its parent's id. */
    transactionId: text('transaction_id')
      .notNull()
      .references(() => transactions.id, { onDelete: 'cascade' }),
    isSubtransaction: integer('is_subtransaction', { mode: 'boolean' }).notNull(),

    /** YYYY-MM-DD, from the parent. */
    date: text('date').notNull(),
    /** YYYY-MM-01, precomputed so a month rollup groups on a column. */
    month: text('month').notNull(),
    /** From the parent. A leg is never in a different account. */
    accountId: text('account_id').notNull(),

    /** The leg's own payee where it has one, otherwise the parent's. */
    payeeId: text('payee_id'),
    payeeName: text('payee_name'),
    categoryId: text('category_id'),
    /**
     * Resolved from `categories` as the entry is written.
     *
     * The Flutter app passes the whole category group list into every
     * condition evaluation precisely because this resolution never happened.
     */
    categoryGroupId: text('category_group_id'),

    amount: integer('amount').notNull(),
    memo: text('memo'),
    /** From the parent: YNAB flags a transaction, not a leg. */
    flagColor: text('flag_color'),

    transferAccountId: text('transfer_account_id'),
    /**
     * The canonical key both sides of a transfer share.
     *
     * Flow and net-worth queries elect one side of a pair rather than
     * dropping transfers, so a transfer in or out of a selected subset of
     * accounts still behaves correctly.
     */
    transferPairKey: text('transfer_pair_key'),

    isTransfer: integer('is_transfer', { mode: 'boolean' }).notNull(),
    isIncome: integer('is_income', { mode: 'boolean' }).notNull(),
    isStartingBalance: integer('is_starting_balance', { mode: 'boolean' }).notNull(),
    isExpense: integer('is_expense', { mode: 'boolean' }).notNull(),
  },
  (table) => [
    // Every listing. `entry_id` is in the key so the keyset cursor —
    // `ORDER BY date DESC, entry_id DESC` — reads straight off the index
    // instead of sorting the page afterwards.
    index('ledger_by_date').on(table.budgetId, table.date, table.entryId),
    // The transaction list's page. A transaction is a group of entries, so its
    // keyset reads `(date, transaction_id)` and needs that pair ordered —
    // `ledger_by_date` ends in `entry_id` and would make it a sort.
    index('ledger_by_date_transaction').on(table.budgetId, table.date, table.transactionId),
    // Category rollups per month.
    index('ledger_by_category_month').on(table.budgetId, table.month, table.categoryId),
    // Payee rollups per month.
    index('ledger_by_payee_month').on(table.budgetId, table.month, table.payeeId),
    // Account balances and net worth over time.
    index('ledger_by_account_date').on(table.budgetId, table.accountId, table.date),
    // Category group rollups.
    index('ledger_by_group_month').on(table.budgetId, table.categoryGroupId, table.month),
    // The rebuild's delete, and the index the cascade from `transactions`
    // needs to avoid scanning the largest table in the database.
    index('ledger_by_transaction').on(table.transactionId),
    // Spend totals by month, which is the hot path. Partial, because the
    // query always carries the same predicate and most rows fail it.
    index('ledger_spend_by_month')
      .on(table.budgetId, table.month)
      .where(sql`is_expense = 1`),
  ],
);
