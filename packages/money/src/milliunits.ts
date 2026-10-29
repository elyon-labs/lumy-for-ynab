import type { CurrencyFormat, Milliunits } from './types';

/** YNAB's own scale: one currency unit is this many milliunits. */
const MILLIUNITS_PER_UNIT = 1000;

/** Beyond this, integer arithmetic stops being exact in a double. */
const MAX_SAFE = Number.MAX_SAFE_INTEGER;

export const ZERO = 0 as Milliunits;

function pow10(exponent: number): number {
  return 10 ** exponent;
}

/**
 * Takes a raw integer as an amount.
 *
 * Throws on a non-integer rather than rounding, because a fractional milliunit
 * means the caller already did money arithmetic in floating point and the
 * error is upstream of here.
 */
export function milliunits(value: number): Milliunits {
  if (!Number.isInteger(value)) {
    throw new TypeError(`Milliunits must be a whole number, received ${value}.`);
  }
  if (!Number.isSafeInteger(value)) {
    throw new RangeError(`Milliunits ${value} is beyond exact integer arithmetic.`);
  }

  return value as Milliunits;
}

/**
 * Converts an amount to the currency's own minor units — cents for USD, fils
 * for KWD, whole yen for JPY.
 *
 * Truncates toward zero for currencies coarser than milliunits, which is what
 * YNAB itself does. The sign is preserved; callers that want a magnitude ask
 * for one.
 */
export function toMinorUnits(amount: Milliunits, format: CurrencyFormat): number {
  const { decimalDigits } = format;

  if (decimalDigits <= 3) {
    return Math.trunc(amount / (MILLIUNITS_PER_UNIT / pow10(decimalDigits)));
  }

  return amount * pow10(decimalDigits - 3);
}

/** The inverse of {@link toMinorUnits}. */
export function fromMinorUnits(minor: number, format: CurrencyFormat): Milliunits {
  const { decimalDigits } = format;

  if (decimalDigits <= 3) {
    return milliunits(minor * (MILLIUNITS_PER_UNIT / pow10(decimalDigits)));
  }

  return milliunits(Math.trunc(minor / pow10(decimalDigits - 3)));
}

export function add(a: Milliunits, b: Milliunits): Milliunits {
  return milliunits(a + b);
}

export function subtract(a: Milliunits, b: Milliunits): Milliunits {
  return milliunits(a - b);
}

export function negate(amount: Milliunits): Milliunits {
  return milliunits(-amount);
}

export function abs(amount: Milliunits): Milliunits {
  return milliunits(Math.abs(amount));
}

export function sum(amounts: Iterable<Milliunits>): Milliunits {
  let total = 0;
  for (const amount of amounts) {
    total += amount;
  }

  return milliunits(total);
}

/**
 * Scales an amount by a ratio, as a projection or a share does.
 *
 * Takes the ratio as two integers rather than a fraction, so the only rounding
 * is the one at the end. Rounds half away from zero, which keeps a split of an
 * amount symmetric around it.
 */
export function scale(amount: Milliunits, numerator: number, denominator: number): Milliunits {
  if (denominator === 0) {
    throw new RangeError('Cannot scale an amount by a zero denominator.');
  }

  const scaled = (amount * numerator) / denominator;
  if (Math.abs(scaled) > MAX_SAFE) {
    throw new RangeError(`Scaling overflowed exact integer arithmetic: ${scaled}.`);
  }

  return milliunits(Math.sign(scaled) * Math.round(Math.abs(scaled)));
}

export function isZero(amount: Milliunits): boolean {
  return amount === 0;
}

/** Money in: a YNAB inflow is positive. */
export function isInflow(amount: Milliunits): boolean {
  return amount > 0;
}

/** Money out: a YNAB outflow is negative. */
export function isOutflow(amount: Milliunits): boolean {
  return amount < 0;
}

/**
 * Where `part` falls against `whole`, as a percentage.
 *
 * Returns a float, because a percentage is a ratio for display and not an
 * amount. Magnitudes are compared, so spending 50 of a 200 budget reads as 25
 * whichever sign convention the two carry.
 */
export function percentOf(part: Milliunits, whole: Milliunits): number {
  if (whole === 0) return 0;

  return (Math.abs(part) / Math.abs(whole)) * 100;
}
