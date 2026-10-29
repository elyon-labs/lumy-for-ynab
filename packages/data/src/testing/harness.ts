import { openNodeDatabase } from '../adapters/nodeSqlite';
import type { DatabaseAdapter } from '../adapters/types';
import { migrate, type Migration } from '../index';

export interface Harness {
  db: DatabaseAdapter;
  /** Every table the notifier reported, one entry per committed transaction. */
  changes: readonly (readonly string[])[];
  close: () => Promise<void>;
}

export interface HarnessOptions {
  /**
   * Overrides the shipped migration list.
   *
   * A test about the runner itself supplies its own; a test about a query
   * leaves this alone so it runs against the real schema.
   */
  migrations?: readonly Migration[];
}

/**
 * An in-memory database at the current schema, with its change notifications
 * recorded.
 *
 * Every test in this package starts here. It is the reason the engine's
 * correctness can be asserted without a simulator: the same statements, the
 * same schema, and the same engine as the device, opened in a few
 * milliseconds.
 */
export async function createHarness(options: HarnessOptions = {}): Promise<Harness> {
  const db = openNodeDatabase();
  const changes: (readonly string[])[] = [];

  await migrate(db, options.migrations);

  // Subscribed after migrating, so a test asserting on what its own writes
  // changed does not have to look past the schema being created first.
  db.onTablesChanged((tables) => changes.push(tables));

  return {
    db,
    changes,
    close: () => db.close(),
  };
}
