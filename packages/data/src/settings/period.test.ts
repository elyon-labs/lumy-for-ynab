import { describe, expect, it } from 'vitest';

import {
  addMonths,
  constrainCustomRange,
  firstDayOfMonth,
  lastDayOfMonth,
  resolvePeriod,
  type Period,
} from './period';

/**
 * A period resolves against a day the caller names, so every case here is a
 * statement about a date rather than about whenever the suite happened to run.
 * The Flutter app recomputed the same answers once a minute from a clock it
 * read itself, which is why none of this was assertable there.
 */

const MID_MONTH = '2026-10-14';

describe('resolving a period', () => {
  it.each<[Period['type'], Period, string, string]>([
    ['thisMonth', { type: 'thisMonth' }, '2026-10-01', '2026-10-14'],
    ['lastMonth', { type: 'lastMonth' }, '2026-09-01', '2026-09-30'],
    ['last3Months', { type: 'last3Months' }, '2026-08-01', '2026-10-14'],
    ['last6Months', { type: 'last6Months' }, '2026-05-01', '2026-10-14'],
    ['last12Months', { type: 'last12Months' }, '2025-11-01', '2026-10-14'],
    ['thisYear', { type: 'thisYear' }, '2026-01-01', '2026-10-14'],
    ['lastYear', { type: 'lastYear' }, '2025-01-01', '2025-12-31'],
  ])('%s covers the dates it names', (_type, period, from, to) => {
    expect(resolvePeriod(period, MID_MONTH)).toEqual({ from, to });
  });

  it('counts the current month as one of the latest three', () => {
    // Three months back from the first of this month is two, not three: the
    // month in progress is one of them.
    const { from } = resolvePeriod({ type: 'last3Months' }, '2026-01-14');

    expect(from).toBe('2025-11-01');
  });

  it('ends a period that is still running today, not at the end of the month', () => {
    // A range that ran to 2026-10-31 would read October as finished and every
    // per-day figure over it — the days buffer especially — as too small.
    expect(resolvePeriod({ type: 'thisMonth' }, MID_MONTH).to).toBe(MID_MONTH);
  });

  it('ends February on the 28th, or the 29th in a leap year', () => {
    expect(resolvePeriod({ type: 'lastMonth' }, '2026-03-09').to).toBe('2026-02-28');
    expect(resolvePeriod({ type: 'lastMonth' }, '2024-03-09').to).toBe('2024-02-29');
  });
});

describe('a custom period', () => {
  it('runs from the first of its first month to the last of its last', () => {
    const period: Period = { type: 'custom', from: '2026-03-17', to: '2026-05-02' };

    expect(resolvePeriod(period, MID_MONTH)).toEqual({ from: '2026-03-01', to: '2026-05-31' });
  });

  it('stops at today when it reaches into the month in progress', () => {
    const period: Period = { type: 'custom', from: '2026-09-01', to: '2026-10-01' };

    expect(resolvePeriod(period, MID_MONTH)).toEqual({ from: '2026-09-01', to: MID_MONTH });
  });

  it('keeps a month that has finished whole', () => {
    expect(constrainCustomRange({ from: '2026-09-01', to: '2026-09-01' }, MID_MONTH)).toEqual({
      from: '2026-09-01',
      to: '2026-09-30',
    });
  });

  it('leaves a range that ends in the future of another month alone', () => {
    // Only the month in progress is clamped; a range chosen ahead of today is
    // the person's choice and resolves to what they chose.
    expect(constrainCustomRange({ from: '2026-11-01', to: '2026-11-01' }, MID_MONTH)).toEqual({
      from: '2026-11-01',
      to: '2026-11-30',
    });
  });
});

describe('the date arithmetic', () => {
  it('crosses a year boundary in both directions', () => {
    expect(addMonths('2026-01-01', -1)).toBe('2025-12-01');
    expect(addMonths('2026-12-01', 1)).toBe('2027-01-01');
    expect(addMonths('2026-01-01', -13)).toBe('2024-12-01');
  });

  it('keeps a day that the target month is too short for inside it', () => {
    expect(addMonths('2026-01-31', 1)).toBe('2026-02-28');
  });

  it('reads the ends of a month', () => {
    expect(firstDayOfMonth('2026-10-14')).toBe('2026-10-01');
    expect(lastDayOfMonth('2026-11-14')).toBe('2026-11-30');
  });

  it('refuses a date it cannot read', () => {
    expect(() => firstDayOfMonth('14/10/2026')).toThrow(/YYYY-MM-DD/);
  });
});
