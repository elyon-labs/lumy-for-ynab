import { Settings } from '@lumy/data';
import { Spacing } from '@lumy/theme';
import { Button, Card, Screen, SectionHeader, Text, TextField } from '@lumy/ui';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

import { useSetting } from '@/settings';

import { useAuth } from './AuthProvider';
import { isValidEmail } from './email';
import { useSignInWithEmail } from './queries';
import { secondsUntilResend } from './resend';

/**
 * Signing in, which is one address and one emailed link.
 *
 * There is no password. The Flutter app carried `signInWithPassword` and
 * `signInAnonymously` beside the link flow — the first for support access and
 * the second for the authentication model it had before Supabase — and nothing
 * reachable used either.
 */
export function SignInScreen() {
  const { t } = useTranslation();
  const { linkError, dismissLinkError } = useAuth();
  const [email, setEmail] = useState('');
  const [invalid, setInvalid] = useState(false);
  const signIn = useSignInWithEmail();

  const sent = signIn.isSuccess;

  // One message, in the order the person can act on them: a typo they can see
  // outranks a failure from the last attempt, and both outrank a link that
  // expired before they got to it.
  const fieldError = invalid
    ? t('auth.signIn.invalidEmail')
    : signIn.error !== null
      ? signIn.error.message
      : linkError !== null
        ? t('auth.signIn.linkFailed')
        : undefined;

  function submit(): void {
    if (!isValidEmail(email)) {
      setInvalid(true);
      return;
    }

    setInvalid(false);
    dismissLinkError();
    signIn.mutate(email);
  }

  return (
    <Screen title={t('auth.signIn.title')}>
      <View style={styles.body}>
        {sent ? (
          <SentCard email={email.trim()} onResend={submit} resending={signIn.isPending} />
        ) : (
          <>
            <Card>
              <Text tone="muted">{t('auth.signIn.explainer')}</Text>
            </Card>

            <TextField
              label={t('auth.signIn.emailLabel')}
              placeholder={t('auth.signIn.emailPlaceholder')}
              value={email}
              onChangeText={(value) => {
                setEmail(value);
                setInvalid(false);
              }}
              error={fieldError}
              autoCapitalize="none"
              autoComplete="email"
              keyboardType="email-address"
              textContentType="emailAddress"
              returnKeyType="send"
              onSubmitEditing={submit}
            />

            <Button
              label={t('auth.signIn.submit')}
              onPress={submit}
              loading={signIn.isPending}
              disabled={email.trim().length === 0}
            />
          </>
        )}
      </View>
    </Screen>
  );
}

/**
 * What the screen says while the link is in an inbox.
 *
 * The resend button is held shut for a minute from when the link was sent,
 * read back from the settings store — so closing the app to go and look at the
 * email does not reset the wait.
 */
function SentCard({
  email,
  onResend,
  resending,
}: {
  email: string;
  onResend: () => void;
  resending: boolean;
}) {
  const { t } = useTranslation();
  const { value: sentAt } = useSetting(Settings.lastAuthLinkSentAt);
  const remaining = useResendCountdown(sentAt);

  return (
    <>
      <SectionHeader title={t('auth.signIn.sentTitle')} />
      <Card>
        <Text tone="muted">{t('auth.signIn.sentExplainer', { email })}</Text>
      </Card>
      <Button
        label={
          remaining > 0
            ? t('auth.signIn.resendIn', { seconds: remaining })
            : t('auth.signIn.resend')
        }
        variant="secondary"
        onPress={onResend}
        disabled={remaining > 0}
        loading={resending}
      />
    </>
  );
}

/**
 * Seconds left of the cooldown, counted down once a second.
 *
 * The clock is the state and the remaining time is derived from it, rather
 * than the other way round: a cooldown that had to be recomputed when the
 * stored timestamp changed would be a `setState` in an effect, and this is
 * the same answer without one.
 */
export function useResendCountdown(sentAt: string | null): number {
  const [now, setNow] = useState(() => new Date());

  useEffect(() => {
    const timer = setInterval(() => setNow(new Date()), 1000);

    return () => clearInterval(timer);
  }, []);

  return secondsUntilResend(sentAt, now);
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
