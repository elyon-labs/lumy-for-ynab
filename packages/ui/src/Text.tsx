import { StyleSheet, Text as RNText, type TextProps as RNTextProps } from 'react-native';

import { FontSize, LetterSpacing, LineHeight, type Palette } from '@lumy/theme';

import { useColors } from './theme';

export type TextVariant = 'display' | 'heading' | 'title' | 'body' | 'small' | 'caption';

export type TextTone =
  | 'default'
  | 'muted'
  | 'faint'
  | 'primary'
  | 'accent'
  | 'positive'
  | 'negative'
  | 'warning'
  | 'onPrimary'
  | 'onAccent';

export type TextWeight = 'regular' | 'medium' | 'semibold' | 'bold';

export interface TextProps extends RNTextProps {
  variant?: TextVariant;
  tone?: TextTone;
  weight?: TextWeight;
  /** Lines digits up in a column, for amounts and dates. */
  tabular?: boolean;
}

const TONES: Record<TextTone, keyof Palette> = {
  default: 'text',
  muted: 'textMuted',
  faint: 'textFaint',
  primary: 'primary',
  accent: 'accent',
  positive: 'positive',
  negative: 'negative',
  warning: 'warning',
  onPrimary: 'onPrimary',
  onAccent: 'onAccent',
};

/**
 * Weight selects a face rather than a numeric weight.
 *
 * Android does not synthesise weights for a bundled family, so asking for
 * `fontWeight: '600'` on Outfit silently renders the regular face there while
 * looking right on iOS.
 */
export const FONT_FAMILIES: Record<TextWeight, string> = {
  regular: 'Outfit',
  medium: 'Outfit-Medium',
  semibold: 'Outfit-SemiBold',
  bold: 'Outfit-Bold',
};

export function Text({
  variant = 'body',
  tone = 'default',
  weight = 'regular',
  tabular,
  style,
  ...rest
}: TextProps) {
  const colors = useColors();

  return (
    <RNText
      {...rest}
      style={[
        styles[variant],
        { color: colors[TONES[tone]], fontFamily: FONT_FAMILIES[weight] },
        tabular && styles.tabular,
        style,
      ]}
    />
  );
}

const styles = StyleSheet.create({
  tabular: { fontVariant: ['tabular-nums'] },
  display: {
    fontSize: FontSize.display,
    lineHeight: LineHeight.display,
    letterSpacing: LetterSpacing.tight,
  },
  heading: {
    fontSize: FontSize.heading,
    lineHeight: LineHeight.heading,
    letterSpacing: LetterSpacing.tight,
  },
  title: { fontSize: FontSize.title, lineHeight: LineHeight.title },
  body: { fontSize: FontSize.body, lineHeight: LineHeight.body },
  small: { fontSize: FontSize.small, lineHeight: LineHeight.small },
  caption: { fontSize: FontSize.caption, lineHeight: LineHeight.caption },
});
