import { StyleSheet, View } from 'react-native';

import { LetterSpacing, Spacing } from '@lumy/theme';

import { Text } from './Text';

export interface SectionHeaderProps {
  title: string;
  /** A count, a total, or an action, shown at the trailing edge. */
  accessory?: React.ReactNode;
}

export function SectionHeader({ title, accessory }: SectionHeaderProps) {
  return (
    <View style={styles.header}>
      <Text variant="small" tone="muted" weight="semibold" style={styles.title}>
        {title}
      </Text>
      {accessory}
    </View>
  );
}

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: Spacing.edge,
    paddingTop: Spacing.loose,
    paddingBottom: Spacing.tight,
    gap: Spacing.tight,
  },
  title: { textTransform: 'uppercase', letterSpacing: LetterSpacing.wide },
});
