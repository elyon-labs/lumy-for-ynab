// Resolved per platform by the app; kept as data so this package stays
// runnable outside React Native.
export const FontStack = {
  ios: 'Outfit',
  android: 'Outfit',
  web: "Outfit, system-ui, -apple-system, 'Helvetica Neue', sans-serif",
  default: 'Outfit',
} as const;

/**
 * The size scale. A component passes a variant name; it never sets a size.
 *
 * Paired with LineHeight under the same keys, so picking a size picks its
 * leading too.
 */
export const FontSize = {
  caption: 11,
  small: 13,
  body: 15,
  title: 18,
  heading: 22,
  display: 28,
} as const;

export const LineHeight = {
  caption: 14,
  small: 18,
  body: 20,
  title: 24,
  heading: 28,
  display: 34,
} as const;

export const FontWeight = {
  regular: '400',
  medium: '500',
  semibold: '600',
  bold: '700',
} as const;

export const LetterSpacing = {
  tight: -0.2,
  normal: 0,
  wide: 0.6,
} as const;

export type TextVariant = keyof typeof FontSize;
export type FontWeightToken = keyof typeof FontWeight;
