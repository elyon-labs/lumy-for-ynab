import type { ReactNode } from 'react';
import { Modal, StyleSheet, View } from 'react-native';

import { Radius, Spacing } from '@lumy/theme';

import { Button } from './Button';
import { Text } from './Text';
import { useColors } from './theme';

export interface DialogProps {
  title: string;
  message?: string;
  /** Replaces the message with whatever the caller needs instead. */
  children?: ReactNode;
  confirmLabel: string;
  cancelLabel: string;
  onConfirm: () => void;
  onCancel: () => void;
  destructive?: boolean;
  confirming?: boolean;
}

/**
 * A decision the person has to make before anything else happens.
 *
 * Cancel sits first and carries no emphasis, so the destructive answer is
 * never the one a thumb lands on by habit.
 */
export function Dialog({
  title,
  message,
  children,
  confirmLabel,
  cancelLabel,
  onConfirm,
  onCancel,
  destructive,
  confirming,
}: DialogProps) {
  const colors = useColors();

  return (
    <Modal animationType="fade" transparent presentationStyle="overFullScreen" onRequestClose={onCancel}>
      <View style={[styles.backdrop, { backgroundColor: colors.backdrop }]}>
        <View style={[styles.panel, { backgroundColor: colors.surface, borderColor: colors.border }]}>
          <Text variant="title" weight="semibold">
            {title}
          </Text>

          {children ??
            (message !== undefined ? (
              <Text tone="muted">{message}</Text>
            ) : null)}

          <View style={styles.actions}>
            <Button label={cancelLabel} variant="secondary" onPress={onCancel} style={styles.action} />
            <Button
              label={confirmLabel}
              variant={destructive === true ? 'destructive' : 'primary'}
              loading={confirming}
              onPress={onConfirm}
              style={styles.action}
            />
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  backdrop: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: Spacing.loose },
  panel: {
    width: '100%',
    maxWidth: 420,
    borderRadius: Radius.card,
    borderWidth: StyleSheet.hairlineWidth,
    padding: Spacing.edge,
    gap: Spacing.snug,
  },
  actions: { flexDirection: 'row', gap: Spacing.tight, paddingTop: Spacing.tight },
  action: { flex: 1 },
});
