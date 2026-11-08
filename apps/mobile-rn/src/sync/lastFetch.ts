/**
 * How long ago Lumy last heard from YNAB.
 *
 * `server_knowledge.synced_at` is an ISO instant, written in the same
 * transaction as the data it describes. What a screen shows is how long ago
 * that was, which is a function of the instant and of now — so it is here,
 * where both are arguments, rather than in a component reading a clock.
 *
 * The result is a descriptor rather than a string. Which words to use is the
 * i18n catalog's decision and the component's to make; what the bands are, and
 * that the stored value is trusted no further than it deserves, is this
 * module's.
 */

export type LastFetchDescription =
  /** Nothing has ever been fetched for this budget. */
  | { kind: 'never' }
  /** Something is stored that is not a time, or is in the future. */
  | { kind: 'unknown' }
  | { kind: 'justNow' }
  | { kind: 'minutes'; value: number }
  | { kind: 'hours'; value: number }
  | { kind: 'days'; value: number };

const MINUTE = 60_000;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;

/**
 * Under a minute reads as just now.
 *
 * Pull-to-refresh is the usual way this value changes, so the common case is
 * someone looking at the screen seconds after a sync. "0 minutes ago" is a
 * worse answer than "just now" and "1 minute ago" is not true.
 */
export function describeLastFetch(syncedAt: string | null, now: Date): LastFetchDescription {
  if (syncedAt === null) return { kind: 'never' };

  const then = Date.parse(syncedAt);
  if (Number.isNaN(then)) return { kind: 'unknown' };

  const elapsed = now.getTime() - then;

  // A fetch in the future means the device's clock moved backwards, or a row
  // written by another device whose clock is ahead. Counting down to it would
  // be worse than declining to say.
  if (elapsed < -MINUTE) return { kind: 'unknown' };

  if (elapsed < MINUTE) return { kind: 'justNow' };
  if (elapsed < HOUR) return { kind: 'minutes', value: Math.floor(elapsed / MINUTE) };
  if (elapsed < DAY) return { kind: 'hours', value: Math.floor(elapsed / HOUR) };

  return { kind: 'days', value: Math.floor(elapsed / DAY) };
}

/**
 * Whether enough time has passed that a sync is worth making on its own.
 *
 * Fifteen minutes, which is what the Flutter app's `shouldRefresh` used before
 * refreshing on resume. It is here rather than beside the resume listener so
 * that the number is stated once and asserted.
 */
export const STALE_AFTER_MS = 15 * MINUTE;

export function isStale(syncedAt: string | null, now: Date): boolean {
  if (syncedAt === null) return true;

  const then = Date.parse(syncedAt);
  if (Number.isNaN(then)) return true;

  // A clock that has moved backwards does not make data fresh. Anything that
  // is not demonstrably recent is treated as stale, because the cost of being
  // wrong is one request.
  return now.getTime() - then >= STALE_AFTER_MS || then > now.getTime();
}
