import { readdirSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

import { generateSQLiteDrizzleJson, generateSQLiteMigration } from 'drizzle-kit/api';
import { describe, expect, it } from 'vitest';

import { readGeneratedMigrations, renderModule } from '../../scripts/buildMigrations';
import * as schema from '../schema';
import { GENERATED_MIGRATIONS } from './generated';
import { MIGRATIONS } from './index';

const PACKAGE_ROOT = join(dirname(fileURLToPath(import.meta.url)), '../..');
const SQL_DIR = join(PACKAGE_ROOT, 'drizzle');

/** The state drizzle recorded when it last generated SQL. */
function latestSnapshot(): unknown {
  const snapshots = readdirSync(join(SQL_DIR, 'meta'))
    .filter((file) => file.endsWith('_snapshot.json'))
    .sort();
  const latest = snapshots.at(-1);

  if (latest === undefined) throw new Error('No drizzle snapshot to compare against.');

  return JSON.parse(readFileSync(join(SQL_DIR, 'meta', latest), 'utf8'));
}

describe('the generated migrations', () => {
  it('are what the runner applies', () => {
    expect(MIGRATIONS).toBe(GENERATED_MIGRATIONS);
    expect(MIGRATIONS.length).toBeGreaterThan(0);
  });

  it('match the SQL they were built from', () => {
    // The committed module is what the device applies, and the committed SQL
    // is what review reads. If one is regenerated without the other they stop
    // describing the same schema, which is invisible until a query fails.
    const expected = renderModule(readGeneratedMigrations(SQL_DIR));
    const committed = readFileSync(join(PACKAGE_ROOT, 'src/migrations/generated.ts'), 'utf8');

    expect(committed).toBe(expected);
  });

  it('cover everything the schema describes', async () => {
    // Drizzle is not in the runtime path, so a table added to `src/schema`
    // without running `db:generate` would otherwise change nothing and say
    // nothing. Asking drizzle for the migration from its own last snapshot to
    // the schema as it now stands catches exactly that: anything left to
    // generate is something the schema has and the database would not.
    const current = await generateSQLiteDrizzleJson(schema);
    // Drizzle does not export the snapshot's type, and the one it takes is
    // the one it wrote.
    const previous = latestSnapshot() as typeof current;

    expect(await generateSQLiteMigration(previous, current)).toEqual([]);
  });
});
