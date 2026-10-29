import { integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

/**
 * A YNAB budget.
 *
 * Every other table here is scoped to one of these and cascades from it, so
 * discarding a budget's cached data — which is what the repair path does — is
 * a single delete rather than a list of them that can fall out of date as
 * tables are added.
 */
export const budgets = sqliteTable('budgets', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
  /** YYYY-MM-01. */
  firstMonth: text('first_month'),
  /** YYYY-MM-01. */
  lastMonth: text('last_month'),
  lastModifiedOn: text('last_modified_on'),
});

/**
 * How a budget's amounts are written.
 *
 * One row per budget rather than columns on `budgets`, because YNAB can return
 * a budget without one and the formatter needs the whole set or none of it.
 */
export const currencyFormats = sqliteTable('currency_formats', {
  budgetId: text('budget_id')
    .primaryKey()
    .references(() => budgets.id, { onDelete: 'cascade' }),
  isoCode: text('iso_code').notNull(),
  decimalDigits: integer('decimal_digits').notNull(),
  decimalSeparator: text('decimal_separator').notNull(),
  symbolFirst: integer('symbol_first', { mode: 'boolean' }).notNull(),
  groupSeparator: text('group_separator').notNull(),
  currencySymbol: text('currency_symbol').notNull(),
  displaySymbol: integer('display_symbol', { mode: 'boolean' }).notNull(),
  exampleFormat: text('example_format').notNull(),
});
