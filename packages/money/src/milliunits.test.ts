import { describe, expect, it } from 'vitest';

import { JPY, KWD, USD } from './fixtures';
import {
  abs,
  add,
  fromMinorUnits,
  isInflow,
  isOutflow,
  isZero,
  milliunits,
  negate,
  percentOf,
  scale,
  subtract,
  sum,
  toMinorUnits,
  ZERO,
} from './milliunits';

describe('milliunits', () => {
  it('accepts a whole number', () => {
    expect(milliunits(1000)).toBe(1000);
    expect(milliunits(-1)).toBe(-1);
    expect(ZERO).toBe(0);
  });

  it('rejects a fraction rather than rounding it', () => {
    // A fractional milliunit means money arithmetic already went through a
    // float somewhere upstream, which is the actual bug.
    expect(() => milliunits(10.5)).toThrow(TypeError);
  });

  it('rejects a value past exact integer arithmetic', () => {
    expect(() => milliunits(Number.MAX_SAFE_INTEGER + 2)).toThrow(RangeError);
  });
});

describe('minor units', () => {
  it('converts for a two-place currency', () => {
    expect(toMinorUnits(milliunits(12_340), USD)).toBe(1234);
    expect(fromMinorUnits(1234, USD)).toBe(12_340);
  });

  it('converts for a currency with no fractional part', () => {
    expect(toMinorUnits(milliunits(1000), JPY)).toBe(1);
    expect(fromMinorUnits(1, JPY)).toBe(1000);
  });

  it('converts for a currency as fine as milliunits', () => {
    expect(toMinorUnits(milliunits(1234), KWD)).toBe(1234);
    expect(fromMinorUnits(1234, KWD)).toBe(1234);
  });

  it('truncates toward zero on both sides of it', () => {
    // A tenth of a cent cannot be shown, and truncating asymmetrically would
    // make an amount and its negation differ in magnitude.
    expect(toMinorUnits(milliunits(1239), USD)).toBe(123);
    expect(toMinorUnits(milliunits(-1239), USD)).toBe(-123);
  });

  it('keeps the sign', () => {
    expect(toMinorUnits(milliunits(-12_340), USD)).toBe(-1234);
  });
});

describe('arithmetic', () => {
  it('adds and subtracts exactly', () => {
    expect(add(milliunits(10), milliunits(20))).toBe(30);
    expect(subtract(milliunits(10), milliunits(25))).toBe(-15);
  });

  it('negates and takes magnitude', () => {
    expect(negate(milliunits(-500))).toBe(500);
    expect(abs(milliunits(-500))).toBe(500);
  });

  it('sums an empty set to zero', () => {
    expect(sum([])).toBe(0);
  });

  it('sums without drift', () => {
    // A tenth of a unit a thousand times is exactly a hundred units here, and
    // is not in floating point.
    const amounts = Array.from({ length: 1000 }, () => milliunits(100));

    expect(sum(amounts)).toBe(100_000);
  });

  it('classifies direction', () => {
    expect(isInflow(milliunits(1))).toBe(true);
    expect(isOutflow(milliunits(-1))).toBe(true);
    expect(isZero(ZERO)).toBe(true);
    expect(isInflow(ZERO)).toBe(false);
    expect(isOutflow(ZERO)).toBe(false);
  });
});

describe('scale', () => {
  it('takes a share of an amount', () => {
    expect(scale(milliunits(1000), 1, 4)).toBe(250);
  });

  it('rounds half away from zero, symmetrically', () => {
    expect(scale(milliunits(5), 1, 2)).toBe(3);
    expect(scale(milliunits(-5), 1, 2)).toBe(-3);
  });

  it('projects past the original amount', () => {
    // Nine days into a thirty-day month, a projection scales up.
    expect(scale(milliunits(90_000), 30, 9)).toBe(300_000);
  });

  it('refuses a zero denominator', () => {
    expect(() => scale(milliunits(100), 1, 0)).toThrow(RangeError);
  });
});

describe('percentOf', () => {
  it('compares magnitudes, not signs', () => {
    // Spending is negative and a target is positive; the ratio is about size.
    expect(percentOf(milliunits(-50_000), milliunits(200_000))).toBe(25);
  });

  it('reports zero against nothing rather than dividing by it', () => {
    expect(percentOf(milliunits(100), ZERO)).toBe(0);
  });

  it('can exceed a hundred', () => {
    expect(percentOf(milliunits(300), milliunits(200))).toBe(150);
  });
});
