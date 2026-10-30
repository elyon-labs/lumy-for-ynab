import type { Queryable } from '../adapters/types';

/**
 * How far each resource has been synced.
 *
 * The only module that writes this table, and it never offers a way to write
 * it on its own: `advanceKnowledge` takes a `Queryable`, which the engine only
 * ever hands it inside the transaction carrying the data the knowledge
 * describes. That is the sequencing rule the Flutter app broke — it advanced
 * knowledge on a path independent of the data write, so a partial failure left
 * the client permanently convinced it held data it had never stored.
 */

/** The `month` value for the resources that are not month scoped. */
const BUDGET_WIDE = '';

export interface KnowledgeKey {
  budgetId: string;
  resource: string;
  /** YYYY-MM-01 for a month-scoped resource. */
  month?: string;
}

export interface KnowledgeRecord {
  knowledge: number;
  /** When this resource was last fetched, as an ISO instant. */
  syncedAt: string;
}

/**
 * What the client last heard, or undefined if it has never asked.
 *
 * Undefined is what sends the next fetch without `last_knowledge_of_server`,
 * which is how a first sync and a repair both become the full-snapshot path
 * without either of them having to say so.
 */
export async function readKnowledge(
  db: Queryable,
  key: KnowledgeKey,
): Promise<KnowledgeRecord | undefined> {
  const row = await db.get<{ knowledge: number; synced_at: string }>(
    'SELECT knowledge, synced_at FROM server_knowledge WHERE budget_id = ? AND resource = ? AND month = ?',
    [key.budgetId, key.resource, key.month ?? BUDGET_WIDE],
  );

  return row === undefined ? undefined : { knowledge: row.knowledge, syncedAt: row.synced_at };
}

/** Every resource's knowledge for a budget, for the sync status screen. */
export async function readAllKnowledge(
  db: Queryable,
  budgetId: string,
): Promise<{ resource: string; month: string; knowledge: number; syncedAt: string }[]> {
  const rows = await db.all<{
    resource: string;
    month: string;
    knowledge: number;
    synced_at: string;
  }>(
    'SELECT resource, month, knowledge, synced_at FROM server_knowledge WHERE budget_id = ? ORDER BY resource, month',
    [budgetId],
  );

  return rows.map((row) => ({
    resource: row.resource,
    month: row.month,
    knowledge: row.knowledge,
    syncedAt: row.synced_at,
  }));
}

/**
 * Records where the server now stands.
 *
 * Must be the last statement of the transaction that wrote the entities this
 * number describes. If anything before it throws, the transaction rolls back
 * and the next sync asks for the same window again — which is safe precisely
 * because every write in that window is an upsert by id.
 */
export async function advanceKnowledge(
  tx: Queryable,
  key: KnowledgeKey,
  record: KnowledgeRecord,
): Promise<void> {
  await tx.run(
    `INSERT INTO server_knowledge (budget_id, resource, month, knowledge, synced_at)
     VALUES (?, ?, ?, ?, ?)
     ON CONFLICT (budget_id, resource, month)
     DO UPDATE SET knowledge = excluded.knowledge, synced_at = excluded.synced_at`,
    [key.budgetId, key.resource, key.month ?? BUDGET_WIDE, record.knowledge, record.syncedAt],
  );
}
