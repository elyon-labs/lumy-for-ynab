import { describe, expect, it } from 'vitest';

import { Colors, type ColorScheme, type Palette } from './colors';
import { contrastRatio } from './contrast';

const AA_BODY = 4.5;
const AA_LARGE = 3;

type Pair = readonly [keyof Palette, keyof Palette];

/** Text and icon colours against every surface they are drawn on. */
const BODY_PAIRS: readonly Pair[] = [
  ['text', 'background'],
  ['text', 'surface'],
  ['text', 'surfaceSunken'],
  ['text', 'surfacePressed'],
  ['textMuted', 'background'],
  ['textMuted', 'surface'],
  ['textMuted', 'surfaceSunken'],
  ['textMuted', 'surfacePressed'],

  ['primary', 'background'],
  ['primary', 'surface'],
  ['primary', 'surfaceSunken'],
  ['accent', 'background'],
  ['accent', 'surface'],
  ['accent', 'surfaceSunken'],

  // Amounts are coloured by sign, so these carry body text at body size.
  ['positive', 'background'],
  ['positive', 'surface'],
  ['positive', 'surfaceSunken'],
  ['negative', 'background'],
  ['negative', 'surface'],
  ['negative', 'surfaceSunken'],
  ['warning', 'background'],
  ['warning', 'surface'],
  ['warning', 'surfaceSunken'],
];

/** Each hue's readable colour against its own tint. */
const HUE_ON_SURFACE_PAIRS: readonly Pair[] = [
  ['primary', 'primarySurface'],
  ['accent', 'accentSurface'],
  ['positive', 'positiveSurface'],
  ['negative', 'negativeSurface'],
  ['warning', 'warningSurface'],
];

/** Text on a hue used as a solid fill. */
const ON_FILL_PAIRS: readonly Pair[] = [
  ['onPrimary', 'primary'],
  ['onPrimary', 'primaryPressed'],
  ['onAccent', 'accent'],
  ['onPositive', 'positive'],
  ['onNegative', 'negative'],
  ['onWarning', 'warning'],
];

/**
 * Colours that never carry body text: timestamps and counts at caption size,
 * and the border of a field or secondary button, which has to read as an edge
 * rather than merely as taste.
 */
const LARGE_PAIRS: readonly Pair[] = [
  ['textFaint', 'background'],
  ['textFaint', 'surface'],
  ['borderStrong', 'background'],
  ['borderStrong', 'surface'],
];

describe.each(Object.keys(Colors) as ColorScheme[])('%s palette contrast', (scheme) => {
  const palette = Colors[scheme];

  it.each([...BODY_PAIRS, ...HUE_ON_SURFACE_PAIRS, ...ON_FILL_PAIRS])(
    '%s on %s meets AA for body text',
    (foreground, background) => {
      expect(contrastRatio(palette[foreground], palette[background])).toBeGreaterThanOrEqual(
        AA_BODY,
      );
    },
  );

  it.each(LARGE_PAIRS)('%s on %s meets AA for large text and non-text', (foreground, background) => {
    expect(contrastRatio(palette[foreground], palette[background])).toBeGreaterThanOrEqual(
      AA_LARGE,
    );
  });
});

describe('palette shape', () => {
  it('defines the same tokens in both schemes', () => {
    expect(Object.keys(Colors.dark).sort()).toEqual(Object.keys(Colors.light).sort());
  });

  it.each(Object.keys(Colors) as ColorScheme[])('%s states every token as a hex value', (scheme) => {
    for (const [token, value] of Object.entries(Colors[scheme])) {
      expect(value, token).toMatch(/^#[0-9A-F]{6}([0-9A-F]{2})?$/);
    }
  });

  it('separates background from surface in each scheme', () => {
    // Light deliberately shares the two, the way the Flutter app did: a card on
    // white is delineated by its border, not by its fill. Dark must not, or a
    // card disappears into the page.
    expect(Colors.dark.background).not.toEqual(Colors.dark.surface);
  });
});
