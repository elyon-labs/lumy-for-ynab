import { SYNC_ORDER, type SyncProgress, type SyncResource } from '@lumy/data';

/**
 * What the first-run sync screen renders, from the events the engine emits.
 *
 * `onProgress` is on `SyncEngineOptions` rather than on `syncBudget`, so it is
 * per engine and not per call: the provider that owns the engine fans the
 * events out, and this is the fold that turns a stream of them into a frame.
 *
 * It lives apart from the screen because `apps/mobile-rn` has no renderer and
 * its vitest config collects only `src/**\/*.test.ts` — a progress model
 * inside a component is a model nothing can assert on. The component reads
 * these fields and nothing else.
 */

export type SyncRunStatus = 'idle' | 'running' | 'done' | 'failed';

export interface SyncProgressState {
  status: SyncRunStatus;
  /** The resource being fetched or written, or null before the first event. */
  resource: SyncResource | null;
  /**
   * How far through the whole sync, from 0 to 1, or null while that cannot be
   * said.
   *
   * Null is the honest answer during a fetch: the engine has asked YNAB for a
   * page and does not yet know how many entities it carries, so the fraction
   * within the current resource is unknown. The bar sweeps rather than sitting
   * at a number that is not true.
   */
  fraction: number | null;
  /** Entities committed for the current resource, and how many it carried. */
  written: number;
  total: number | null;
  /** What went wrong, for a run that failed. */
  error: Error | null;
}

export const IDLE_SYNC_PROGRESS: SyncProgressState = {
  status: 'idle',
  resource: null,
  fraction: null,
  written: 0,
  total: null,
  error: null,
};

/**
 * Each resource is an equal share of the whole.
 *
 * Not weighted by entity count, because the only honest weighting would need
 * the counts before any of them has been fetched. Equal shares mean the bar
 * moves at an uneven rate but never backwards, and never has to be told that
 * the step it just completed was bigger than it claimed.
 */
function shareOf(resource: SyncResource): { start: number; size: number } {
  const index = SYNC_ORDER.indexOf(resource);
  const size = 1 / SYNC_ORDER.length;

  return { start: index * size, size };
}

/** The fraction a single event puts the whole sync at. */
function fractionFor(event: SyncProgress): number | null {
  const { start, size } = shareOf(event.resource);

  switch (event.phase) {
    // Asked, not yet answered: how far through this resource is unknowable, so
    // the whole is too.
    case 'fetching':
      return null;

    case 'writing': {
      // A page that carried nothing is written the instant it commits, and
      // dividing by its zero total would be NaN.
      if (event.total === null || event.total === 0) return start;

      return start + (Math.min(event.written, event.total) / event.total) * size;
    }

    case 'done':
      return start + size;
  }
}

/** The state a run is in before its first event. */
export function startSyncProgress(): SyncProgressState {
  return { ...IDLE_SYNC_PROGRESS, status: 'running' };
}

/**
 * Folds one event in.
 *
 * Events only ever arrive while a run is in flight, so a `done` on the last
 * resource is still `running`: what finishes a run is `syncBudget` returning,
 * not the last event. The two are different moments — the final commit is
 * announced before the call resolves — and treating the event as the end would
 * show someone a finished sync while the engine was still working.
 */
export function advanceSyncProgress(
  state: SyncProgressState,
  event: SyncProgress,
): SyncProgressState {
  const fraction = fractionFor(event);

  return {
    status: 'running',
    resource: event.resource,
    // A null fraction keeps the last one it had rather than resetting the bar
    // to the start of the resource: a fetch that follows a completed resource
    // would otherwise jump backwards every time.
    fraction: fraction ?? state.fraction,
    written: event.written,
    total: event.total,
    error: null,
  };
}

/** A run that returned. The bar is full whatever the last event said. */
export function completeSyncProgress(state: SyncProgressState): SyncProgressState {
  return { ...state, status: 'done', fraction: 1, error: null };
}

/**
 * A run that threw.
 *
 * The fraction is kept, because how far it got is the useful part of a failure
 * — and resetting it would suggest the committed pages were rolled back, which
 * they were not.
 */
export function failSyncProgress(state: SyncProgressState, error: Error): SyncProgressState {
  return { ...state, status: 'failed', error };
}
