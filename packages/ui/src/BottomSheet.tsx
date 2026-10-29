import { useEffect, useState, type ReactNode } from 'react';
import { Animated, Modal, Pressable, StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { Radius, Spacing } from '@lumy/theme';

import { Divider } from './Divider';
import { Text } from './Text';
import { useColors } from './theme';

export interface BottomSheetProps {
  title?: string;
  onDismiss: () => void;
  dismissLabel?: string;
  children: ReactNode;
}

/**
 * The modal fades rather than slides, because a sliding transparent modal drags
 * its backdrop up with it and exposes the full-screen container. The sheet does
 * its own short rise on top of that fade.
 */
export function BottomSheet({ title, onDismiss, dismissLabel, children }: BottomSheetProps) {
  const colors = useColors();
  const insets = useSafeAreaInsets();
  const [progress] = useState(() => new Animated.Value(0));

  useEffect(() => {
    Animated.timing(progress, { toValue: 1, duration: 180, useNativeDriver: true }).start();
  }, [progress]);

  const translateY = progress.interpolate({ inputRange: [0, 1], outputRange: [48, 0] });

  return (
    <Modal
      animationType="fade"
      transparent
      presentationStyle="overFullScreen"
      onRequestClose={onDismiss}
    >
      <Pressable
        accessibilityLabel={dismissLabel}
        style={[styles.backdrop, { backgroundColor: colors.backdrop }]}
        onPress={onDismiss}
      >
        <Animated.View style={[styles.sheet, { transform: [{ translateY }] }]}>
          {/* Swallows a tap on the sheet itself so it does not reach the
              backdrop behind and close what was just opened. */}
          <Pressable
            onPress={(event) => event.stopPropagation()}
            style={[
              styles.panel,
              {
                backgroundColor: colors.surface,
                borderColor: colors.border,
                paddingBottom: Math.max(insets.bottom, Spacing.edge),
              },
            ]}
          >
            {title !== undefined ? (
              <>
                <View style={styles.header}>
                  <Text variant="title" weight="semibold">
                    {title}
                  </Text>
                </View>
                <Divider />
              </>
            ) : null}
            {children}
          </Pressable>
        </Animated.View>
      </Pressable>
    </Modal>
  );
}

const styles = StyleSheet.create({
  backdrop: { flex: 1, justifyContent: 'flex-end' },
  sheet: { margin: Spacing.snug },
  panel: {
    borderRadius: Radius.card,
    borderWidth: StyleSheet.hairlineWidth,
    overflow: 'hidden',
    paddingTop: Spacing.tight,
  },
  header: { paddingHorizontal: Spacing.edge, paddingVertical: Spacing.snug },
});
