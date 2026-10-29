import { integer, primaryKey, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

/** YNAB's month summary. The per-category figures live in `category_months`. */
export const months = sqliteTable(
  'months',
  {
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    /** YYYY-MM-01. */
    month: text('month').notNull(),
    note: text('note'),
    income: integer('income').notNull(),
    budgeted: integer('budgeted').notNull(),
    activity: integer('activity').notNull(),
    toBeBudgeted: integer('to_be_budgeted').notNull(),
    ageOfMoney: integer('age_of_money'),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
  },
  // Reads are always `WHERE budget_id = ?` with an optional month range, which
  // this key serves as a prefix; it is also the index the cascade needs.
  (table) => [primaryKey({ columns: [table.budgetId, table.month] })],
);
