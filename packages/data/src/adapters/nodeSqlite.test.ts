import { describe, expect, it } from 'vitest';

import { openNodeDatabase } from './nodeSqlite';
import type { DatabaseAdapter } from './types';

async function openWithTable(): Promise<DatabaseAdapter> {
  const db = openNodeDatabase();
  await db.runAll(['CREATE TABLE widgets (id INTEGER PRIMARY KEY, name TEXT NOT NULL)']);

  return db;
}

describe('the engine', () => {
  it('is a SQLite recent enough for what the schema relies on', async () => {
    const db = openNodeDatabase();
    const version = await db.sqliteVersion();
    const [major = 0, minor = 0] = version.split('.').map(Number);

    // Partial indexes (3.8), window functions (3.25), and upsert (3.24) are
    // all used by the engine. Stating the floor here means a driver swap that
    // moves backwards fails on this test rather than on a query.
    expect(major).toBeGreaterThanOrEqual(3);
    expect(major > 3 || minor >= 35).toBe(true);

    await db.close();
  });

  it('enforces foreign keys, which SQLite does not do by default', async () => {
    const db = openNodeDatabase();
    const row = await db.get<{ on: number }>('PRAGMA foreign_keys');

    expect(Object.values(row ?? {})[0]).toBe(1);

    await db.close();
  });
});

describe('statements', () => {
  it('binds parameters and reads rows back', async () => {
    const db = await openWithTable();
    await db.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);

    expect(await db.all('SELECT * FROM widgets')).toEqual([{ id: 1, name: 'first' }]);
    expect(await db.get('SELECT name FROM widgets WHERE id = ?', [1])).toEqual({ name: 'first' });

    await db.close();
  });

  it('returns undefined rather than null for a missing row', async () => {
    const db = await openWithTable();

    expect(await db.get('SELECT * FROM widgets WHERE id = ?', [404])).toBeUndefined();

    await db.close();
  });
});

describe('transactions', () => {
  it('commits what the callback did', async () => {
    const db = await openWithTable();

    await db.transaction(async (tx) => {
      await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'kept']);
    });

    expect(await db.all('SELECT * FROM widgets')).toHaveLength(1);

    await db.close();
  });

  it('rolls back everything when the callback throws', async () => {
    const db = await openWithTable();

    await expect(
      db.transaction(async (tx) => {
        await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);
        await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [2, 'second']);
        throw new Error('something went wrong partway through');
      }),
    ).rejects.toThrow('something went wrong partway through');

    // Not one of the two, rather than the first without the second: this is the
    // property the sync engine depends on for a delta page.
    expect(await db.all('SELECT * FROM widgets')).toEqual([]);

    await db.close();
  });

  it('rolls back when a statement itself fails', async () => {
    const db = await openWithTable();

    await expect(
      db.transaction(async (tx) => {
        await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);
        await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'duplicate']);
      }),
    ).rejects.toThrow();

    expect(await db.all('SELECT * FROM widgets')).toEqual([]);

    await db.close();
  });

  it('refuses to nest rather than flattening', async () => {
    const db = await openWithTable();

    await expect(
      db.transaction(async () => {
        await db.transaction(async () => undefined);
      }),
    ).rejects.toThrow(/cannot be nested/);

    await db.close();
  });

  it('returns what the callback returned', async () => {
    const db = await openWithTable();

    const count = await db.transaction(async (tx) => {
      await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);
      const rows = await tx.all<{ total: number }>('SELECT COUNT(*) AS total FROM widgets');

      return rows[0]?.total ?? 0;
    });

    expect(count).toBe(1);

    await db.close();
  });
});

describe('change notification', () => {
  it('reports one set of tables per committed transaction', async () => {
    const db = await openWithTable();
    const seen: (readonly string[])[] = [];
    db.onTablesChanged((tables) => seen.push(tables));

    await db.transaction(async (tx) => {
      await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);
      await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [2, 'second']);
    });

    // Two writes, one notification: the UI should refresh once per commit, not
    // once per row.
    expect(seen).toEqual([['widgets']]);

    await db.close();
  });

  it('says nothing when a transaction rolls back', async () => {
    const db = await openWithTable();
    const seen: (readonly string[])[] = [];
    db.onTablesChanged((tables) => seen.push(tables));

    await expect(
      db.transaction(async (tx) => {
        await tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);
        throw new Error('rolled back');
      }),
    ).rejects.toThrow();

    expect(seen).toEqual([]);

    await db.close();
  });

  it('still reports a statement run on its own after a transaction', async () => {
    // A transaction tracks its own writes, and the tracker the loose
    // statements record into is not the one it uses. Sharing one variable
    // between them left every later `run` recording somewhere nothing drained,
    // so a settings write — the one write in the app that is a single
    // statement — notified nothing and the screen reading it never re-read.
    const db = await openWithTable();
    const seen: (readonly string[])[] = [];
    db.onTablesChanged((tables) => seen.push(tables));

    await db.transaction((tx) => tx.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'a']));
    await db.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [2, 'b']);

    expect(seen).toEqual([['widgets'], ['widgets']]);

    await db.close();
  });

  it('says nothing for a read', async () => {
    const db = await openWithTable();
    const seen: (readonly string[])[] = [];
    db.onTablesChanged((tables) => seen.push(tables));

    await db.all('SELECT * FROM widgets');

    expect(seen).toEqual([]);

    await db.close();
  });

  it('stops when the listener unsubscribes', async () => {
    const db = await openWithTable();
    const seen: (readonly string[])[] = [];
    const stop = db.onTablesChanged((tables) => seen.push(tables));

    await db.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [1, 'first']);
    stop();
    await db.run('INSERT INTO widgets (id, name) VALUES (?, ?)', [2, 'second']);

    expect(seen).toEqual([['widgets']]);

    await db.close();
  });
});
