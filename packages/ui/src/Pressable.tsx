import type { ReactNode } from 'react';
import {
  Pressable as RNPressable,
  StyleSheet,
  type PressableProps as RNPressableProps,
  type ViewStyle,
} from 'react-native';

import { HitSlop } from '@lumy/theme';

export interface PressableProps extends Omit<RNPressableProps, 'style' | 'children'> {
  children: ReactNode;
  style?: ViewStyle;
}

/**
 * A press target with the app's touch slop and pressed feedback already on it,
 * so a control smaller than 44pt is still comfortably tappable.
 */
export function Pressable({ children, style, ...rest }: PressableProps) {
  return (
    <RNPressable
      accessibilityRole="button"
      hitSlop={HitSlop}
      {...rest}
      style={({ pressed }) => [style, pressed && styles.pressed]}
    >
      {children}
    </RNPressable>
  );
}

const styles = StyleSheet.create({
  pressed: { opacity: 0.5 },
});
