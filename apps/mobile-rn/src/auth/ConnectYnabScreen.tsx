import { Spacing } from '@lumy/theme';
import { Button, Card, Screen, Text } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

import { useConnectYnab } from './ynabQueries';

/**
 * Connecting YNAB, which is one button and a trip to YNAB's own site.
 *
 * It asks for read-only. Write access is a separate grant and is asked for
 * only when a template is about to create a transaction, so most installs
 * never hold a token that can write.
 */
export function ConnectYnabScreen({ onConnected }: { onConnected?: () => void }) {
  const { t } = useTranslation();
  const connect = useConnectYnab();

  // Backing out of the browser changed nothing, so it is neither an error to
  // show nor a success to move on from.
  const failed = connect.isError;

  return (
    <Screen title={t('auth.ynab.connectTitle')}>
      <View style={styles.body}>
        <Card>
          <Text tone="muted">{t('auth.ynab.connectExplainer')}</Text>
        </Card>
        <Card>
          <Text variant="small" tone="muted">
            {t('auth.ynab.connectNote')}
          </Text>
        </Card>

        {failed ? (
          <Text variant="small" tone="negative">
            {connect.error.message}
          </Text>
        ) : null}

        <Button
          label={t('auth.ynab.connect')}
          loading={connect.isPending}
          onPress={() => {
            connect.mutate(undefined, {
              onSuccess: (outcome) => {
                if (outcome.kind === 'connected') onConnected?.();
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
