import {
  hasSyncedData,
  syncStatus,
  type BudgetSyncStatus,
  type DatabaseAdapter,
  type SyncEngine,
} from '@lumy/data';
import { useMutation, type UseMutationResult, type UseQueryResult } from '@tanstack/react-query';
import { useCallback } from 'react';

import { useLiveQuery } from '@/data';
import { useSelectedBudget } from '@/settings';

import { completeSyncProgress, failSyncProgress, startSyncProgress } from './progress';
import { useSetSyncProgress, useSync } from './SyncProvider';

/**
 * The sync domain's hooks.
 *
 * The reads come from `packages/data` unchanged; the writes all go through the
 * one engine the provider holds. None of them invalidates a query key: a sync
 * advances `server_knowledge` and the adapter announces it, so the status, the
 * gate on the first-run screen, and every screen over the ledger re-read on
 * their own. That is the whole reactivity story and there is nothing here
 * outside it.
 */

/** Everything the sync status screen shows. */
export function useSyncStatus(): UseQueryResult<BudgetSyncStatus, Error> {
  const { budgetId } = useSelectedBudget();

  return useLiveQuery('syncStatus', budgetId ?? '', [], (db: DatabaseAdapter) =>
    syncStatus(db, budgetId ?? ''),
  );
}

export interface HasSyncedData {
  /**
   * Whether every resource of the selected budget has been fetched.
   *
   * `undefined` until the first read lands, and that is the whole reason this
   * is not a bare boolean — the same distinction `selectedBudgetId` needs. The
   * answer for an unsynced budget is `false`, which is also what an unread
   * query would default to, so collapsing the two would send someone who has
   * already synced to the first-run screen on every cold start.
   */
  hasSyncedData: boolean | undefined;
}

export function useHasSyncedData(): HasSyncedData {
  const { budgetId } = useSelectedBudget();
  // No budget is `''`, which has nothing synced for it and never will. The
  // redirect chain asks for a budget before it asks this, so the answer in
  // that state is read by nothing — but the hook still has to be called, and a
  // key that cannot collide with a real budget's is what keeps it harmless.
  const scope = budgetId ?? '';

  const query = useLiveQuery('hasSyncedData', scope, [], (db: DatabaseAdapter) =>
    hasSyncedData(db, scope),
  );

  return { hasSyncedData: query.data };
}

/**
 * A mutation that reports its progress on the way through.
 *
 * Every write in this domain is one of these: the work differs, the reporting
 * does not. `run` is handed the budget, so a caller does not restate the "no
 * budget selected" case, and it is skipped entirely when there is no engine —
 * which only happens above the guards, where a tab's refresh gesture is better
 * ignored than thrown out of.
 */
function useReportedRun<TVariables>(
  run: (engine: SyncEngine, budgetId: string, variables: TVariables) => Promise<unknown>,
): UseMutationResult<void, Error, TVariables> {
  const { engine } = useSync();
  const { budgetId } = useSelectedBudget();
  const setProgress = useSetSyncProgress();

  return useMutation({
    mutationFn: async (variables: TVariables) => {
      if (engine === null || budgetId === null) return;

      setProgress(() => startSyncProgress());
      try {
        await run(engine, budgetId, variables);
        setProgress(completeSyncProgress);
      } catch (error) {
        const failure = error instanceof Error ? error : new Error(String(error));
        setProgress((state) => failSyncProgress(state, failure));
        throw failure;
      }
    },
  });
}

/**
 * Syncs the selected budget, reporting progress as it goes.
 *
 * The same mutation behind the first-run screen, pull-to-refresh, and the sync
 * status screen's own button. For a budget that is up to date the delta path
 * is six small requests and six empty pages, each of which still commits — an
 * empty page carries the knowledge that says the client is current.
 */
export function useSyncBudget(): UseMutationResult<void, Error, void> {
  return useReportedRun((engine, budgetId) => engine.syncBudget(budgetId));
}

/**
 * Discards the selected budget's data and downloads it again.
 *
 * PR 10's `repairBudget`, which is the action here. `verifyAgainstSnapshot` is
 * the other half of that PR and is not: it answers whether the client has
 * diverged, which is a question for the debug screen rather than something to
 * offer someone whose numbers look wrong.
 */
export function useRepairBudget(): UseMutationResult<void, Error, void> {
  return useReportedRun((engine, budgetId) => engine.repairBudget(budgetId));
}

/**
 * Deletes every budget's cached YNAB data.
 *
 * Nothing is synced back, so afterwards the redirect chain's fifth condition
 * answers false and the first-run sync screen is where someone lands. That is
 * the intended end of this action: it is how they get Lumy's copy of their
 * budget off the device, not a way to force a refresh.
 */
export function useDeleteAllSyncedData(): UseMutationResult<void, Error, void> {
  const { engine } = useSync();

  return useMutation({
    mutationFn: async () => {
      if (engine === null) return;

      await engine.deleteAllSyncedData();
    },
  });
}

/**
 * Pull-to-refresh, as a tab hands it to `RefreshControl`.
 *
 * `isRefreshing` is the mutation's own pending state rather than a separate
 * flag, so a refresh already under way still shows the spinner when someone
 * pulls.
 */
export interface Refresh {
  isRefreshing: boolean;
  refresh: () => void;
}

export function useRefresh(): Refresh {
  const sync = useSyncBudget();

  return {
    isRefreshing: sync.isPending,
    refresh: useCallback(() => sync.mutate(), [sync]),
  };
}
