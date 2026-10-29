import { index, integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

export const payees = sqliteTable(
  'payees',
  {
    id: text('id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
  },
  (table) => [
    // Serves the payee picker — `WHERE budget_id = ? AND deleted = 0 ORDER BY
    // name` — and the per-budget read that the snapshot diff makes.
    index('payees_by_budget').on(table.budgetId, table.name),
  ],
);
