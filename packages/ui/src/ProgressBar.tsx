import { useEffect, useState } from 'react';
import { Animated, Easing, StyleSheet, View } from 'react-native';

import { Radius, Spacing } from '@lumy/theme';

import { useColors } from './theme';

export interface ProgressBarProps {
  /**
   * How far along, from 0 to 1, or null when that is not yet known.
   *
   * Null is not zero. A sync that has asked YNAB for a page and not yet been
   * answered has made progress nobody can measure, and a bar pinned at zero
   * for the duration reads as nothing happening.
   */
  progress: number | null;
  /** What is being waited for, for anyone not watching the bar. */
  accessibilityLabel: string;
}

/**
 * A determinate bar that falls back to an indeterminate sweep.
 *
 * The one component in this package with two modes rather than two variants,
 * because which one is right is a property of the value rather than of the
 * caller: anything that reports progress in steps has steps it cannot measure.
 */
export function ProgressBar({ progress, accessibilityLabel }: ProgressBarProps) {
  const colors = useColors();
  const [sweep] = useState(() => new Animated.Value(0));
  const indeterminate = progress === null;

  useEffect(() => {
    if (!indeterminate) return;

    sweep.setValue(0);
    const animation = Animated.loop(
      Animated.timing(sweep, {
        toValue: 1,
        duration: 1200,
        easing: Easing.inOut(Easing.quad),
        useNativeDriver: true,
      }),
    );
    animation.start();

    return () => animation.stop();
  }, [indeterminate, sweep]);

  const clamped = progress === null ? 0 : Math.min(1, Math.max(0, progress));

  return (
    <View
      accessibilityRole="progressbar"
      accessibilityLabel={accessibilityLabel}
      accessibilityValue={indeterminate ? undefined : { min: 0, max: 100, now: Math.round(clamped * 100) }}
      style={[styles.track, { backgroundColor: colors.surfaceSunken }]}
    >
      {indeterminate ? (
        <Animated.View
          style={[
            styles.fill,
            styles.sweep,
            {
              backgroundColor: colors.primary,
              // Travelling the whole track means moving by five times its own
              // width, which `translateX` expresses as a fraction of the
              // sweep rather than of the track.
              transform: [
                { translateX: sweep.interpolate({ inputRange: [0, 1], outputRange: ['-100%', '500%'] }) },
              ],
            },
          ]}
        />
      ) : (
        <View
          style={[
            styles.fill,
            { backgroundColor: colors.primary, width: `${clamped * 100}%` },
          ]}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  track: {
    height: Spacing.tight,
    borderRadius: Radius.pill,
    overflow: 'hidden',
  },
  fill: { height: '100%', borderRadius: Radius.pill },
  sweep: { width: '20%' },
});
