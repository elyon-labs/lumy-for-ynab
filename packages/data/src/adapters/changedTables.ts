const WRITE_STATEMENT =
  /^\s*(?:insert(?:\s+or\s+\w+)?\s+into|replace\s+into|update(?:\s+or\s+\w+)?|delete\s+from|drop\s+table(?:\s+if\s+exists)?|alter\s+table|create\s+table(?:\s+if\s+not\s+exists)?)\s+(?:(?:main|temp)\.)?["'`[]?([A-Za-z_][A-Za-z0-9_]*)/i;

/**
 * The table a statement writes to, or null if it writes to none.
 *
 * Change notification is derived from the statements that ran rather than
 * taken from the driver. Expo's own listener fires per row and per connection,
 * where what the app needs is one notification per committed transaction, with
 * the set of tables it touched — that is what maps onto the query keys to
 * invalidate. Deriving it here also means both adapters behave identically, so
 * the reactivity can be tested without a device.
 */
export function writtenTable(sql: string): string | null {
  const match = WRITE_STATEMENT.exec(sql);

  return match?.[1]?.toLowerCase() ?? null;
}

/** Collects the tables written during one transaction. */
export class ChangedTables {
  private readonly tables = new Set<string>();

  record(sql: string): void {
    const table = writtenTable(sql);
    if (table !== null) {
      this.tables.add(table);
    }
  }

  drain(): readonly string[] {
    const drained = [...this.tables].sort();
    this.tables.clear();

    return drained;
  }
}
