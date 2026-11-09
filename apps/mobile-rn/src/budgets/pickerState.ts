import type { BudgetSummary } from '@lumy/data';

/**
 * What the budget picker shows, given what is stored and how the fetch went.
 *
 * Two sources with to be reconciled: the `budgets` table, which answers
 * instantly and may be empty because nothing has fetched yet, and the fetch
 * that fills it. An empty table is not the same claim as "this YNAB account
 * has no budgets", and showing the second when the first is true is how
 * someone gets told to go and create a budget they already have.
 *
 * Pure, because that reconciliation is the whole of the screen's logic and
 * `apps/mobile-rn` has no renderer to assert a component's output with.
 */

/** How the fetch that fills the table is getting on. */
export type FetchStatus = 'idle' | 'pending' | 'error' | 'success';

export interface PickerInput {
  /**
   * The stored list: `undefined` until the read lands, `[]` once it has and
   * there is nothing there.
   *
   * The distinction `selectedBudgetId` and the sync gate both need. Without
   * it, the first frame of every visit would be the empty state.
   */
  stored: readonly BudgetSummary[] | undefined;
  fetch: FetchStatus;
  /** Why the fetch failed, for a screen with nothing else to show. */
  error: Error | null;
}

export type BudgetPickerState =
  /** Nothing to show yet and reason to think there will be. */
  | { kind: 'loading' }
  /** The account has no budgets in it. Said only when the fetch agrees. */
  | { kind: 'empty' }
  /** Nothing stored and the fetch failed, so there is nothing to offer. */
  | { kind: 'failed'; error: Error | null }
  | {
      kind: 'list';
      budgets: readonly BudgetSummary[];
      /** A refresh in flight over a list that is already on screen. */
      isRefreshing: boolean;
      /**
       * A refresh that failed over a list that is already on screen.
       *
       * Shown beside the list rather than instead of it: a stored list is
       * still a list someone can choose from, and replacing it with an error
       * would make a flaky network the reason they cannot get into the app.
       */
      refreshError: Error | null;
    };

export function budgetPickerState({ stored, fetch, error }: PickerInput): BudgetPickerState {
  // The read has not landed. Whatever the fetch is doing, there is nothing to
  // say about the list yet.
  if (stored === undefined) return { kind: 'loading' };

  if (stored.length > 0) {
    return {
      kind: 'list',
      budgets: stored,
      isRefreshing: fetch === 'pending',
      refreshError: fetch === 'error' ? error : null,
    };
  }

  switch (fetch) {
    // Nothing stored and nothing has come back yet. An empty table before the
    // first fetch says nothing about the account.
    case 'idle':
    case 'pending':
      return { kind: 'loading' };

    case 'error':
      return { kind: 'failed', error };

    // The fetch succeeded and wrote nothing, which is the only evidence that
    // the account really has no budgets in it.
    case 'success':
      return { kind: 'empty' };
  }
}
