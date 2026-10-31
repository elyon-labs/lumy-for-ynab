import { primaryKey, sqliteTable, text } from 'drizzle-orm/sqlite-core';

/**
 * What the person chose, as opposed to what YNAB said.
 *
 * It lives in SQLite rather than in AsyncStorage so that the background sync
 * task can read the selected budget and the selected period without booting
 * React, and so that a change to a setting travels the same invalidation path
 * as a change to the ledger — a screen reading a setting re-reads it when it
 * is written, with nothing registered per screen.
 *
 * This replaces `lib/persistence/settings.dart`, which held each setting as a
 * `rx_shared_preferences` stream and composed budget scoping by interpolating
 * the budget id into the preference key at every call site.
 *
 * Nothing here cascades from `budgets`, and the scope column is deliberately
 * not called `budget_id`. A repair discards a budget's cached YNAB data and
 * syncs it again; what the person chose is not cached YNAB data, and losing
 * their chart order to a repair would be a bug. The column is also not always
 * a budget: `''` is what a setting that is not scoped to one stores, for the
 * same reason `server_knowledge.month` is `''` rather than null — SQLite
 * compares nulls in a primary key as distinct, so a nullable column here
 * would let one setting accumulate a row per write.
 *
 * `value` is JSON and is never null. A setting that has never been written has
 * no row at all, and that absence is what the typed accessor reads as the
 * setting's default.
 */
export const settings = sqliteTable(
  'settings',
  {
    key: text('key').notNull(),
    /** A budget id for the budget-scoped settings, `''` for the rest. */
    scope: text('scope').notNull().default(''),
    /** JSON, decoded by the setting's own codec. */
    value: text('value').notNull(),
  },
  (table) => [primaryKey({ columns: [table.key, table.scope] })],
);
