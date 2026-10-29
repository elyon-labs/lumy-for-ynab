import { formatMilliunits } from './format';
import { fromMinorUnits, milliunits } from './milliunits';
import type { CurrencyFormat, Milliunits } from './types';

/**
 * How many digits an entry can hold and still convert exactly.
 *
 * The cap depends on the currency, because the conversion to milliunits
 * multiplies: a yen entry is multiplied by a thousand where a dinar entry is
 * not, so the same digit count overflows in one and not the other. Derived
 * rather than guessed — a fixed cap that suits one currency silently loses
 * precision in another.
 */
function maxDigitsFor(format: CurrencyFormat): number {
  const factor = format.decimalDigits <= 3 ? 1000 / 10 ** format.decimalDigits : 1;
  const largestExactMinor = Math.floor(Number.MAX_SAFE_INTEGER / factor);

  // One digit short of that bound, so every value of this length clears it.
  return String(largestExactMinor).length - 1;
}

export interface AmountInput {
  /** What the field shows. */
  text: string;
  /** What the field means. */
  amount: Milliunits;
}

/**
 * Reinterprets whatever is in an amount field after a keystroke.
 *
 * Digits fill from the right as minor units, the way a card terminal behaves:
 * typing 4, 2, 0 reads as 4.20 in a currency with two decimal places and as
 * 420 in one with none. Everything that is not a digit is discarded, so the
 * separators the field itself wrote cannot be re-entered as input.
 *
 * Entry is unsigned. Whether an amount is an inflow or an outflow is a
 * separate control, not something typed into the number.
 */
export function formatAmountInput(text: string, format: CurrencyFormat): AmountInput {
  const digits = text.replace(/\D/g, '').slice(0, maxDigitsFor(format));
  const minor = digits === '' ? 0 : Number.parseInt(digits, 10);
  const amount = fromMinorUnits(minor, format);

  return { text: formatMilliunits(amount, format), amount };
}

/** Drops every occurrence of `needle`, and nothing at all when it is empty. */
function removeAll(haystack: string, needle: string): string {
  if (needle === '') return haystack;

  return haystack.split(needle).join('');
}

/**
 * Reads an amount that was written out rather than typed in.
 *
 * Accepts the budget's own separators and symbol, and returns null for
 * anything it cannot read, so a caller decides what an unreadable entry means
 * rather than receiving a zero that looks deliberate.
 */
export function parseAmount(text: string, format: CurrencyFormat): Milliunits | null {
  const trimmed = text.trim();
  if (trimmed === '') return null;

  const negative = trimmed.startsWith('-');
  const withoutSign = negative ? trimmed.slice(1) : trimmed;

  const bare = removeAll(
    removeAll(withoutSign, format.currencySymbol),
    format.groupSeparator,
  ).trim();

  const [whole, fraction = '', ...rest] = bare.split(format.decimalSeparator);
  if (rest.length > 0) return null;
  if (whole === undefined || !/^\d*$/.test(whole) || !/^\d*$/.test(fraction)) return null;
  if (whole === '' && fraction === '') return null;

  // A fraction finer than the currency is truncated rather than rejected: it
  // is a real entry that is merely more precise than the currency can hold.
  const padded = fraction.padEnd(format.decimalDigits, '0').slice(0, format.decimalDigits);
  const minor = Number.parseInt(`${whole === '' ? '0' : whole}${padded}`, 10);
  if (!Number.isSafeInteger(minor)) return null;

  const amount = fromMinorUnits(minor, format);

  return negative ? milliunits(-amount) : amount;
}
