import { describe, expect, it } from 'vitest';

import { ALL_FORMATS, EUR_DE, JPY, KWD, NO_SYMBOL, SEK, USD } from './fixtures';
import { formatAmountInput, parseAmount } from './input';
import { milliunits, ZERO } from './milliunits';

describe('formatAmountInput', () => {
  it('fills digits from the right as minor units', () => {
    // The card-terminal model: each keystroke pushes the decimal point left.
    expect(formatAmountInput('4', USD)).toEqual({ text: '$0.04', amount: 40 });
    expect(formatAmountInput('42', USD)).toEqual({ text: '$0.42', amount: 420 });
    expect(formatAmountInput('420', USD)).toEqual({ text: '$4.20', amount: 4200 });
  });

  it('reads the same digits differently in a currency with no fraction', () => {
    expect(formatAmountInput('420', JPY)).toEqual({ text: '¥420', amount: 420_000 });
  });

  it('reads the same digits differently in a three-place currency', () => {
    expect(formatAmountInput('420', KWD)).toEqual({ text: 'KD0.420', amount: 420 });
  });

  it('shows a cleared field as zero rather than empty', () => {
    expect(formatAmountInput('', USD)).toEqual({ text: '$0.00', amount: 0 });
  });

  it('is idempotent, so the field can be fed back through it', () => {
    // The field holds what this returned; the next keystroke re-runs it over
    // text that now contains the separators it just wrote.
    const once = formatAmountInput('123456', USD);

    expect(formatAmountInput(once.text, USD)).toEqual(once);
  });

  it('ignores separators typed by hand', () => {
    expect(formatAmountInput('1,234.56', USD).amount).toBe(1_234_560);
  });

  it('ignores a minus, because direction is not typed into the number', () => {
    expect(formatAmountInput('-420', USD)).toEqual({ text: '$4.20', amount: 4200 });
  });

  it('caps an absurd entry rather than losing exactness', () => {
    const { amount } = formatAmountInput('9'.repeat(40), USD);

    expect(Number.isSafeInteger(amount)).toBe(true);
  });

  it('grows into grouped digits', () => {
    expect(formatAmountInput('123456789', USD).text).toBe('$1,234,567.89');
    expect(formatAmountInput('123456789', SEK).text).toBe('1 234 567,89kr');
  });
});

describe('parseAmount', () => {
  it('reads a plain amount', () => {
    expect(parseAmount('12.34', USD)).toBe(12_340);
  });

  it('reads the symbol and separators back', () => {
    expect(parseAmount('$1,234.56', USD)).toBe(1_234_560);
    expect(parseAmount('1.234,56€', EUR_DE)).toBe(1_234_560);
    expect(parseAmount('1 234,56kr', SEK)).toBe(1_234_560);
  });

  it('reads a negative amount', () => {
    expect(parseAmount('-$12.34', USD)).toBe(-12_340);
  });

  it('pads a short fraction', () => {
    expect(parseAmount('12.3', USD)).toBe(12_300);
  });

  it('truncates a fraction finer than the currency', () => {
    // More precision than the currency holds is still a real entry.
    expect(parseAmount('12.349', USD)).toBe(12_340);
    expect(parseAmount('12.9', JPY)).toBe(12_000);
  });

  it('accepts an amount with no whole part', () => {
    expect(parseAmount('.5', USD)).toBe(500);
  });

  it('accepts an amount with no fraction', () => {
    expect(parseAmount('12', USD)).toBe(12_000);
  });

  it('reads zero', () => {
    expect(parseAmount('0', USD)).toBe(ZERO);
  });

  it.each(['', '   ', 'abc', '1.2.3', '12a', '$'])(
    'returns null for %o rather than a misleading zero',
    (text) => {
      expect(parseAmount(text, USD)).toBeNull();
    },
  );

  it('returns null past exact integer arithmetic', () => {
    expect(parseAmount('9'.repeat(20), USD)).toBeNull();
  });

  it('works without a displayed symbol', () => {
    expect(parseAmount('12.34', NO_SYMBOL)).toBe(12_340);
  });
});

describe('round trip', () => {
  it.each(ALL_FORMATS.map((format) => [format.isoCode, format] as const))(
    '%s reads back what it wrote',
    (_isoCode, format) => {
      for (const amount of [0, 1_000, 12_340, -12_340, 1_234_567_000]) {
        const written = formatAmountInput(String(Math.abs(amount) / 10), format);

        expect(parseAmount(written.text, format)).toBe(written.amount);
      }
    },
  );
});

describe('the digit cap', () => {
  it.each(ALL_FORMATS.map((format) => [format.isoCode, format] as const))(
    '%s stays exact under an absurd entry',
    (_isoCode, format) => {
      const { amount, text } = formatAmountInput('9'.repeat(40), format);

      expect(Number.isSafeInteger(amount)).toBe(true);
      expect(parseAmount(text, format)).toBe(amount);
    },
  );
});
