import { index, integer, primaryKey, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

export const accounts = sqliteTable(
  'accounts',
  {
    id: text('id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
    /** YNAB's account type verbatim: `checking`, `creditCard`, `autoLoan`, … */
    type: text('type').notNull(),
    onBudget: integer('on_budget', { mode: 'boolean' }).notNull(),
    closed: integer('closed', { mode: 'boolean' }).notNull(),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
    balance: integer('balance').notNull(),
  },
  (table) => [
    // Serves the account list and picker — `WHERE budget_id = ? AND deleted = 0
    // ORDER BY name` — and the per-budget read that the snapshot diff makes.
    index('accounts_by_budget').on(table.budgetId, table.name),
  ],
);

/**
 * The per-month loan figures YNAB returns for debt accounts.
 *
 * YNAB sends three separate maps — `debt_interest_rates`,
 * `debt_minimum_payments`, `debt_escrow_amounts` — all keyed by month. They
 * are one table here because they share that key exactly: three tables would
 * mean three upserts, three indexes, and a three-way join to answer "what did
 * this loan look like in March". A month present in one map and absent from
 * another leaves the other column null.
 */
export const accountDebtMonths = sqliteTable(
  'account_debt_months',
  {
    accountId: text('account_id')
      .notNull()
      .references(() => accounts.id, { onDelete: 'cascade' }),
    /** YYYY-MM-01. */
    month: text('month').notNull(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    interestRate: integer('interest_rate'),
    minimumPayment: integer('minimum_payment'),
    escrowAmount: integer('escrow_amount'),
  },
  (table) => [
    primaryKey({ columns: [table.accountId, table.month] }),
    // The cascade from `budgets` would otherwise scan the table, and the
    // snapshot diff reads these a budget at a time.
    index('account_debt_months_by_budget').on(table.budgetId),
  ],
);
