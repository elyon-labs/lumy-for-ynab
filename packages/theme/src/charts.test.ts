import { describe, expect, it } from 'vitest';

import { categoricalColor, ChartColors } from './charts';
import { Colors, type ColorScheme } from './colors';
import { contrastRatio } from './contrast';

const schemes = Object.keys(ChartColors) as ColorScheme[];

describe('chart palettes', () => {
  it('define the same keys in both schemes', () => {
    expect(Object.keys(ChartColors.dark).sort()).toEqual(Object.keys(ChartColors.light).sort());
  });

  it.each(schemes)('%s offers ten distinct categorical colours', (scheme) => {
    const { categorical } = ChartColors[scheme];

    expect(categorical).toHaveLength(10);
    expect(new Set(categorical).size).toBe(10);
  });

  it.each(schemes)('%s separates every series from the chart background', (scheme) => {
    // A slice or line the same value as the page behind it is invisible, which
    // a categorical palette ported from another context can easily produce.
    for (const color of ChartColors[scheme].categorical) {
      expect(contrastRatio(color, Colors[scheme].background), color).toBeGreaterThanOrEqual(1.8);
    }
  });

  it.each(schemes)('%s keeps tooltip text readable', (scheme) => {
    const { tooltip, onTooltip } = ChartColors[scheme];

    expect(contrastRatio(onTooltip, tooltip)).toBeGreaterThanOrEqual(4.5);
  });
});

describe('categoricalColor', () => {
  const keys = ['groceries', 'rent', 'transport'];

  it('assigns by the sorted key set, not by call order', () => {
    const first = categoricalColor('light', 'rent', keys);
    const again = categoricalColor('light', 'rent', ['transport', 'rent', 'groceries']);

    expect(again).toBe(first);
  });

  it('keeps a category stable when another is added', () => {
    // Sorting puts the new key after 'groceries', so 'groceries' holds its slot
    // even though the set it belongs to grew.
    const before = categoricalColor('light', 'groceries', keys);
    const after = categoricalColor('light', 'groceries', [...keys, 'utilities']);

    expect(after).toBe(before);
  });

  it('gives different categories different colours', () => {
    const assigned = keys.map((key) => categoricalColor('light', key, keys));

    expect(new Set(assigned).size).toBe(keys.length);
  });

  it('wraps past the end of the palette', () => {
    const many = Array.from({ length: 12 }, (_, index) => `c${String(index).padStart(2, '0')}`);

    expect(categoricalColor('light', 'c10', many)).toBe(categoricalColor('light', 'c00', many));
  });

  it('rejects a key outside the set', () => {
    expect(() => categoricalColor('light', 'savings', keys)).toThrow(/not one of the given keys/);
  });
});
