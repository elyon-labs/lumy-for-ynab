import { useEffect, useState } from 'react';
import { Animated, Easing, StyleSheet, type ViewStyle } from 'react-native';

import { Radius } from '@lumy/theme';

import { useColors } from './theme';

export interface SkeletonProps {
  width?: number | `${number}%`;
  height?: number;
  /** Matches the shape of what is loading: a row, a bar, or an avatar. */
  shape?: 'block' | 'pill';
  style?: ViewStyle;
}

/**
 * A placeholder that pulses while real content loads.
 *
 * It pulses opacity rather than sweeping a gradient across itself, so it costs
 * one native-driven animation per placeholder instead of a shader.
 */
export function Skeleton({ width = '100%', height = 16, shape = 'block', style }: SkeletonProps) {
  const colors = useColors();
  const [pulse] = useState(() => new Animated.Value(0));

  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(pulse, {
          toValue: 1,
          duration: 700,
          easing: Easing.inOut(Easing.quad),
          useNativeDriver: true,
        }),
        Animated.timing(pulse, {
          toValue: 0,
          duration: 700,
          easing: Easing.inOut(Easing.quad),
          useNativeDriver: true,
        }),
      ]),
    );
    animation.start();

    return () => animation.stop();
  }, [pulse]);

  return (
    <Animated.View
      accessibilityRole="progressbar"
      style={[
        styles.base,
        shape === 'pill' && styles.pill,
        {
          width,
          height,
          backgroundColor: colors.skeleton,
          opacity: pulse.interpolate({ inputRange: [0, 1], outputRange: [1, 0.45] }),
        },
        style,
      ]}
    />
  );
}

const styles = StyleSheet.create({
  base: { borderRadius: Radius.element },
  pill: { borderRadius: Radius.pill },
});
