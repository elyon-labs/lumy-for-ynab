import { StyleSheet, View, type ViewProps } from 'react-native';

import { Radius, Spacing } from '@lumy/theme';

import { useColors } from './theme';

export interface CardProps extends ViewProps {
  /** Drops the padding, for a card whose content reaches its edges. */
  flush?: boolean;
}

export function Card({ flush, style, ...rest }: CardProps) {
  const colors = useColors();

  return (
    <View
      {...rest}
      style={[
        styles.base,
        { backgroundColor: colors.surface, borderColor: colors.border },
        flush === true && styles.flush,
        style,
      ]}
    />
  );
}

const styles = StyleSheet.create({
  base: {
    borderRadius: Radius.card,
    borderWidth: StyleSheet.hairlineWidth,
    padding: Spacing.edge,
    gap: Spacing.tight,
  },
  flush: { padding: 0, overflow: 'hidden' },
});
