/**
 * The resources a budget is synced from.
 *
 * These strings are the `resource` column of `server_knowledge`, so they are
 * part of the stored state and cannot be renamed without a migration.
 */
export const SYNC_RESOURCES = [
  'accounts',
  'payees',
  'categories',
  'months',
  'transactions',
  'scheduled_transactions',
] as const;

export type SyncResource = (typeof SYNC_RESOURCES)[number];

/**
 * The order a sync fetches in, which is the order above.
 *
 * Payees and categories come before transactions because the ledger resolves
 * a leaf's payee name, category name, and category group against those tables
 * as it derives. Deriving first and syncing the names afterwards would leave a
 * first sync's entries holding whatever the transaction payload happened to
 * carry.
 */
export const SYNC_ORDER: readonly SyncResource[] = SYNC_RESOURCES;

/**
 * The resources YNAB describes incrementally in a way this client can use.
 *
 * `categories` is absent, and that is a decision rather than an omission.
 * YNAB states a budget's category ordering only by the order it returns
 * groups and categories in, and a delta page contains only what changed — so
 * its array positions describe the changed subset, not the budget. The
 * payload is bounded by the budget's structure rather than by its transaction
 * count, so fetching it whole every sync costs one small request and keeps
 * the ordering true.
 */
const DELTA_RESOURCES = new Set<SyncResource>([
  'accounts',
  'payees',
  'months',
  'transactions',
  'scheduled_transactions',
]);

export function supportsDelta(resource: SyncResource): boolean {
  return DELTA_RESOURCES.has(resource);
}

/**
 * The `resource` value for one month's detail.
 *
 * Month-scoped, so its `server_knowledge` rows carry the month they describe
 * rather than the `''` the budget-wide resources use. It is not in
 * `SYNC_RESOURCES` because it is fetched a month at a time, on demand, rather
 * than as part of a budget sync.
 */
export const MONTH_DETAIL_RESOURCE = 'month_detail';
