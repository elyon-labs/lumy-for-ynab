import { describe, expect, it } from 'vitest';

import { millisecondsUntilTomorrow, today } from './today';

/**
 * The one place the app reads a clock for a date. Everything the period model
 * does with the result is pure and tested in `@lumy/data`.
 */

describe('today', () => {
  it('is the local calendar date, not the UTC one', () => {
    // Late evening in a timezone ahead of UTC is already tomorrow there and
    // still today in UTC; reading it off `toISOString` would show the wrong
    // day to half the world for a quarter of each day.
    const localNewYearsEve = new Date(2026, 11, 31, 23, 30);

    expect(today(localNewYearsEve)).toBe('2026-12-31');
  });

  it('pads a single-digit month and day', () => {
    expect(today(new Date(2026, 0, 5, 12))).toBe('2026-01-05');
  });
});

describe('the wait until tomorrow', () => {
  it('is the time left until local midnight', () => {
    const halfPastEleven = new Date(2026, 9, 14, 23, 30, 0, 0);

    expect(millisecondsUntilTomorrow(halfPastEleven)).toBe(30 * 60 * 1000);
  });

  it('is a whole day just after midnight', () => {
    const justAfterMidnight = new Date(2026, 9, 14, 0, 0, 0, 0);
    const oneDay = 24 * 60 * 60 * 1000;

    // Not a DST boundary in any zone this is run in, so the day is 24 hours.
    expect(millisecondsUntilTomorrow(justAfterMidnight)).toBe(oneDay);
  });

  it('reaches the next day when the month ends', () => {
    const lastMinuteOfTheMonth = new Date(2026, 8, 30, 23, 59, 0, 0);

    expect(millisecondsUntilTomorrow(lastMinuteOfTheMonth)).toBe(60 * 1000);
  });
});
