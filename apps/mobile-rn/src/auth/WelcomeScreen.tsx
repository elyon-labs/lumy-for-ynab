import { Spacing } from '@lumy/theme';
import { Button, Card, Icon, Screen, Text } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

/**
 * The first screen someone who is not signed in sees.
 *
 * It belongs to the navigation shell rather than to the auth screens, because
 * what an unauthenticated person sees is the redirect chain's decision: this
 * is where `shellDecision` sends everyone it cannot place, and the only way
 * out of it is signing in.
 */
export function WelcomeScreen({ onSignIn }: { onSignIn: () => void }) {
  const { t } = useTranslation();

  return (
    <Screen>
      <View style={styles.body}>
        <View style={styles.hero}>
          <Icon name="wallet-outline" tone="primary" size={56} />

          <Text variant="display" weight="semibold" style={styles.centered}>
            {t('welcome.title')}
          </Text>

          <Text variant="title" tone="muted" style={styles.centered}>
            {t('welcome.tagline')}
          </Text>
        </View>

        <Card>
          <Text tone="muted">{t('welcome.explainer')}</Text>
        </Card>

        <Button label={t('welcome.signIn')} onPress={onSignIn} />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, paddingBottom: Spacing.loose, gap: Spacing.snug },
  hero: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: Spacing.snug },
  centered: { textAlign: 'center' },
});
