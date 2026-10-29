import { StyleSheet, TextInput, View, type TextInputProps } from 'react-native';

import { FontSize, LineHeight, Radius, Spacing } from '@lumy/theme';

import { FONT_FAMILIES, Text } from './Text';
import { useColors } from './theme';

export interface TextFieldProps extends Omit<TextInputProps, 'style'> {
  label?: string;
  /** Replaces the hint beneath the field and turns its edge red. */
  error?: string;
  hint?: string;
}

export function TextField({ label, error, hint, ...rest }: TextFieldProps) {
  const colors = useColors();
  const invalid = error !== undefined;

  return (
    <View style={styles.field}>
      {label !== undefined ? (
        <Text variant="small" tone="muted">
          {label}
        </Text>
      ) : null}

      <TextInput
        accessibilityLabel={label}
        placeholderTextColor={colors.textFaint}
        selectionColor={colors.primary}
        {...rest}
        style={[
          styles.input,
          {
            color: colors.text,
            backgroundColor: colors.surfaceSunken,
            borderColor: invalid ? colors.negative : colors.border,
          },
        ]}
      />

      {invalid || hint !== undefined ? (
        <Text variant="caption" tone={invalid ? 'negative' : 'faint'}>
          {error ?? hint}
        </Text>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  field: { gap: Spacing.unit },
  input: {
    borderRadius: Radius.element,
    borderWidth: StyleSheet.hairlineWidth,
    paddingHorizontal: Spacing.snug,
    paddingVertical: Spacing.snug,
    fontFamily: FONT_FAMILIES.regular,
    fontSize: FontSize.body,
    lineHeight: LineHeight.body,
    minHeight: 48,
  },
});
