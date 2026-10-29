import { GENERATED_MIGRATIONS } from './generated';
import type { Migration } from './types';

/**
 * Every migration, in order.
 *
 * The statements come from `drizzle-kit generate`, compiled into a module by
 * `scripts/buildMigrations.ts` so that nothing has to read a `.sql` file on a
 * device. Changing the schema means editing `src/schema/` and running
 * `pnpm --dir packages/data db:generate`, never editing the SQL or the
 * generated module by hand.
 */
export const MIGRATIONS: readonly Migration[] = GENERATED_MIGRATIONS;

export type { Migration } from './types';
