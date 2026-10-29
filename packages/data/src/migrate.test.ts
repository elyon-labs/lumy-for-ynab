import { describe, expect, it } from 'vitest';

import { openNodeDatabase } from './adapters/nodeSqlite';
import { migrate, schemaVersion } from './migrate';
import { MIGRATIONS, type Migration } from './migrations';

const first: Migration = {
  id: 1,
  name: 'widgets',
  statements: ['CREATE TABLE widgets (id INTEGER PRIMARY KEY, name TEXT NOT NULL)'],
};

const second: Migration = {
  id: 2,
  name: 'widget_note',
  statements: ['ALTER TABLE widgets ADD COLUMN note TEXT'],
};

async function tables(db: ReturnType<typeof openNodeDatabase>): Promise<string[]> {
  const rows = await db.all<{ name: string }>(
    "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name",
  );

  return rows.map((row) => row.name);
}

describe('migrate', () => {
  it('applies everything to an empty database', async () => {
    const db = openNodeDatabase();

    const result = await migrate(db, [first, second]);

    expect(result).toEqual({ applied: [1, 2], version: 2 });
    expect(await tables(db)).toContain('widgets');

    await db.close();
  });

  it('does nothing the second time', async () => {
    const db = openNodeDatabase();
    await migrate(db, [first, second]);

    const result = await migrate(db, [first, second]);

    expect(result).toEqual({ applied: [], version: 2 });

    await db.close();
  });

  it('applies only what is outstanding', async () => {
    const db = openNodeDatabase();
    await migrate(db, [first]);

    const result = await migrate(db, [first, second]);

    expect(result).toEqual({ applied: [2], version: 2 });

    await db.close();
  });

  it('records what it applied', async () => {
    const db = openNodeDatabase();
    await migrate(db, [first, second]);

    const rows = await db.all<{ id: number; name: string }>(
      'SELECT id, name FROM schema_migrations ORDER BY id',
    );

    expect(rows).toEqual([
      { id: 1, name: 'widgets' },
      { id: 2, name: 'widget_note' },
    ]);

    await db.close();
  });

  it('leaves the database at the last version that fully landed', async () => {
    const db = openNodeDatabase();
    const broken: Migration = {
      id: 2,
      name: 'broken',
      statements: [
        'CREATE TABLE gadgets (id INTEGER PRIMARY KEY)',
        'CREATE TABLE gadgets (id INTEGER PRIMARY KEY)',
      ],
    };

    await expect(migrate(db, [first, broken])).rejects.toThrow();

    // Not halfway into the second: the table its first statement created is
    // gone along with the rest of it.
    expect(await schemaVersion(db)).toBe(1);
    expect(await tables(db)).not.toContain('gadgets');

    await db.close();
  });

  it('refuses a database written by a newer build', async () => {
    const db = openNodeDatabase();
    await migrate(db, [first, second]);

    // Downgrading would migrate forward from a version whose statements this
    // build does not have, silently skipping them.
    await expect(migrate(db, [first])).rejects.toThrow(/newer than this build/);

    await db.close();
  });

  describe('rejects a list that cannot be applied deterministically', () => {
    it.each([
      ['a gap', [first, { ...second, id: 3 }]],
      ['a duplicate', [first, { ...second, id: 1 }]],
      ['numbering that does not start at 1', [{ ...first, id: 0 }]],
      ['an out-of-order pair', [second, first]],
    ])('%s', async (_case, migrations) => {
      const db = openNodeDatabase();

      await expect(migrate(db, migrations as Migration[])).rejects.toThrow(/numbered from 1/);

      await db.close();
    });

    it('a migration with no statements', async () => {
      const db = openNodeDatabase();

      await expect(migrate(db, [{ id: 1, name: 'empty', statements: [] }])).rejects.toThrow(
        /no statements/,
      );

      await db.close();
    });
  });
});

describe('schemaVersion', () => {
  it('is zero before anything has run', async () => {
    const db = openNodeDatabase();

    expect(await schemaVersion(db)).toBe(0);

    await db.close();
  });

  it('is zero for a database with the ledger but no migrations', async () => {
    const db = openNodeDatabase();
    await migrate(db, []);

    expect(await schemaVersion(db)).toBe(0);

    await db.close();
  });
});

describe('the shipped migration list', () => {
  it('applies to an empty database', async () => {
    // The list is empty until the schema lands; this is the test that will
    // carry every migration after it.
    const db = openNodeDatabase();

    await expect(migrate(db, MIGRATIONS)).resolves.toEqual({
      applied: MIGRATIONS.map((migration) => migration.id),
      version: MIGRATIONS.length,
    });

    await db.close();
  });

  it('is numbered from 1 with no gaps', () => {
    expect(MIGRATIONS.map((migration) => migration.id)).toEqual(
      MIGRATIONS.map((_migration, index) => index + 1),
    );
  });
});
