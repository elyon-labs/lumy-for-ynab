import { integer, primaryKey, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

/**
 * How far each resource has been synced.
 *
 * One table in place of the Flutter app's six, which existed per resource and
 * so could each be advanced on its own. Advancing knowledge is the step that
 * must commit with the data it describes, and that is easier to hold to when
 * there is one place it happens.
 *
 * `month` is `''` rather than null for the resources that are not month
 * scoped. A null in a primary key column is not a uniqueness violation in
 * SQLite — nulls compare as distinct — so a nullable column here would let the
 * same resource accumulate a row per sync, each with its own idea of how far
 * the client has got.
 */
export const serverKnowledge = sqliteTable(
  'server_knowledge',
  {
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    /** `transactions`, `accounts`, `categories`, … */
    resource: text('resource').notNull(),
    /** YYYY-MM-01 for the month-scoped resources, `''` for the rest. */
    month: text('month').notNull().default(''),
    knowledge: integer('knowledge').notNull(),
    syncedAt: text('synced_at').notNull(),
  },
  (table) => [primaryKey({ columns: [table.budgetId, table.resource, table.month] })],
);
