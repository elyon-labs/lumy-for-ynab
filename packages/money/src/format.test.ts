import { describe, expect, it } from 'vitest';

import { ALL_FORMATS, EUR_DE, JPY, KWD, NO_SYMBOL, SEK, USD } from './fixtures';
import { formatCompact, formatMilliunits } from './format';
import { milliunits, ZERO } from './milliunits';

describe('formatMilliunits', () => {
  it('writes a two-place currency', () => {
    expect(formatMilliunits(milliunits(12_340), USD)).toBe('$12.34');
  });

  it('groups thousands', () => {
    expect(formatMilliunits(milliunits(1_234_567_890), USD)).toBe('$1,234,567.89');
  });

  it('puts the symbol where the currency puts it', () => {
    expect(formatMilliunits(milliunits(12_340), EUR_DE)).toBe('12,34€');
  });

  it('uses the currency’s own separators', () => {
    expect(formatMilliunits(milliunits(1_234_567_890), EUR_DE)).toBe('1.234.567,89€');
  });

  it('handles a space as a group separator', () => {
    expect(formatMilliunits(milliunits(1_234_560), SEK)).toBe('1 234,56kr');
  });

  it('writes a currency with no fractional part', () => {
    expect(formatMilliunits(milliunits(1_234_000), JPY)).toBe('¥1,234');
  });

  it('writes a currency finer than two places', () => {
    expect(formatMilliunits(milliunits(1_234), KWD)).toBe('KD1.234');
  });

  it('omits a symbol the budget hides', () => {
    expect(formatMilliunits(milliunits(12_340), NO_SYMBOL)).toBe('12.34');
  });

  it('pads a fraction that is shorter than the currency', () => {
    expect(formatMilliunits(milliunits(5_000), USD)).toBe('$5.00');
    expect(formatMilliunits(milliunits(50), USD)).toBe('$0.05');
  });

  it('writes zero', () => {
    expect(formatMilliunits(ZERO, USD)).toBe('$0.00');
    expect(formatMilliunits(ZERO, JPY)).toBe('¥0');
  });

  describe('sign', () => {
    it('leads the symbol rather than following it', () => {
      // "$-12.34" reads as a negative currency rather than a negative amount.
      expect(formatMilliunits(milliunits(-12_340), USD)).toBe('-$12.34');
    });

    it('leads a trailing symbol too', () => {
      expect(formatMilliunits(milliunits(-12_340), EUR_DE)).toBe('-12,34€');
    });

    it('can mark an inflow explicitly', () => {
      expect(formatMilliunits(milliunits(12_340), USD, { signDisplay: 'always' })).toBe('+$12.34');
      expect(formatMilliunits(milliunits(-12_340), USD, { signDisplay: 'always' })).toBe('-$12.34');
    });

    it('never marks zero', () => {
      expect(formatMilliunits(ZERO, USD, { signDisplay: 'always' })).toBe('$0.00');
    });

    it('can drop the sign for a magnitude', () => {
      expect(formatMilliunits(milliunits(-12_340), USD, { signDisplay: 'never' })).toBe('$12.34');
    });
  });

  it('can drop the fractional part', () => {
    expect(formatMilliunits(milliunits(1_234_560), USD, { hideDecimals: true })).toBe('$1,234');
  });
});

describe('formatCompact', () => {
  it('writes anything under a thousand in full', () => {
    expect(formatCompact(milliunits(999_000), USD)).toBe('$999.00');
  });

  it('shortens thousands, millions, and billions', () => {
    const interval = milliunits(1_000_000_000_000);

    expect(formatCompact(milliunits(12_000_000), USD, { interval })).toBe('$12K');
    expect(formatCompact(milliunits(12_000_000_000), USD, { interval })).toBe('$12M');
    expect(formatCompact(milliunits(12_000_000_000_000), USD, { interval })).toBe('$12B');
  });

  it('takes precision from the step between labels', () => {
    // An axis stepping by a hundred needs a decimal, or 1.2K and 1.3K both
    // print as 1K and the labels repeat.
    expect(formatCompact(milliunits(1_250_000), USD, { interval: milliunits(100_000) })).toBe(
      '$1.3K',
    );
    expect(formatCompact(milliunits(1_250_000), USD, { interval: milliunits(5_000_000) })).toBe(
      '$1K',
    );
  });

  it('keeps the sign ahead of the symbol', () => {
    expect(formatCompact(milliunits(-12_000_000), USD, { interval: milliunits(10_000_000) })).toBe(
      '-$12K',
    );
  });

  it('respects the currency’s separators and symbol position', () => {
    expect(formatCompact(milliunits(1_250_000), EUR_DE, { interval: milliunits(100_000) })).toBe(
      '1,3K€',
    );
  });

  it('writes zero without a suffix', () => {
    expect(formatCompact(ZERO, USD)).toBe('$0.00');
  });
});

describe('every supported format', () => {
  it.each(ALL_FORMATS.map((format) => [format.isoCode, format] as const))(
    '%s round-trips zero and keeps the sign out front',
    (_isoCode, format) => {
      expect(formatMilliunits(ZERO, format)).not.toContain('-');
      expect(formatMilliunits(milliunits(-1_000_000), format).startsWith('-')).toBe(true);
    },
  );
});
