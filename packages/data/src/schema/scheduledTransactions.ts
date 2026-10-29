import { index, integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

export const scheduledTransactions = sqliteTable(
  'scheduled_transactions',
  {
    id: text('id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    /** YYYY-MM-DD. */
    dateFirst: text('date_first').notNull(),
    /** YYYY-MM-DD, and the only date the recurring screens order by. */
    dateNext: text('date_next').notNull(),
    /** `never`, `daily`, `everyOtherWeek`, … verbatim. */
    frequency: text('frequency').notNull(),
    accountId: text('account_id').notNull(),
    accountName: text('account_name').notNull(),
    amount: integer('amount').notNull(),
    payeeId: text('payee_id'),
    payeeName: text('payee_name'),
    categoryId: text('category_id'),
    categoryName: text('category_name'),
    memo: text('memo'),
    flagColor: text('flag_color'),
    flagName: text('flag_name'),
    transferAccountId: text('transfer_account_id'),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
  },
  (table) => [
    // The recurring timeline, which walks forward from today, and the cascade
    // from `budgets`.
    index('scheduled_transactions_by_budget').on(table.budgetId, table.dateNext),
  ],
);

/**
 * The legs of a split scheduled transaction.
 *
 * Reconciled per parent for the same reason the past ones are: a leg that goes
 * away is omitted rather than marked deleted.
 */
export const scheduledSubtransactions = sqliteTable(
  'scheduled_subtransactions',
  {
    id: text('id').primaryKey(),
    scheduledTransactionId: text('scheduled_transaction_id')
      .notNull()
      .references(() => scheduledTransactions.id, { onDelete: 'cascade' }),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    amount: integer('amount').notNull(),
    payeeId: text('payee_id'),
    categoryId: text('category_id'),
    memo: text('memo'),
    transferAccountId: text('transfer_account_id'),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
  },
  (table) => [
    index('scheduled_subtransactions_by_parent').on(table.scheduledTransactionId),
    index('scheduled_subtransactions_by_budget').on(table.budgetId),
  ],
);
