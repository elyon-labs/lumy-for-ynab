import type { ReadName } from '@lumy/data';

/**
 * The shape of every query key in the app.
 *
 * `[read, budgetId, ...params]`. The read's name leads, because that is what a
 * database change invalidates by: TanStack Query matches a key by prefix, so
 * invalidating `['sumBy']` reaches every cached grouping without the
 * subscriber knowing what any of them asked for.
 *
 * The budget comes second so changing the selected budget refetches
 * declaratively — a different key is a different query — rather than by
 * resubscribing to anything. The Flutter app's `DateRangeReq` /
 * `AccountsView` / `CategoriesView` request-object hierarchy existed to carry
 * what these trailing parameters carry.
 */
export type QueryKey = readonly [ReadName, string, ...unknown[]];

/**
 * Builds a key.
 *
 * Params are serialised by TanStack Query's own structural hashing, so an
 * object with the same contents is the same key whatever order its keys were
 * written in. Nothing here has to sort them.
 */
export function queryKey(read: ReadName, budgetId: string, ...params: unknown[]): QueryKey {
  return [read, budgetId, ...params];
}
