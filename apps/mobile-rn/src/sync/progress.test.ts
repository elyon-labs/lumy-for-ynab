import { SYNC_ORDER, type SyncProgress } from '@lumy/data';
import { describe, expect, it } from 'vitest';

import {
  advanceSyncProgress,
  completeSyncProgress,
  failSyncProgress,
  IDLE_SYNC_PROGRESS,
  startSyncProgress,
  type SyncProgressState,
} from './progress';

/**
 * The first-run sync screen's model.
 *
 * Folding the engine's events rather than reading its last one, because the
 * properties that matter are about sequences: the bar never goes backwards,
 * and it never claims a number it cannot know.
 */

function event(progress: Partial<SyncProgress>): SyncProgress {
  return { resource: 'accounts', phase: 'writing', written: 0, total: 0, ...progress };
}

/** Folds a run's events in, from a fresh start. */
function fold(events: readonly SyncProgress[]): SyncProgressState {
  return events.reduce(advanceSyncProgress, startSyncProgress());
}

describe('sync progress', () => {
  it('starts with nothing to say', () => {
    expect(IDLE_SYNC_PROGRESS).toEqual({
      status: 'idle',
      resource: null,
      fraction: null,
      written: 0,
      total: null,
      error: null,
    });

    expect(startSyncProgress().status).toBe('running');
  });

  it('cannot say how far along a fetch is', () => {
    const state = fold([event({ resource: 'accounts', phase: 'fetching', total: null })]);

    // The engine has asked YNAB for a page and does not know what it carries,
    // so there is no fraction to report. Zero would be a number that is not
    // true, and the bar sweeps instead.
    expect(state.fraction).toBeNull();
    expect(state.resource).toBe('accounts');
  });

  it('reports a resource as its own share of the whole', () => {
    const share = 1 / SYNC_ORDER.length;

    const half = fold([event({ resource: 'accounts', written: 5, total: 10 })]);
    expect(half.fraction).toBeCloseTo(share / 2);

    const whole = fold([event({ resource: 'accounts', phase: 'done', written: 10, total: 10 })]);
    expect(whole.fraction).toBeCloseTo(share);
  });

  it('places a later resource after the ones before it', () => {
    const share = 1 / SYNC_ORDER.length;
    const index = SYNC_ORDER.indexOf('transactions');

    const state = fold([event({ resource: 'transactions', written: 50, total: 100 })]);

    expect(state.fraction).toBeCloseTo(index * share + share / 2);
  });

  it('holds its place through a fetch rather than jumping back', () => {
    const events = [
      event({ resource: 'accounts', phase: 'done', written: 10, total: 10 }),
      event({ resource: 'payees', phase: 'fetching', total: null }),
    ];

    // The property that matters: an unknowable fraction keeps the last one,
    // because resetting to the start of the new resource would walk the bar
    // backwards at every resource boundary.
    expect(fold(events).fraction).toBeCloseTo(1 / SYNC_ORDER.length);
  });

  it('never goes backwards across a whole run', () => {
    const events: SyncProgress[] = SYNC_ORDER.flatMap((resource) => [
      event({ resource, phase: 'fetching', total: null }),
      event({ resource, phase: 'writing', written: 0, total: 200 }),
      event({ resource, phase: 'writing', written: 100, total: 200 }),
      event({ resource, phase: 'writing', written: 200, total: 200 }),
      event({ resource, phase: 'done', written: 200, total: 200 }),
    ]);

    let state = startSyncProgress();
    let previous = 0;
    for (const next of events) {
      state = advanceSyncProgress(state, next);
      if (state.fraction === null) continue;

      expect(state.fraction).toBeGreaterThanOrEqual(previous);
      previous = state.fraction;
    }

    expect(previous).toBeCloseTo(1);
  });

  it('survives a page that carried nothing', () => {
    // An empty delta page commits — it carries the knowledge saying the client
    // is current — and dividing by its zero total would be NaN.
    const state = fold([event({ resource: 'payees', written: 0, total: 0 })]);

    expect(state.fraction).toBeCloseTo(SYNC_ORDER.indexOf('payees') / SYNC_ORDER.length);
    expect(Number.isNaN(state.fraction)).toBe(false);
  });

  it('does not let a written count past the total overshoot its share', () => {
    const state = fold([event({ resource: 'accounts', written: 20, total: 10 })]);

    expect(state.fraction).toBeCloseTo(1 / SYNC_ORDER.length);
  });

  it('stays running until the call that produced the events returns', () => {
    const last = fold([
      event({ resource: 'scheduled_transactions', phase: 'done', written: 1, total: 1 }),
    ]);

    // The final commit is announced before `syncBudget` resolves, so treating
    // the last event as the end would show a finished sync while the engine
    // was still working.
    expect(last.status).toBe('running');
    expect(completeSyncProgress(last)).toMatchObject({ status: 'done', fraction: 1 });
  });

  it('fills the bar on completion whatever the last event said', () => {
    const partial = fold([event({ resource: 'accounts', written: 1, total: 10 })]);

    expect(completeSyncProgress(partial).fraction).toBe(1);
  });

  it('keeps how far it got when it fails', () => {
    const partial = fold([event({ resource: 'payees', written: 5, total: 10 })]);
    const failed = failSyncProgress(partial, new Error('no network'));

    // The committed pages were not rolled back, so resetting the bar would
    // say something untrue about what is on the device.
    expect(failed.status).toBe('failed');
    expect(failed.fraction).toBe(partial.fraction);
    expect(failed.error?.message).toBe('no network');
  });
});
