import type { ReactNode } from 'react';
import { Pressable, StyleSheet, View, type ViewStyle } from 'react-native';

import { HitSlop, Spacing } from '@lumy/theme';

import { Icon } from './Icon';
import { Text } from './Text';
import { useColors } from './theme';

export interface ListRowProps {
  title: string;
  subtitle?: string;
  /** Shown at the trailing edge — a value, a tick, or a spinner. */
  accessory?: ReactNode;
  leading?: ReactNode;
  onPress?: () => void;
  /** Draws the chevron that says the row opens something. */
  chevron?: boolean;
  destructive?: boolean;
  disabled?: boolean;
  style?: ViewStyle;
}

/** The one row shape every list in the app is built from. */
export function ListRow({
  title,
  subtitle,
  accessory,
  leading,
  onPress,
  chevron,
  destructive,
  disabled,
  style,
}: ListRowProps) {
  const colors = useColors();

  const content = (
    <>
      {leading}
      <View style={styles.text}>
        <Text tone={destructive === true ? 'negative' : 'default'} numberOfLines={1}>
          {title}
        </Text>
        {subtitle !== undefined ? (
          <Text variant="small" tone="muted" numberOfLines={2}>
            {subtitle}
          </Text>
        ) : null}
      </View>
      {accessory}
      {chevron === true ? <Icon name="chevron-forward" tone="faint" /> : null}
    </>
  );

  if (onPress === undefined) {
    return <View style={[styles.row, style]}>{content}</View>;
  }

  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ disabled }}
      hitSlop={HitSlop}
      disabled={disabled}
      onPress={onPress}
      style={({ pressed }) => [
        styles.row,
        pressed && { backgroundColor: colors.surfacePressed },
        disabled === true && styles.disabled,
        style,
      ]}
    >
      {content}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Spacing.edge,
    paddingVertical: Spacing.snug,
    minHeight: 48,
    gap: Spacing.snug,
  },
  text: { flex: 1, gap: Spacing.unit / 2 },
  disabled: { opacity: 0.4 },
});
