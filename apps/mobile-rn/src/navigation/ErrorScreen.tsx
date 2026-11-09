import { Spacing } from '@lumy/theme';
import { Button, Card, Icon, Screen, Text, ThemeProvider } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';

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

/**
 * The error screen as the root error boundary has to render it.
 *
 * A boundary renders *instead of* the subtree that threw, so every provider
 * that subtree set up is gone by the time this is on screen — including the
 * two `ErrorScreen` needs. `useTheme` and `useSafeAreaInsets` both throw when
 * their provider is missing, so the boundary's own render threw and the person
 * saw the second error rather than the first. In a release build, where there
 * is no LogBox, they would have seen nothing at all.
 *
 * So the boundary brings its own. Neither provider needs anything from the
 * failed tree: the theme falls back to following the device, and the insets
 * come from the window. Deliberately not the stored theme preference — reading
 * it needs the database, and the database failing to open is one of the things
 * this screen exists to report.
 */
export function RootErrorScreen(props: ErrorScreenProps) {
  return (
    <SafeAreaProvider>
      <ThemeProvider>
        <ErrorScreen {...props} />
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
