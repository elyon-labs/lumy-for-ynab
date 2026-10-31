import { readsAffectedBy, type DatabaseAdapter, type ReadName } from '@lumy/data';
import type { QueryClient } from '@tanstack/react-query';

/**
 * The whole of the app's reactivity.
 *
 * Writes happen in exactly two places — the sync engine and mutations — and
 * both go through the adapter, which reports the tables each committed
 * transaction wrote to. This maps those tables to the reads they make stale
 * and invalidates those query keys; the affected queries re-run their SQL and
 * the UI follows.
 *
 * That is all of it. There is no observable-query layer, no `BehaviorSubject`
 * of every transaction, no stream cache keyed by a view object, and no manual
 * subscription bookkeeping — the three things in `transactions_repository.dart`
 * that between them decided when the Flutter app's screens were allowed to be
 * correct. TanStack Query already does caching, deduplication, and lifecycle;
 * the database already does querying.
 */

export interface LiveQueryOptions {
  /**
   * Called with what each commit invalidated.
   *
   * For the debug screen, and for the test that asserts a sync write
   * invalidates exactly the affected keys and no others.
   */
  onInvalidate?: (reads: readonly ReadName[], tables: readonly string[]) => void;
}

/**
 * Invalidates the affected queries after every committed write.
 *
 * Returns the function that stops listening. One subscriber for the whole app:
 * the mapping is a pure function of the tables that changed, so there is
 * nothing per-screen to register and nothing to forget to unregister.
 *
 * Invalidation is by read name, not by budget. The notification is
 * table-level — the adapter knows which tables a transaction wrote to, not
 * which budgets' rows were in them — so a sync of one budget invalidates the
 * cached reads of another. The cost is a refetch the next time that budget is
 * looked at, which is the right side to err on.
 */
export function subscribeToDatabaseChanges(
  db: DatabaseAdapter,
  queryClient: QueryClient,
  options: LiveQueryOptions = {},
): () => void {
  return db.onTablesChanged((tables) => {
    const reads = readsAffectedBy(tables);
    if (reads.length === 0) return;

    for (const read of reads) {
      void queryClient.invalidateQueries({ queryKey: [read] });
    }

    options.onInvalidate?.(reads, tables);
  });
}
