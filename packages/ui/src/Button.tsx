import { ActivityIndicator, Pressable, StyleSheet, type ViewStyle } from 'react-native';

import { HitSlop, Radius, Spacing } from '@lumy/theme';

import { Text, type TextTone } from './Text';
import { useColors } from './theme';

export type ButtonVariant = 'primary' | 'secondary' | 'destructive' | 'ghost';

export interface ButtonProps {
  label: string;
  onPress: () => void;
  variant?: ButtonVariant;
  disabled?: boolean;
  loading?: boolean;
  style?: ViewStyle;
}

export function Button({
  label,
  onPress,
  variant = 'primary',
  disabled,
  loading,
  style,
}: ButtonProps) {
  const colors = useColors();
  const inactive = disabled === true || loading === true;

  const tones: Record<ButtonVariant, TextTone> = {
    primary: 'onPrimary',
    secondary: 'default',
    destructive: 'negative',
    ghost: 'primary',
  };

  const fills: Record<ButtonVariant, { idle: ViewStyle; pressed: ViewStyle }> = {
    primary: {
      idle: { backgroundColor: colors.primary, borderColor: colors.primary },
      pressed: { backgroundColor: colors.primaryPressed, borderColor: colors.primaryPressed },
    },
    secondary: {
      idle: { backgroundColor: 'transparent', borderColor: colors.borderStrong },
      pressed: { backgroundColor: colors.surfacePressed },
    },
    destructive: {
      idle: { backgroundColor: 'transparent', borderColor: colors.negative },
      pressed: { backgroundColor: colors.negativeSurface },
    },
    ghost: {
      idle: { backgroundColor: 'transparent', borderColor: 'transparent' },
      pressed: { opacity: 0.6 },
    },
  };

  return (
    <Pressable
      accessibilityRole="button"
      accessibilityState={{ disabled: inactive }}
      hitSlop={HitSlop}
      disabled={inactive}
      onPress={onPress}
      style={({ pressed }) => [
        styles.base,
        variant === 'ghost' && styles.ghost,
        fills[variant].idle,
        pressed && fills[variant].pressed,
        inactive && styles.inactive,
        style,
      ]}
    >
      {loading === true ? (
        <ActivityIndicator color={variant === 'primary' ? colors.onPrimary : colors.primary} />
      ) : (
        <Text weight="semibold" tone={tones[variant]}>
          {label}
        </Text>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  base: {
    borderRadius: Radius.element,
    paddingVertical: Spacing.snug,
    paddingHorizontal: Spacing.edge,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    minHeight: 48,
  },
  // Carries no chrome of its own, so the label is the whole control.
  ghost: { borderWidth: 0, minHeight: 0, paddingHorizontal: 0 },
  inactive: { opacity: 0.4 },
});
