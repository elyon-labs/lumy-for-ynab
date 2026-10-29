import { openDatabaseAsync, type SQLiteDatabase } from 'expo-sqlite';

import { ChangedTables } from './changedTables';
import type { DatabaseAdapter, Queryable, Row, SqlValue } from './types';

/** The file the app's cache of YNAB data lives in. */
export const DATABASE_NAME = 'lumy.db';

/**
 * The adapter the app runs against.
 *
 * It is the only module in this package that names a driver. Everything above
 * it works against the adapter interface, which is what keeps a second backend
 * — a wasm build for the web, say — a matter of adding a file rather than
 * touching the engine.
 */
export async function openAppDatabase(name = DATABASE_NAME): Promise<DatabaseAdapter> {
  const database = await openDatabaseAsync(name);

  // Write-ahead logging lets a read proceed while a sync writes, which is the
  // normal state of this app: a list on screen while a delta lands behind it.
  await database.execAsync('PRAGMA journal_mode = WAL');
  await database.execAsync('PRAGMA foreign_keys = ON');

  const listeners = new Set<(tables: readonly string[]) => void>();

  function queryable(target: SQLiteDatabase, track: ChangedTables): Queryable {
    return {
      async run(sql, params = []) {
        track.record(sql);
        await target.runAsync(sql, params as SqlValue[]);
      },

      async runAll(statements) {
        for (const statement of statements) {
          track.record(statement);
          await target.execAsync(statement);
        }
      },

      async all<T = Row>(sql: string, params: readonly SqlValue[] = []) {
        return (await target.getAllAsync(sql, params as SqlValue[])) as T[];
      },

      async get<T = Row>(sql: string, params: readonly SqlValue[] = []) {
        return ((await target.getFirstAsync(sql, params as SqlValue[])) ?? undefined) as
          | T
          | undefined;
      },
    };
  }

  function announce(tables: readonly string[]): void {
    if (tables.length === 0) return;

    for (const listener of listeners) {
      listener(tables);
    }
  }

  const loose = new ChangedTables();
  const outer = queryable(database, loose);

  return {
    async run(sql, params) {
      await outer.run(sql, params);
      announce(loose.drain());
    },

    async runAll(statements) {
      await outer.runAll(statements);
      announce(loose.drain());
    },

    all: outer.all,
    get: outer.get,

    async transaction(work) {
      const changed = new ChangedTables();
      let result!: Awaited<ReturnType<typeof work>>;

      // Exclusive, so a concurrent write cannot interleave with this one. The
      // sync engine depends on it: a delta page's raw rows, its reconciled
      // children, its rebuilt ledger entries, and its server knowledge all
      // commit together or not at all.
      await database.withExclusiveTransactionAsync(async (tx) => {
        result = await work(queryable(tx as unknown as SQLiteDatabase, changed));
      });

      announce(changed.drain());

      return result;
    },

    onTablesChanged(listener) {
      listeners.add(listener);

      return () => listeners.delete(listener);
    },

    async close() {
      listeners.clear();
      await database.closeAsync();
    },

    async sqliteVersion() {
      const row = await database.getFirstAsync<{ version: string }>(
        'SELECT sqlite_version() AS version',
      );

      return row?.version ?? 'unknown';
    },
  };
}
