/**
 * Lumy's palette: a violet brand hue on near-neutral surfaces.
 *
 * Violet is the brand and marks the primary action and the current selection.
 * Teal is the one secondary hue. Everything else is a neutral or one of the
 * three status hues, and the status hues carry meaning about money: `positive`
 * for inflow and for being under a target, `negative` for outflow and for
 * being over one.
 *
 * Both schemes carry the same token names, so a component indexes the palette
 * by scheme instead of branching on it.
 *
 * Each hue comes as three tokens. The bare name is the readable one, safe for
 * text and icons on any surface. `*Surface` is its tint, for a fill behind the
 * readable one. `on*` is for text on top of the bare colour used as a fill.
 * Every one of those relationships is asserted in colors.test.ts.
 */
// A type alias rather than an interface so the palette is assignable to a
// string-keyed record.
export type Palette = {
  background: string;
  surface: string;
  surfaceSunken: string;
  surfacePressed: string;

  border: string;
  borderStrong: string;

  text: string;
  textMuted: string;
  textFaint: string;

  primary: string;
  primaryPressed: string;
  primarySurface: string;
  onPrimary: string;

  accent: string;
  accentSurface: string;
  onAccent: string;

  positive: string;
  positiveSurface: string;
  onPositive: string;

  negative: string;
  negativeSurface: string;
  onNegative: string;

  warning: string;
  warningSurface: string;
  onWarning: string;

  skeleton: string;
  skeletonHighlight: string;

  backdrop: string;
};

const light: Palette = {
  background: '#FFFFFF',
  surface: '#FFFFFF',
  surfaceSunken: '#F2F2F7',
  surfacePressed: '#E8E6E9',

  border: '#D5D1D9',
  borderStrong: '#8E8A94',

  text: '#1C1D1E',
  textMuted: '#5F6368',
  textFaint: '#86898E',

  primary: '#5C43D6',
  primaryPressed: '#4A35AD',
  primarySurface: '#EFEBFC',
  onPrimary: '#FFFFFF',

  accent: '#2B7366',
  accentSurface: '#EAF5F2',
  onAccent: '#FFFFFF',

  positive: '#2E7D32',
  positiveSurface: '#EAF5EA',
  onPositive: '#FFFFFF',

  negative: '#B3261E',
  negativeSurface: '#FCEDEB',
  onNegative: '#FFFFFF',

  warning: '#8A5300',
  warningSurface: '#FBF0DC',
  onWarning: '#FFFFFF',

  skeleton: '#E0E2E5',
  skeletonHighlight: '#CFD2D7',

  backdrop: '#1C1D1EA6',
};

const dark: Palette = {
  background: '#090909',
  surface: '#121212',
  surfaceSunken: '#000000',
  surfacePressed: '#1D1D1D',

  border: '#45444B',
  borderStrong: '#6F6E78',

  text: '#FFFFFF',
  textMuted: '#B4B8C0',
  textFaint: '#7F858C',

  primary: '#9B87F5',
  primaryPressed: '#B3A3F8',
  primarySurface: '#1E1830',
  onPrimary: '#15102B',

  accent: '#70C1B3',
  accentSurface: '#13241F',
  onAccent: '#1E1E1E',

  positive: '#6FD267',
  positiveSurface: '#122014',
  onPositive: '#0C2009',

  negative: '#EFA2A2',
  negativeSurface: '#2A1414',
  onNegative: '#5A2222',

  warning: '#E0B583',
  warningSurface: '#241B10',
  onWarning: '#272727',

  skeleton: '#302F35',
  skeletonHighlight: '#45444B',

  backdrop: '#000000B3',
};

export const Colors = { light, dark } as const;

export type ColorScheme = keyof typeof Colors;
export type ColorToken = keyof Palette;
