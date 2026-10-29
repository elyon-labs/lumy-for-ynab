import { index, integer, primaryKey, sqliteTable, text } from 'drizzle-orm/sqlite-core';

import { budgets } from './budgets';

export const categoryGroups = sqliteTable(
  'category_groups',
  {
    id: text('id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
    hidden: integer('hidden', { mode: 'boolean' }).notNull(),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
    /**
     * Position in the payload.
     *
     * YNAB expresses the budget's ordering only by the order it returns things
     * in, so it has to be captured as the page is written or it is lost.
     */
    sortOrder: integer('sort_order').notNull(),
  },
  (table) => [
    // The budget tab's outer loop: `WHERE budget_id = ? ORDER BY sort_order`.
    index('category_groups_by_budget').on(table.budgetId, table.sortOrder),
  ],
);

export const categories = sqliteTable(
  'categories',
  {
    id: text('id').primaryKey(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    categoryGroupId: text('category_group_id')
      .notNull()
      .references(() => categoryGroups.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
    hidden: integer('hidden', { mode: 'boolean' }).notNull(),
    deleted: integer('deleted', { mode: 'boolean' }).notNull(),
    sortOrder: integer('sort_order').notNull(),

    // Target fields. YNAB still calls these goals on the wire; the app has
    // called them targets since YNAB renamed them in the product.
    targetType: text('target_type'),
    targetNeedsWholeAmount: integer('target_needs_whole_amount', { mode: 'boolean' }),
    targetDay: integer('target_day'),
    targetCadence: integer('target_cadence'),
    targetCadenceFrequency: integer('target_cadence_frequency'),
    /** YYYY-MM-01. */
    targetCreationMonth: text('target_creation_month'),
    targetBalance: integer('target_balance'),
    /** YYYY-MM-01. */
    targetMonth: text('target_month'),
    targetPercentageComplete: integer('target_percentage_complete'),
    targetMonthsToBudget: integer('target_months_to_budget'),
    targetUnderFunded: integer('target_under_funded'),
    targetOverallFunded: integer('target_overall_funded'),
    targetOverallLeft: integer('target_overall_left'),
  },
  (table) => [
    // The budget tab's inner loop: `WHERE category_group_id = ? ORDER BY
    // sort_order`.
    index('categories_by_group').on(table.categoryGroupId, table.sortOrder),
    // The target health report, which reads every category in the budget once
    // rather than walking the groups.
    index('categories_by_budget').on(table.budgetId),
  ],
);

/**
 * What a category looked like in one month.
 *
 * `budgeted`, `activity`, and `balance` are per month, so they cannot live on
 * `categories` the way the Flutter app put them there: that row can only ever
 * hold whichever month was fetched last, which is why its budget tab has to
 * refetch to move between months. Keeping them here means month navigation is
 * a different `WHERE`.
 *
 * `category_id` is deliberately not a foreign key. The categories resource is
 * the one YNAB does not describe incrementally — ordering and group renames
 * only ever arrive as a whole payload — so the writer may rewrite that table
 * wholesale, and a cascade from it would take every month of history with it.
 */
export const categoryMonths = sqliteTable(
  'category_months',
  {
    categoryId: text('category_id').notNull(),
    /** YYYY-MM-01. */
    month: text('month').notNull(),
    budgetId: text('budget_id')
      .notNull()
      .references(() => budgets.id, { onDelete: 'cascade' }),
    budgeted: integer('budgeted').notNull(),
    activity: integer('activity').notNull(),
    balance: integer('balance').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.categoryId, table.month] }),
    // Every category's figures for one month, which is the budget tab's read
    // and the target health report's.
    index('category_months_by_month').on(table.budgetId, table.month),
  ],
);
