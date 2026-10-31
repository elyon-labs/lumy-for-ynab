import { Spacing } from '@lumy/theme';
import { Button, Card, Screen, Text } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

import { useYnabAuth } from './YnabAuthProvider';
import { useGrantWriteAccess } from './ynabQueries';

/**
 * Asking for permission to write, at the moment it is needed.
 *
 * Lumy connects read-only and comes here only when a template is about to
 * create a transaction, so the question arrives with a reason attached rather
 * than as part of signing up. Granting it is another trip through YNAB's
 * consent screen, which returns a token with the wider scope.
 *
 * It renders nothing once write access is held — the guard that pushed it is
 * then satisfied, and a screen explaining a permission the person already
 * granted is a dead end.
 */
export function WriteAccessScreen({ onGranted }: { onGranted?: () => void }) {
  const { t } = useTranslation();
  const { state } = useYnabAuth();
  const grant = useGrantWriteAccess();

  const alreadyGranted = state.status === 'connected' && state.canWrite;

  return (
    <Screen title={t('auth.ynab.writeAccessTitle')} dismiss="close" onDismiss={onGranted}>
      <View style={styles.body}>
        <Card>
          <Text tone="muted">{t('auth.ynab.writeAccessExplainer')}</Text>
        </Card>

        {grant.isError ? (
          <Text variant="small" tone="negative">
            {t('auth.ynab.grantWriteAccessFailed')}
          </Text>
        ) : null}

        <Button
          label={t('auth.ynab.grantWriteAccess')}
          loading={grant.isPending}
          disabled={alreadyGranted}
          onPress={() => {
            grant.mutate(undefined, {
              onSuccess: (outcome) => {
                if (outcome.kind === 'connected') onGranted?.();
              },
            });
          }}
        />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
