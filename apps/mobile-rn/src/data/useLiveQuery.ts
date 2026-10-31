import type { DatabaseAdapter, ReadName } from '@lumy/data';
import { useQuery, type UseQueryResult } from '@tanstack/react-query';

import { useDatabase } from './DatabaseProvider';
import { queryKey } from './queryKeys';

/**
 * Reads from the database, and re-reads when a write makes the answer stale.
 *
 * Thin on purpose. It builds the key, hands the open database to the read, and
 * returns what TanStack Query returns — the invalidation is not here, it is the
 * one subscriber in `liveQueries.ts`. "Live" is a property of the key, not of
 * the hook: anything cached under this read's name re-runs when the tables it
 * depends on are written to, whether or not a component is using this hook at
 * the time.
 *
 * A domain's `queries.ts` wraps this once per screen and passes a read from
 * `packages/data` unchanged. If a wrapper has to reshape the result, the
 * reshaping belongs in `packages/data` instead — a hook returns exactly what
 * its screen renders.
 */
export function useLiveQuery<T>(
  read: ReadName,
  budgetId: string,
  params: readonly unknown[],
  query: (db: DatabaseAdapter) => Promise<T>,
): UseQueryResult<T, Error> {
  const { adapter } = useDatabase();

  return useQuery({
    queryKey: queryKey(read, budgetId, ...params),
    queryFn: () => query(adapter),
  });
}
