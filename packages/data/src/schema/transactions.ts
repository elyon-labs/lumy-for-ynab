import { index, integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

/**
 * YNAB's transactions as it sends them.
 *
 * Nothing above the sync engine and the ledger derivation reads this table.
 * Its job is to hold enough of the payload that the ledger can be rebuilt, and
 * that a full snapshot can be diffed against what is stored, without
 * re-fetching.
 */
export const transactions = sqliteTable(
  'transactions',
  {
    id: text('id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    /** YYYY-MM-DD. Text, because it sorts and compares as a date already. */
    date: text('date').notNull(),
    accountId: text('account_id').notNull(),
    amount: integer('amount').notNull(),
    payeeId: text('payee_id'),
    payeeName: text('payee_name'),
    categoryId: text('category_id'),
    categoryName: text('category_name'),
    memo: text('memo'),
    /** `red`, `orange`, …, or null. YNAB's empty string is stored as null. */
    flagColor: text('flag_color'),
    cleared: text('cleared').notNull(),
    approved: integer('approved', { mode: 'boolean' }).notNull(),
    transferAccountId: text('transfer_account_id'),
    transferTransactionId: text('transfer_transaction_id'),
    matchedTransactionId: text('matched_transaction_id'),
    importId: text('import_id'),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
  },
  (table) => [
    // The ledger derivation has to know whether a transaction is some other
    // transaction's match before it can decide to skip it, and the only way to
    // ask that is from this side.
    index('transactions_by_match').on(table.matchedTransactionId),
    // Reads the whole budget a page at a time: the snapshot diff, and the
    // ledger rebuild that repair runs. Also the index the cascade from
    // `budgets` needs to avoid scanning the largest table in the database.
    index('transactions_by_budget').on(table.budgetId, table.date),
  ],
);

/**
 * The legs of a split transaction.
 *
 * YNAB does not report a removed subtransaction as deleted; it simply stops
 * sending it. So the writer reconciles the whole set per parent rather than
 * upserting what arrived, and the cascade below is what makes that one
 * statement instead of a diff.
 */
export const subtransactions = sqliteTable(
  'subtransactions',
  {
    id: text('id').primaryKey(),
    transactionId: text('transaction_id')
      .notNull()
      .references(() => transactions.id, { onDelete: 'cascade' }),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    amount: integer('amount').notNull(),
    /** Overrides the parent's payee when set, which is why the ledger carries both. */
    payeeId: text('payee_id'),
    payeeName: text('payee_name'),
    categoryId: text('category_id'),
    categoryName: text('category_name'),
    memo: text('memo'),
    transferAccountId: text('transfer_account_id'),
    transferTransactionId: text('transfer_transaction_id'),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
  },
  (table) => [
    // The child-set reconciliation delete and the derivation's read of a
    // parent's legs, both of which run per transaction id on every page.
    index('subtransactions_by_transaction').on(table.transactionId),
    index('subtransactions_by_budget').on(table.budgetId),
  ],
);
