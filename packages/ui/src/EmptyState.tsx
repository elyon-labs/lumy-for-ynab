import { StyleSheet, View } from 'react-native';

import { Spacing } from '@lumy/theme';

import { Button } from './Button';
import { Icon, type IconName } from './Icon';
import { Text } from './Text';

export interface EmptyStateProps {
  icon?: IconName;
  title: string;
  message?: string;
  actionLabel?: string;
  onAction?: () => void;
}

/** What a list says when it has nothing in it yet. */
export function EmptyState({ icon, title, message, actionLabel, onAction }: EmptyStateProps) {
  return (
    <View style={styles.empty}>
      {icon !== undefined ? <Icon name={icon} tone="faint" size={40} /> : null}

      <Text variant="title" weight="semibold" style={styles.centered}>
        {title}
      </Text>

      {message !== undefined ? (
        <Text tone="muted" style={styles.centered}>
          {message}
        </Text>
      ) : null}

      {actionLabel !== undefined && onAction !== undefined ? (
        <Button label={actionLabel} onPress={onAction} />
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  empty: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: Spacing.loose,
    gap: Spacing.snug,
  },
  centered: { textAlign: 'center' },
});
