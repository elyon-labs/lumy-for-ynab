import { Spacing } from '@lumy/theme';
import { Button, Card, Screen, SectionHeader, Text, TextField } from '@lumy/ui';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

import { useAccount } from './AuthProvider';
import { isValidEmail } from './email';
import { useChangeEmail } from './queries';

/**
 * Changing the address the account is reached at.
 *
 * Supabase emails the new address to confirm it, and the account keeps the old
 * one until that link is opened — so the screen's job after submitting is to
 * say that, rather than to look as though anything has changed yet.
 */
export function ChangeEmailScreen({ onDone }: { onDone?: () => void }) {
  const { t } = useTranslation();
  const account = useAccount();
  const [email, setEmail] = useState('');
  const [problem, setProblem] = useState<string | null>(null);
  const change = useChangeEmail();

  function submit(): void {
    const trimmed = email.trim();

    if (!isValidEmail(trimmed)) {
      setProblem(t('auth.signIn.invalidEmail'));
      return;
    }

    if (trimmed.toLowerCase() === account.email?.toLowerCase()) {
      setProblem(t('auth.changeEmail.sameAsCurrent'));
      return;
    }

    setProblem(null);
    change.mutate(trimmed);
  }

  if (change.isSuccess) {
    return (
      <Screen title={t('auth.changeEmail.title')} dismiss="back" onDismiss={onDone}>
        <View style={styles.body}>
          <SectionHeader title={t('auth.changeEmail.sentTitle')} />
          <Card>
            <Text tone="muted">
              {t('auth.changeEmail.sentExplainer', { email: email.trim() })}
            </Text>
          </Card>
          <Button label={t('common.done')} onPress={() => onDone?.()} />
        </View>
      </Screen>
    );
  }

  return (
    <Screen title={t('auth.changeEmail.title')} dismiss="back" onDismiss={onDone}>
      <View style={styles.body}>
        <Card>
          <Text tone="muted">{t('auth.changeEmail.explainer')}</Text>
        </Card>

        <TextField
          label={t('auth.changeEmail.emailLabel')}
          placeholder={t('auth.signIn.emailPlaceholder')}
          value={email}
          onChangeText={(value) => {
            setEmail(value);
            setProblem(null);
          }}
          error={problem ?? change.error?.message}
          autoCapitalize="none"
          autoComplete="email"
          keyboardType="email-address"
          textContentType="emailAddress"
          returnKeyType="send"
          onSubmitEditing={submit}
        />

        <Button
          label={t('auth.changeEmail.submit')}
          onPress={submit}
          loading={change.isPending}
          disabled={email.trim().length === 0}
        />
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
