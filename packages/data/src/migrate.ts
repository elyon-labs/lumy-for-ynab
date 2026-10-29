import type { DatabaseAdapter, Queryable } from './adapters/types';
import { MIGRATIONS, type Migration } from './migrations';

const LEDGER_TABLE = 'schema_migrations';

const CREATE_LEDGER = `
  CREATE TABLE IF NOT EXISTS ${LEDGER_TABLE} (
    id         INTEGER PRIMARY KEY,
    name       TEXT NOT NULL,
    applied_at TEXT NOT NULL
  )
`;

export interface MigrationResult {
  /** What this run applied, in the order it applied them. */
  applied: readonly number[];
  /** Where the schema now stands. */
  version: number;
}

/**
 * Rejects a list that cannot be applied deterministically.
 *
 * A gap or a duplicate means two databases that both report the same version
 * may have had different statements run against them, which is the kind of
 * divergence that is invisible until a query fails on one device.
 */
function assertWellFormed(migrations: readonly Migration[]): void {
  migrations.forEach((migration, index) => {
    const expected = index + 1;
    if (migration.id !== expected) {
      throw new Error(
        `Migrations must be numbered from 1 with no gaps: expected ${expected}, found ${migration.id} ("${migration.name}").`,
      );
    }
    if (migration.statements.length === 0) {
      throw new Error(`Migration ${migration.id} ("${migration.name}") has no statements.`);
    }
  });
}

async function appliedIds(db: Queryable): Promise<number[]> {
  const rows = await db.all<{ id: number }>(`SELECT id FROM ${LEDGER_TABLE} ORDER BY id`);

  return rows.map((row) => row.id);
}

/**
 * Brings the database up to the current schema.
 *
 * Each migration applies inside its own transaction together with the row that
 * records it, so a failure leaves the database at the last version that fully
 * landed rather than halfway into the next one. Running this against an
 * already-current database does nothing.
 */
export async function migrate(
  adapter: DatabaseAdapter,
  migrations: readonly Migration[] = MIGRATIONS,
): Promise<MigrationResult> {
  assertWellFormed(migrations);

  await adapter.runAll([CREATE_LEDGER]);

  const already = new Set(await appliedIds(adapter));

  // A database that has applied something this build does not know about was
  // written by a newer version. Migrating it forward from here would skip
  // whatever that version did, so it stops instead.
  const highestKnown = migrations.length;
  for (const id of already) {
    if (id > highestKnown) {
      throw new Error(
        `Database is at schema version ${id}, which is newer than this build knows about (${highestKnown}).`,
      );
    }
  }

  const applied: number[] = [];

  for (const migration of migrations) {
    if (already.has(migration.id)) continue;

    await adapter.transaction(async (tx) => {
      await tx.runAll(migration.statements);
      await tx.run(`INSERT INTO ${LEDGER_TABLE} (id, name, applied_at) VALUES (?, ?, ?)`, [
        migration.id,
        migration.name,
        new Date().toISOString(),
      ]);
    });

    applied.push(migration.id);
  }

  const version = Math.max(0, ...already, ...applied);

  return { applied, version };
}

/** The version the database is currently at, or 0 if it has never been migrated. */
export async function schemaVersion(adapter: DatabaseAdapter): Promise<number> {
  const table = await adapter.get<{ name: string }>(
    "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
    [LEDGER_TABLE],
  );
  if (table === undefined) return 0;

  const row = await adapter.get<{ version: number | null }>(
    `SELECT MAX(id) AS version FROM ${LEDGER_TABLE}`,
  );

  return row?.version ?? 0;
}
