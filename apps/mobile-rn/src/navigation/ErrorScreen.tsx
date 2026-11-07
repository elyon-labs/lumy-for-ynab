import { Spacing } from '@lumy/theme';
import { Button, Card, Icon, Screen, Text } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

export interface ErrorScreenProps {
  title?: string;
  message?: string;
  /** Shown only in a development build, because it is a stack trace's first line. */
  detail?: string;
  retryLabel?: string;
  onRetry?: () => void;
}

/**
 * What a crash looks like.
 *
 * The Flutter app's `error_screen.dart` put both the error text and the way
 * out behind `kDebugMode`, which left a release build on a screen with an
 * apology and no button. The detail stays developer-only — it is a stack
 * trace — but the way out does not.
 */
export function ErrorScreen({ title, message, detail, retryLabel, onRetry }: ErrorScreenProps) {
  const { t } = useTranslation();

  return (
    <Screen>
      <View style={styles.body}>
        <Icon name="alert-circle-outline" tone="negative" size={48} />

        <Text variant="title" weight="semibold" style={styles.centered}>
          {title ?? t('errors.title')}
        </Text>

        <Text tone="muted" style={styles.centered}>
          {message ?? t('errors.message')}
        </Text>

        {__DEV__ && detail !== undefined ? (
          <Card>
            <Text variant="small" tone="negative">
              {detail}
            </Text>
          </Card>
        ) : null}

        {onRetry !== undefined ? (
          <Button label={retryLabel ?? t('common.retry')} onPress={onRetry} style={styles.action} />
        ) : null}
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: Spacing.edge,
    gap: Spacing.snug,
  },
  centered: { textAlign: 'center' },
  action: { alignSelf: 'stretch' },
});
