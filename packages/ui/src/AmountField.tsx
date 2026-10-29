import { useState } from 'react';
import { StyleSheet, TextInput } from 'react-native';

import { formatAmountInput, type CurrencyFormat, type Milliunits } from '@lumy/money';
import { FontSize, LineHeight, Radius, Spacing } from '@lumy/theme';

import { FONT_FAMILIES } from './Text';
import { useColors } from './theme';

export interface AmountFieldProps {
  value: Milliunits;
  onChange: (amount: Milliunits) => void;
  format: CurrencyFormat;
  label?: string;
  autoFocus?: boolean;
}

/**
 * Entry for an amount.
 *
 * Digits fill from the right as minor units, the way a card terminal behaves,
 * so there is no decimal point to place and no half-typed state that does not
 * parse. The field is always showing a valid amount.
 *
 * Entry is unsigned; whether an amount is an inflow or an outflow belongs to a
 * separate control rather than to the number.
 */
export function AmountField({ value, onChange, format, label, autoFocus }: AmountFieldProps) {
  const colors = useColors();
  const [text, setText] = useState(() => formatAmountInput(String(value), format).text);

  return (
    <TextInput
      accessibilityLabel={label}
      keyboardType="number-pad"
      autoFocus={autoFocus}
      selectionColor={colors.primary}
      value={text}
      onChangeText={(next) => {
        const result = formatAmountInput(next, format);
        setText(result.text);
        onChange(result.amount);
      }}
      style={[styles.input, { color: colors.text, backgroundColor: colors.surfaceSunken }]}
    />
  );
}

const styles = StyleSheet.create({
  input: {
    borderRadius: Radius.element,
    paddingHorizontal: Spacing.snug,
    paddingVertical: Spacing.snug,
    fontFamily: FONT_FAMILIES.semibold,
    fontSize: FontSize.heading,
    lineHeight: LineHeight.heading,
    fontVariant: ['tabular-nums'],
    textAlign: 'right',
    minHeight: 48,
  },
});
