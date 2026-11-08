import type { Queryable } from '../adapters/types';
import { MONTH_DETAIL_RESOURCE, SYNC_ORDER, SYNC_RESOURCES, type SyncResource } from '../sync/resources';
import type { CompiledStatement } from './conditions';

/**
 * How far a budget has been synced, and when it was last read.
 *
 * `server_knowledge.synced_at` is the only record of either. It is written in
 * the same transaction as the data it describes, which is what makes it worth
 * showing: a last-fetch time that could be true while the data behind it is
 * not would be worse than none. The Flutter app kept a `last_fetch` preference
 * instead — one timestamp for the whole app, written beside the fetch rather
 * than with it, and true of no particular budget.
 *
 * Both reads here are bounded by the resource list rather than by anything in
 * the database. `month_detail` is the exception: it has a row per month, so it
 * is grouped to a count and a time rather than listed.
 */

export interface ResourceSyncStatus {
  resource: SyncResource;
  /** Null for a resource that has never been fetched for this budget. */
  syncedAt: string | null;
  /** What the server last said, or null alongside a null `syncedAt`. */
  knowledge: number | null;
}

export interface BudgetSyncStatus {
  /**
   * The most recent fetch of anything in this budget, or null for a budget
   * nothing has been fetched for.
   *
   * This is the last-fetch display. It is the newest rather than the oldest
   * because it answers "when did Lumy last hear from YNAB"; which resource is
   * furthest behind is the per-resource list below.
   */
  lastFetchedAt: string | null;
  /** One entry per synced resource, in the order a sync fetches them. */
  resources: readonly ResourceSyncStatus[];
  /** The months of category detail fetched on demand, as a count and a time. */
  monthDetail: { months: number; syncedAt: string | null };
}

interface KnowledgeGroup {
  resource: string;
  synced_at: string | null;
  knowledge: number | null;
  rows: number;
}

/**
 * One row per resource, whatever number of knowledge rows it has.
 *
 * `month_detail` is the only resource with more than one, so for every other
 * the aggregates are over a single row and `MAX` is that row's own value.
 */
export function syncStatusStatement(budgetId: string): CompiledStatement {
  return {
    sql: `SELECT resource,
            MAX(synced_at) AS synced_at,
            MAX(knowledge) AS knowledge,
            COUNT(*) AS rows
          FROM server_knowledge
          WHERE budget_id = ?
          GROUP BY resource`,
    params: [budgetId],
  };
}

export async function syncStatus(db: Queryable, budgetId: string): Promise<BudgetSyncStatus> {
  const statement = syncStatusStatement(budgetId);
  const rows = await db.all<KnowledgeGroup>(statement.sql, statement.params);
  const byResource = new Map(rows.map((row) => [row.resource, row]));

  // Every resource appears, including the ones with no row — a resource that
  // has never been fetched is what the status screen is there to show, and a
  // list that simply left it out would read as nothing being wrong.
  const resources = SYNC_ORDER.map<ResourceSyncStatus>((resource) => {
    const row = byResource.get(resource);

    return {
      resource,
      syncedAt: row?.synced_at ?? null,
      knowledge: row?.knowledge ?? null,
    };
  });

  const detail = byResource.get(MONTH_DETAIL_RESOURCE);

  return {
    lastFetchedAt: rows.reduce<string | null>(
      (latest, row) =>
        row.synced_at !== null && (latest === null || row.synced_at > latest)
          ? row.synced_at
          : latest,
      null,
    ),
    resources,
    monthDetail: { months: detail?.rows ?? 0, syncedAt: detail?.synced_at ?? null },
  };
}

/**
 * Whether every resource of a budget has been fetched at least once.
 *
 * This is the question the first-run sync screen is gated on, and it is asked
 * of all of `SYNC_RESOURCES` rather than of any row at all. A first sync that
 * fails after the accounts page commits leaves one knowledge row behind, and
 * answering true to that would drop someone into a shell holding accounts and
 * nothing else. Every resource, or the sync is not done.
 *
 * `month_detail` is deliberately not counted. It is fetched a month at a time,
 * on demand, so a budget can be completely synced and have none.
 */
export function hasSyncedDataStatement(budgetId: string): CompiledStatement {
  return {
    sql: `SELECT COUNT(DISTINCT resource) AS synced
          FROM server_knowledge
          WHERE budget_id = ? AND resource IN (${SYNC_RESOURCES.map(() => '?').join(', ')})`,
    params: [budgetId, ...SYNC_RESOURCES],
  };
}

export async function hasSyncedData(db: Queryable, budgetId: string): Promise<boolean> {
  const statement = hasSyncedDataStatement(budgetId);
  const row = await db.get<{ synced: number }>(statement.sql, statement.params);

  return (row?.synced ?? 0) === SYNC_RESOURCES.length;
}
