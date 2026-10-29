import type { ReactNode } from 'react';
import { StyleSheet, View, type ViewStyle } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { Spacing } from '@lumy/theme';

import { Icon } from './Icon';
import { Pressable } from './Pressable';
import { Text } from './Text';
import { useColors } from './theme';

export interface ScreenProps {
  title?: string;
  /** `back` for a pushed screen, `close` for one presented as a modal. */
  dismiss?: 'back' | 'close';
  /**
   * What dismissing does. Navigation belongs to the app, so this package only
   * draws the control.
   */
  onDismiss?: () => void;
  dismissLabel?: string;
  action?: ReactNode;
  children: ReactNode;
  style?: ViewStyle;
}

/**
 * The frame every screen sits in: safe areas, the background, and a header
 * whose title and action line up the same way everywhere.
 */
export function Screen({
  title,
  dismiss,
  onDismiss,
  dismissLabel,
  action,
  children,
  style,
}: ScreenProps) {
  const colors = useColors();
  const insets = useSafeAreaInsets();

  const showHeader = Boolean(title || dismiss || action);

  return (
    <View
      style={[styles.screen, { backgroundColor: colors.background, paddingTop: insets.top }, style]}
    >
      {showHeader ? (
        <View style={styles.header}>
          <View style={styles.slot}>
            {dismiss && onDismiss ? (
              <Pressable accessibilityLabel={dismissLabel} onPress={onDismiss}>
                <Icon name={dismiss === 'close' ? 'close' : 'chevron-back'} />
              </Pressable>
            ) : null}
          </View>

          <Text variant="title" weight="semibold" numberOfLines={1} style={styles.title}>
            {title ?? ''}
          </Text>

          <View style={[styles.slot, styles.actionSlot]}>{action}</View>
        </View>
      ) : null}

      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Spacing.edge,
    minHeight: 48,
    gap: Spacing.tight,
  },
  // Equal slots either side keep the title optically centred whether or not
  // there is an action.
  slot: { minWidth: 48, justifyContent: 'center' },
  actionSlot: { alignItems: 'flex-end' },
  title: { flex: 1, textAlign: 'center' },
});
