import type { Budget } from '@lumy/ynab';
import { useQuery, type UseQueryResult } from '@tanstack/react-query';

import { useYnabAuth } from '@/auth';

/**
 * The budgets on the connected YNAB account.
 *
 * Deliberately outside the `queryKey` scheme in `@/data`, which is for
 * database reads and leads with a `ReadName` so a commit can invalidate by
 * prefix. This is a network read of something no local table holds yet: a
 * budget has to be chosen before anything can be synced for it, so the picker
 * cannot read the `budgets` table it is the precondition for.
 */
export const BUDGETS_QUERY_KEY = ['ynab', 'budgets'] as const;

export function useBudgets(): UseQueryResult<Budget[], Error> {
  const { client } = useYnabAuth();

  return useQuery({
    queryKey: BUDGETS_QUERY_KEY,
    queryFn: () => {
      // The picker is only reached once the chain has seen a connected token,
      // so this is the same kind of guard as `useBudgetId`'s.
      if (client === null) throw new Error('YNAB is not connected.');

      return client.getBudgets();
    },
    enabled: client !== null,
  });
}

/**
 * Most recently used first.
 *
 * Someone with several budgets almost always wants the one they were last in,
 * and `last_modified_on` is the only ordering YNAB gives that reflects that.
 * It has been seen absent, which sorts to the end rather than to the top.
 */
export function byMostRecentlyUsed(budgets: readonly Budget[]): Budget[] {
  // An absent timestamp compares as the empty string, which sorts to the end
  // of a descending comparison rather than the top.
  const usedAt = (budget: Budget): string => budget.lastModifiedOn ?? '';

  return [...budgets].sort((a, b) => usedAt(b).localeCompare(usedAt(a)));
}
