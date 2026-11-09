import type { BudgetSummary } from '@lumy/data';
import { describe, expect, it } from 'vitest';

import { budgetPickerState, type FetchStatus, type PickerInput } from './pickerState';

/**
 * The picker reconciles a table that answers instantly with a fetch that
 * fills it, and the mistake worth testing for is confusing "nothing stored
 * yet" with "this account has no budgets".
 */

const HOUSEHOLD: BudgetSummary = {
  id: 'budget-1',
  name: 'Household',
  isoCode: 'USD',
  lastModifiedOn: '2026-10-29T00:00:00Z',
};

const FETCHES: FetchStatus[] = ['idle', 'pending', 'error', 'success'];

function state(input: Partial<PickerInput> = {}) {
  return budgetPickerState({ stored: [], fetch: 'idle', error: null, ...input });
}

describe('the budget picker', () => {
  it('waits while the stored list has not been read', () => {
    // Whatever the fetch is doing. An unread table is not an empty one, and
    // reading it as empty would make the first frame of every visit the
    // empty state.
    for (const fetch of FETCHES) {
      expect(state({ stored: undefined, fetch }), fetch).toEqual({ kind: 'loading' });
    }
  });

  it('waits while nothing is stored and the fetch has not come back', () => {
    expect(state({ fetch: 'idle' })).toEqual({ kind: 'loading' });
    expect(state({ fetch: 'pending' })).toEqual({ kind: 'loading' });
  });

  it('says the account has no budgets only once the fetch agrees', () => {
    // A successful fetch that wrote nothing is the only evidence for this.
    // Saying it any earlier tells someone to create a budget they have.
    expect(state({ fetch: 'success' })).toEqual({ kind: 'empty' });
  });

  it('has nothing to offer when nothing is stored and the fetch failed', () => {
    const error = new Error('no network');

    expect(state({ fetch: 'error', error })).toEqual({ kind: 'failed', error });
  });

  it('shows what is stored whatever the fetch is doing', () => {
    for (const fetch of FETCHES) {
      const result = state({ stored: [HOUSEHOLD], fetch });

      expect(result.kind, fetch).toBe('list');
    }
  });

  it('shows a stored list beside a failed refresh rather than instead of it', () => {
    const error = new Error('no network');

    // A stored list is still a list someone can choose from. Replacing it with
    // an error would make a flaky network the reason they cannot get in.
    expect(state({ stored: [HOUSEHOLD], fetch: 'error', error })).toEqual({
      kind: 'list',
      budgets: [HOUSEHOLD],
      isRefreshing: false,
      refreshError: error,
    });
  });

  it('marks a refresh over a list that is already on screen', () => {
    expect(state({ stored: [HOUSEHOLD], fetch: 'pending' })).toEqual({
      kind: 'list',
      budgets: [HOUSEHOLD],
      isRefreshing: true,
      refreshError: null,
    });
  });

  it('passes the stored order through rather than reordering it', () => {
    // The ordering is `ORDER BY last_modified_on` in `packages/data`, so a
    // sort here would be a second opinion about it.
    const other: BudgetSummary = { ...HOUSEHOLD, id: 'budget-2', name: 'Aardvark' };
    const result = state({ stored: [HOUSEHOLD, other], fetch: 'success' });

    expect(result.kind === 'list' && result.budgets).toEqual([HOUSEHOLD, other]);
  });
});
