import type { Queryable, SqlValue } from '../adapters/types';

/**
 * Writing rows by id, which is what makes a replayed page a no-op.
 *
 * YNAB ids are stable, so `INSERT ... ON CONFLICT(id) DO UPDATE` is the whole
 * idempotency story for the raw tables: a sync that is retried, duplicated, or
 * resumed after a crash converges on the same rows rather than adding more.
 */

/**
 * How many parameters one statement may bind.
 *
 * SQLite's own limit is far higher, but staying well inside it means the
 * number of rows per statement never has to be reasoned about per table.
 */
const MAX_BOUND_PARAMETERS = 900;

export interface UpsertOptions {
  table: string;
  /** The columns that identify a row — the table's primary key. */
  conflict: readonly string[];
  /** Every row must carry the same columns, which the mappers above guarantee. */
  rows: readonly Record<string, SqlValue>[];
}

/**
 * Upserts rows, batched so no single statement binds an unbounded number of
 * parameters.
 *
 * A row's non-key columns are all overwritten from the payload. That is
 * deliberate: the raw tables hold what YNAB last said, and a column left
 * alone on update is a column that can disagree with the server forever.
 */
export async function upsert(tx: Queryable, options: UpsertOptions): Promise<void> {
  if (options.rows.length === 0) return;

  const columns = Object.keys(options.rows[0]);
  const assignments = columns
    .filter((column) => !options.conflict.includes(column))
    .map((column) => `${column} = excluded.${column}`);
  const resolution =
    assignments.length === 0 ? 'DO NOTHING' : `DO UPDATE SET ${assignments.join(', ')}`;

  const rowsPerStatement = Math.max(1, Math.floor(MAX_BOUND_PARAMETERS / columns.length));
  const tuple = `(${columns.map(() => '?').join(', ')})`;

  for (let start = 0; start < options.rows.length; start += rowsPerStatement) {
    const batch = options.rows.slice(start, start + rowsPerStatement);
    const sql = `
      INSERT INTO ${options.table} (${columns.join(', ')})
      VALUES ${batch.map(() => tuple).join(', ')}
      ON CONFLICT (${options.conflict.join(', ')}) ${resolution}`;

    await tx.run(
      sql,
      batch.flatMap((row) => columns.map((column) => row[column] ?? null)),
    );
  }
}

/** `DELETE ... WHERE <column> IN (...)`, batched on the same parameter budget. */
export async function deleteWhereIn(
  tx: Queryable,
  table: string,
  column: string,
  values: readonly string[],
  scope: { column: string; value: SqlValue } | null = null,
): Promise<void> {
  for (let start = 0; start < values.length; start += MAX_BOUND_PARAMETERS) {
    const batch = values.slice(start, start + MAX_BOUND_PARAMETERS);
    const scoped = scope === null ? '' : ` AND ${scope.column} = ?`;
    const params: SqlValue[] = scope === null ? [...batch] : [...batch, scope.value];

    await tx.run(
      `DELETE FROM ${table} WHERE ${column} IN (${batch.map(() => '?').join(', ')})${scoped}`,
      params,
    );
  }
}

