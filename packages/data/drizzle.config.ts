import { defineConfig } from 'drizzle-kit';

/**
 * Drizzle describes the schema and generates the SQL that creates it. It does
 * not execute anything: `scripts/buildMigrations.ts` turns what it writes into
 * the statement list the runner applies, and every query in this package is
 * hand-written against the adapter.
 */
export default defineConfig({
  dialect: 'sqlite',
  schema: './src/schema/index.ts',
  out: './drizzle',
});
