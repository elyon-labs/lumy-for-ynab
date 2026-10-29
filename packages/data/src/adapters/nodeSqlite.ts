import { DatabaseSync } from 'node:sqlite';

import { ChangedTables } from './changedTables';
import type { DatabaseAdapter, Queryable, Row, SqlValue } from './types';

/**
 * The adapter the tests run against, over Node's built-in SQLite.
 *
 * It is the same engine the device runs, driven by the same statements, so a
 * correctness test here is a statement about what ships rather than about a
 * stand-in. It needs no native build, which keeps the whole suite runnable in
 * CI without a compiler.
 */
export function openNodeDatabase(path = ':memory:'): DatabaseAdapter {
  const database = new DatabaseSync(path);

  // Foreign keys are off by default in SQLite, so a schema that declares them
  // would not actually enforce them.
  database.exec('PRAGMA foreign_keys = ON');

  const listeners = new Set<(tables: readonly string[]) => void>();
  let depth = 0;
  let changed = new ChangedTables();

  function queryable(track: ChangedTables): Queryable {
    return {
      async run(sql, params = []) {
        track.record(sql);
        database.prepare(sql).run(...(params as SqlValue[]));
      },

      async runAll(statements) {
        for (const statement of statements) {
          track.record(statement);
          database.exec(statement);
        }
      },

      async all<T = Row>(sql: string, params: readonly SqlValue[] = []) {
        return database.prepare(sql).all(...(params as SqlValue[])) as T[];
      },

      async get<T = Row>(sql: string, params: readonly SqlValue[] = []) {
        return database.prepare(sql).get(...(params as SqlValue[])) as T | undefined;
      },
    };
  }

  function announce(tables: readonly string[]): void {
    if (tables.length === 0) return;

    for (const listener of listeners) {
      listener(tables);
    }
  }

  const outer = queryable(changed);

  return {
    async run(sql, params) {
      await outer.run(sql, params);
      // Outside a transaction each statement commits on its own, so it is also
      // its own notification.
      if (depth === 0) announce(changed.drain());
    },

    async runAll(statements) {
      await outer.runAll(statements);
      if (depth === 0) announce(changed.drain());
    },

    all: outer.all,
    get: outer.get,

    async transaction(work) {
      // Nesting would mean an inner rollback could not be honoured, so it is
      // refused rather than quietly flattened into the outer transaction.
      if (depth > 0) {
        throw new Error('Transactions cannot be nested; pass the existing tx down instead.');
      }

      depth += 1;
      changed = new ChangedTables();
      const tx = queryable(changed);

      database.exec('BEGIN IMMEDIATE');
      try {
        const result = await work(tx);
        database.exec('COMMIT');
        depth -= 1;
        announce(changed.drain());

        return result;
      } catch (error) {
        database.exec('ROLLBACK');
        depth -= 1;
        // Nothing was committed, so nothing changed.
        changed.drain();

        throw error;
      }
    },

    onTablesChanged(listener) {
      listeners.add(listener);

      return () => listeners.delete(listener);
    },

    async close() {
      listeners.clear();
      database.close();
    },

    async sqliteVersion() {
      const row = database.prepare('SELECT sqlite_version() AS version').get() as {
        version: string;
      };

      return row.version;
    },
  };
}
