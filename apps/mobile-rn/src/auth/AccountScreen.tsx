import { Spacing } from '@lumy/theme';
import { Card, Dialog, ListRow, Screen, SectionHeader, Text } from '@lumy/ui';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { StyleSheet, View } from 'react-native';

import { useAccount } from './AuthProvider';
import { useDeleteAccount, useSignOut } from './queries';

/**
 * The account, and the two ways out of it.
 *
 * Both are behind a confirmation, and the deleting one says what goes: the
 * Supabase account and everything configured against it. The YNAB budget is
 * not Lumy's to delete and saying so is the difference between a dialog
 * someone reads and one they dismiss.
 */

type Confirming = 'none' | 'signOut' | 'delete';

export function AccountScreen({ onChangeEmail }: { onChangeEmail?: () => void }) {
  const { t } = useTranslation();
  const account = useAccount();
  const [confirming, setConfirming] = useState<Confirming>('none');
  const signOut = useSignOut();
  const deleteAccount = useDeleteAccount();

  return (
    <Screen title={t('auth.account.title')}>
      <View style={styles.body}>
        <Card flush>
          <ListRow
            title={t('auth.account.email')}
            accessory={<Text tone="muted">{account.email ?? ''}</Text>}
          />
          <ListRow title={t('auth.account.changeEmail')} onPress={onChangeEmail} chevron />
        </Card>

        {account.pendingEmail !== null ? (
          <>
            <SectionHeader title={t('auth.account.pendingEmail')} />
            <Card>
              <Text tone="muted">
                {t('auth.account.pendingEmailExplainer', { email: account.pendingEmail })}
              </Text>
            </Card>
          </>
        ) : null}

        <Card flush>
          <ListRow
            title={t('auth.account.signOut')}
            onPress={() => setConfirming('signOut')}
            disabled={signOut.isPending}
          />
          <ListRow
            title={t('auth.account.deleteAccount')}
            subtitle={deleteAccount.error !== null ? t('auth.account.deleteFailed') : undefined}
            onPress={() => setConfirming('delete')}
            disabled={deleteAccount.isPending}
            destructive
          />
        </Card>
      </View>

      {confirming === 'signOut' ? (
        <Dialog
          title={t('auth.account.signOutConfirmTitle')}
          message={t('auth.account.signOutConfirmMessage')}
          confirmLabel={t('auth.account.signOut')}
          cancelLabel={t('common.cancel')}
          confirming={signOut.isPending}
          onConfirm={() => {
            setConfirming('none');
            signOut.mutate();
          }}
          onCancel={() => setConfirming('none')}
        />
      ) : null}

      {confirming === 'delete' ? (
        <Dialog
          title={t('auth.account.deleteConfirmTitle')}
          message={t('auth.account.deleteConfirmMessage')}
          confirmLabel={t('auth.account.deleteConfirm')}
          cancelLabel={t('common.cancel')}
          confirming={deleteAccount.isPending}
          destructive
          onConfirm={() => {
            setConfirming('none');
            deleteAccount.mutate();
          }}
          onCancel={() => setConfirming('none')}
        />
      ) : null}
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
