/** Every value SQLite will bind to a parameter. */
export type SqlValue = string | number | null | Uint8Array;

export interface Row {
  [column: string]: SqlValue;
}

/**
 * Somewhere statements can run: the database itself, or a transaction on it.
 *
 * Deliberately small. Everything in this package is hand-written SQL so that
 * the aggregates SQLite computes are the ones that were written, and so the
 * statements the tests run are the statements the device runs.
 */
export interface Queryable {
  /** Runs a statement that returns nothing. */
  run(sql: string, params?: readonly SqlValue[]): Promise<void>;
  /** Runs several statements in order, for migrations and schema work. */
  runAll(statements: readonly string[]): Promise<void>;
  /** Runs a query and returns every row. Callers bound their own result sets. */
  all<T = Row>(sql: string, params?: readonly SqlValue[]): Promise<T[]>;
  /** Runs a query expected to match at most one row. */
  get<T = Row>(sql: string, params?: readonly SqlValue[]): Promise<T | undefined>;
}

export interface DatabaseAdapter extends Queryable {
  /**
   * Runs `work` inside one transaction, committing when it resolves and
   * rolling back when it throws.
   *
   * Statements must go through the `tx` handed in. Holding onto it past the
   * callback, or reaching for the adapter instead, is how a write escapes the
   * transaction it was supposed to be atomic with.
   */
  transaction<T>(work: (tx: Queryable) => Promise<T>): Promise<T>;

  /**
   * Called once per committed transaction with the tables it wrote to.
   *
   * Returns the function that stops listening.
   */
  onTablesChanged(listener: (tables: readonly string[]) => void): () => void;

  close(): Promise<void>;

  /** The engine's version, so a test can state what it is relying on. */
  sqliteVersion(): Promise<string>;
}
