import Ionicons from '@expo/vector-icons/Ionicons';
import { type ComponentProps } from 'react';

import { FontSize, type Palette } from '@lumy/theme';

import { useColors } from './theme';
import type { TextTone } from './Text';

export type IconName = ComponentProps<typeof Ionicons>['name'];

export interface IconProps {
  name: IconName;
  tone?: TextTone;
  size?: number;
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
 * The icon set, behind a boundary.
 *
 * Screens name an icon and a tone; which set draws it is this component's
 * business. Sizes come from the type scale so an icon beside a label matches
 * its height.
 */
export function Icon({ name, tone = 'default', size = FontSize.heading }: IconProps) {
  const colors = useColors();

  return <Ionicons name={name} size={size} color={colors[TONES[tone]]} />;
}
