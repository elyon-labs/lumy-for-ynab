import { Pressable, StyleSheet } from 'react-native';

import { HitSlop, Radius, Spacing } from '@lumy/theme';

import { Text } from './Text';
import { useColors } from './theme';

export interface ChipProps {
  label: string;
  onPress?: () => void;
  accessibilityLabel?: string;
  selected?: boolean;
}

export function Chip({ label, onPress, accessibilityLabel, selected }: ChipProps) {
  const colors = useColors();

  return (
    <Pressable
      accessibilityRole={onPress === undefined ? undefined : 'button'}
      accessibilityLabel={accessibilityLabel ?? label}
      accessibilityState={{ selected }}
      hitSlop={HitSlop}
      disabled={onPress === undefined}
      onPress={onPress}
      style={({ pressed }) => [
        styles.chip,
        {
          borderColor: selected === true ? colors.primary : colors.border,
          backgroundColor: selected === true ? colors.primarySurface : colors.surface,
        },
        pressed && { backgroundColor: colors.surfacePressed },
      ]}
    >
      <Text variant="small" tone={selected === true ? 'primary' : 'muted'}>
        {label}
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  chip: {
    borderRadius: Radius.pill,
    borderWidth: StyleSheet.hairlineWidth,
    paddingHorizontal: Spacing.snug,
    paddingVertical: Spacing.unit,
  },
});
