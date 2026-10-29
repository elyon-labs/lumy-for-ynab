import type { ColorScheme } from './colors';

/**
 * Chart colours, kept apart from the interface palette.
 *
 * `categorical` is ordered and stable. Charts assign from it by a stable key
 * rather than by position in the rendered data (see `categoricalColor`), so a
 * category appearing or disappearing does not recolour the rest of the chart.
 */
export type ChartPalette = {
  categorical: readonly string[];
  /** The muted series a comparison chart draws behind the current one. */
  compare: string;
  axis: string;
  grid: string;
  tooltip: string;
  onTooltip: string;
};

const light: ChartPalette = {
  categorical: [
    '#81C8BB',
    '#5C43D6',
    '#E0B583',
    '#D76464',
    '#3DA996',
    '#EC8A8A',
    '#A18CDF',
    '#3E9D36',
    // Darker than the dark scheme's yellow, which sits at 1.7 against white and
    // all but disappears there.
    '#B5B03F',
    '#22A6AF',
  ],
  compare: '#CED1D4',
  axis: '#484C53',
  grid: '#E8E6E9',
  tooltip: '#EDEDED',
  onTooltip: '#1C1D1E',
};

const dark: ChartPalette = {
  categorical: [
    '#81C8BB',
    '#9B87F5',
    '#E0B583',
    '#D76464',
    '#3DA996',
    '#EC8A8A',
    '#A18CDF',
    '#3E9D36',
    '#CECA62',
    '#22A6AF',
  ],
  compare: '#484C53',
  axis: '#FFFFFF',
  grid: '#1D1D1D',
  tooltip: '#000000',
  onTooltip: '#FFFFFF',
};

export const ChartColors = { light, dark } as const;

/**
 * The colour for `key` within `keys`.
 *
 * Assigning by the key's position in a sorted key set rather than by its
 * position in the rendered series keeps a category the same colour across
 * renders, across date ranges, and across the screens that chart it.
 */
export function categoricalColor(
  scheme: ColorScheme,
  key: string,
  keys: readonly string[],
): string {
  const { categorical } = ChartColors[scheme];
  const index = [...keys].sort().indexOf(key);

  // An unknown key would index at -1 and wrap to the end of the palette, which
  // reads as a real assignment rather than as the mistake it is.
  if (index < 0) {
    throw new Error(`categoricalColor: "${key}" is not one of the given keys.`);
  }

  return categorical[index % categorical.length]!;
}
