import { describe, expect, it } from 'vitest';

import { describeLastFetch, isStale, STALE_AFTER_MS } from './lastFetch';

/**
 * What the last-fetch display says, and when a sync is worth making unasked.
 *
 * Both take the moment as an argument, so neither reads a clock and every band
 * is assertable against a stated instant.
 */

const NOW = new Date('2026-11-08T12:00:00.000Z');

/** An instant the given number of milliseconds before `NOW`. */
function ago(ms: number): string {
  return new Date(NOW.getTime() - ms).toISOString();
}

const MINUTE = 60_000;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;

describe('describing the last fetch', () => {
  it('says never for a budget nothing has been fetched for', () => {
    expect(describeLastFetch(null, NOW)).toEqual({ kind: 'never' });
  });

  it('says just now for anything inside the last minute', () => {
    // Pull-to-refresh is how this value usually changes, so the common case is
    // someone reading it seconds later. "0 minutes ago" is worse and "1 minute
    // ago" is not true.
    expect(describeLastFetch(ago(0), NOW)).toEqual({ kind: 'justNow' });
    expect(describeLastFetch(ago(MINUTE - 1), NOW)).toEqual({ kind: 'justNow' });
  });

  it('counts whole minutes up to an hour', () => {
    expect(describeLastFetch(ago(MINUTE), NOW)).toEqual({ kind: 'minutes', value: 1 });
    expect(describeLastFetch(ago(59 * MINUTE), NOW)).toEqual({ kind: 'minutes', value: 59 });
  });

  it('counts whole hours up to a day', () => {
    expect(describeLastFetch(ago(HOUR), NOW)).toEqual({ kind: 'hours', value: 1 });
    expect(describeLastFetch(ago(23 * HOUR + 59 * MINUTE), NOW)).toEqual({
      kind: 'hours',
      value: 23,
    });
  });

  it('counts whole days beyond that', () => {
    expect(describeLastFetch(ago(DAY), NOW)).toEqual({ kind: 'days', value: 1 });
    expect(describeLastFetch(ago(400 * DAY), NOW)).toEqual({ kind: 'days', value: 400 });
  });

  it('declines to say for a stored value that is not a time', () => {
    // The row is written by one build of the app and read by another, and a
    // value that has stopped meaning anything should not be arithmetic.
    expect(describeLastFetch('not a date', NOW)).toEqual({ kind: 'unknown' });
    expect(describeLastFetch('', NOW)).toEqual({ kind: 'unknown' });
  });

  it('declines to say for a fetch in the future', () => {
    // A clock that moved backwards, or a row from a device whose clock is
    // ahead. Counting down to it would be worse than saying nothing.
    expect(describeLastFetch(ago(-HOUR), NOW)).toEqual({ kind: 'unknown' });
  });

  it('tolerates a clock a few seconds out rather than calling it unknown', () => {
    // Device clocks drift, and a sync that happened a moment ago reading as
    // unknown would be the common case rather than the odd one.
    expect(describeLastFetch(ago(-30_000), NOW)).toEqual({ kind: 'justNow' });
  });
});

describe('whether the data is stale', () => {
  it('is fifteen minutes, which is what the Flutter app refreshed after', () => {
    expect(STALE_AFTER_MS).toBe(15 * MINUTE);
  });

  it('is false for a recent fetch', () => {
    expect(isStale(ago(14 * MINUTE), NOW)).toBe(false);
  });

  it('is true once the window has passed', () => {
    expect(isStale(ago(STALE_AFTER_MS), NOW)).toBe(true);
    expect(isStale(ago(DAY), NOW)).toBe(true);
  });

  it('is true for a budget nothing has been fetched for', () => {
    expect(isStale(null, NOW)).toBe(true);
  });

  it('is true for anything it cannot read as a time', () => {
    // Anything not demonstrably recent is stale: the cost of being wrong is
    // one request, and the cost of the other mistake is a stale number.
    expect(isStale('not a date', NOW)).toBe(true);
    expect(isStale(ago(-HOUR), NOW)).toBe(true);
  });
});
