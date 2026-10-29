import { toMinorUnits } from './milliunits';
import type { CurrencyFormat, Milliunits } from './types';

export interface FormatOptions {
  /**
   * `auto` shows a minus on outflow only, which is how a ledger reads.
   * `always` adds a plus to inflow, for a figure whose direction is the point.
   * `never` drops the sign, for a magnitude that is labelled some other way.
   */
  signDisplay?: 'auto' | 'always' | 'never';
  /** Drops the fractional part, for a figure that is about scale not cents. */
  hideDecimals?: boolean;
}

function groupDigits(digits: string, separator: string): string {
  if (separator === '') return digits;

  let grouped = '';
  for (let index = 0; index < digits.length; index += 1) {
    // Count from the right, so the first group is the short one.
    const fromRight = digits.length - index;
    if (index > 0 && fromRight % 3 === 0) {
      grouped += separator;
    }
    grouped += digits[index];
  }

  return grouped;
}

function signPrefix(amount: number, signDisplay: Required<FormatOptions>['signDisplay']): string {
  if (signDisplay === 'never') return '';
  if (amount < 0) return '-';
  if (signDisplay === 'always' && amount > 0) return '+';

  return '';
}

function withSymbol(body: string, format: CurrencyFormat): string {
  if (!format.displaySymbol || format.currencySymbol === '') return body;

  return format.symbolFirst ? `${format.currencySymbol}${body}` : `${body}${format.currencySymbol}`;
}

/**
 * Writes an amount the way the budget's own currency is written.
 *
 * The sign leads the symbol — `-$12.34`, never `$-12.34` — because the minus
 * applies to the amount rather than to the currency.
 */
export function formatMilliunits(
  amount: Milliunits,
  format: CurrencyFormat,
  options: FormatOptions = {},
): string {
  const { signDisplay = 'auto', hideDecimals = false } = options;
  const decimalDigits = hideDecimals ? 0 : format.decimalDigits;

  const minor = Math.abs(toMinorUnits(amount, { ...format, decimalDigits }));
  const asDigits = String(minor).padStart(decimalDigits + 1, '0');

  const whole = asDigits.slice(0, asDigits.length - decimalDigits);
  const fraction = asDigits.slice(asDigits.length - decimalDigits);

  const body =
    decimalDigits > 0
      ? `${groupDigits(whole, format.groupSeparator)}${format.decimalSeparator}${fraction}`
      : groupDigits(whole, format.groupSeparator);

  return `${signPrefix(amount, signDisplay)}${withSymbol(body, format)}`;
}

/** The scale a compact figure is written at, and what it is called. */
const MAGNITUDES = [
  { suffix: 'B', unitsPerStep: 1_000_000_000 },
  { suffix: 'M', unitsPerStep: 1_000_000 },
  { suffix: 'K', unitsPerStep: 1_000 },
] as const;

export interface CompactOptions {
  /**
   * The step between the surrounding labels, as an amount.
   *
   * It decides precision: an axis stepping by whole millions needs no decimals,
   * while one stepping by tens of thousands needs them or every label reads the
   * same.
   */
  interval?: Milliunits;
  signDisplay?: FormatOptions['signDisplay'];
}

/**
 * Writes an amount short enough for a chart axis or a stat tile.
 *
 * Everything below a thousand units is written out in full, so a small axis
 * does not lose its cents to a suffix it did not need.
 */
export function formatCompact(
  amount: Milliunits,
  format: CurrencyFormat,
  options: CompactOptions = {},
): string {
  const { interval, signDisplay = 'auto' } = options;

  const unitsAbs = Math.abs(amount) / 1000;
  const magnitude = MAGNITUDES.find((candidate) => unitsAbs >= candidate.unitsPerStep);

  if (magnitude === undefined) {
    return formatMilliunits(amount, format, { signDisplay });
  }

  const intervalUnits = interval === undefined ? 0 : Math.abs(interval) / 1000;
  const precision =
    intervalUnits >= magnitude.unitsPerStep ? 0 : intervalUnits >= magnitude.unitsPerStep / 100 ? 1 : 2;

  // Rounded as an integer at the target precision so the printed digits are
  // the rounded ones, rather than a float's nearest representation of them.
  const scaled = Math.round((unitsAbs / magnitude.unitsPerStep) * 10 ** precision);
  const asDigits = String(scaled).padStart(precision + 1, '0');

  const whole = asDigits.slice(0, asDigits.length - precision);
  const fraction = asDigits.slice(asDigits.length - precision);

  const body =
    precision > 0
      ? `${groupDigits(whole, format.groupSeparator)}${format.decimalSeparator}${fraction}${magnitude.suffix}`
      : `${groupDigits(whole, format.groupSeparator)}${magnitude.suffix}`;

  return `${signPrefix(amount, signDisplay)}${withSymbol(body, format)}`;
}
