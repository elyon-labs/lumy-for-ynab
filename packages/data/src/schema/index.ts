/**
 * The schema, as Drizzle describes it.
 *
 * This is what `drizzle-kit generate` reads to produce the migration SQL in
 * `drizzle/`, and what `scripts/buildMigrations.ts` turns into the statement
 * list the runner applies. Nothing here executes: the engine's queries are
 * hand-written against the adapter, so what a test runs is what the device
 * runs, character for character.
 *
 * Tables hold YNAB's payloads as YNAB sends them. Amounts are integers in
 * milliunits and dates are `TEXT` in `YYYY-MM-DD`, which sorts and compares
 * correctly in SQLite and keeps every timezone question out of the engine.
 * Nothing above the sync engine and the ledger derivation reads these tables;
 * screens read the ledger.
 */
export * from './accounts';
export * from './budgets';
export * from './categories';
export * from './ledger';
export * from './months';
export * from './payees';
export * from './scheduledTransactions';
export * from './serverKnowledge';
export * from './settings';
export * from './transactions';
