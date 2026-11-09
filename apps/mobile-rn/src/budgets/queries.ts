import { listBudgets, type BudgetSummary, type DatabaseAdapter } from '@lumy/data';
import { useMutation, type UseMutationResult, type UseQueryResult } from '@tanstack/react-query';

import { useLiveQuery } from '@/data';
import { useSync } from '@/sync';

/**
 * The budgets this client knows about, and refreshing them.
 *
 * Two parts, deliberately: the list is read from the `budgets` table and the
 * refresh goes through the sync engine's `syncBudgetList`, which fetches the
 * list whole — YNAB offers no delta for it — and writes both `budgets` and
 * `currency_formats` before returning.
 *
 * It used to call `client.getBudgets()` and persist nothing, which meant the
 * picker fetched the same list the first sync would fetch again moments later,
 * and could not render at all without a network. Going through the engine
 * makes the write the point: the refresh fills the table, the table change
 * invalidates this read, and the list follows. The engine is also the only
 * thing in the app allowed to write YNAB data, so the alternative was a second
 * writer of two tables.
 */

/** Everything the picker renders, already ordered most recently used first. */
export function useBudgets(): UseQueryResult<BudgetSummary[], Error> {
  // Not budget-scoped: this is the read someone makes in order to have a
  // budget, so there is nothing to put in that position.
  return useLiveQuery('listBudgets', '', [], (db: DatabaseAdapter) => listBudgets(db));
}

/**
 * Fetches the budget list from YNAB and stores it.
 *
 * A mutation rather than a query, because what it is for is the write. What it
 * returns is read from the table by `useBudgets`, which re-runs on its own
 * when the write lands.
 */
export function useRefreshBudgets(): UseMutationResult<void, Error, void> {
  const { engine } = useSync();

  return useMutation({
    mutationFn: async () => {
      // The picker is only reached once the chain has seen a connected token,
      // so this is the same kind of guard as `useBudgetId`'s.
      if (engine === null) throw new Error('YNAB is not connected.');

      await engine.syncBudgetList();
    },
  });
}
