import { Spacing } from '@lumy/theme';
import { Card, ListRow, Screen, SectionHeader, Text } from '@lumy/ui';
import { router } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { ScrollView, StyleSheet } from 'react-native';

import { useAuth, useYnabAuth } from '@/auth';
import { useSelectedBudget } from '@/settings';

/**
 * The Settings tab, which is where the account and YNAB screens are reached
 * from now that nothing pushes them from a placeholder.
 *
 * Everything else that belongs in Settings — appearance, the period, sync
 * status, the category views — arrives with the feature that owns it.
 */
export default function SettingsTab() {
  const { t } = useTranslation();
  const { state: account } = useAuth();
  const { state: ynab } = useYnabAuth();
  const { selectBudget } = useSelectedBudget();

  return (
    <Screen title={t('navigation.settings')}>
      <ScrollView contentContainerStyle={styles.body}>
        <SectionHeader title={t('settings.accounts')} />
        <Card flush>
          <ListRow
            title={t('settings.lumyAccount')}
            subtitle={account.status === 'signedIn' ? (account.account.email ?? undefined) : undefined}
            onPress={() => router.push('/account')}
            chevron
          />
          <ListRow
            title={t('settings.ynabAccount')}
            subtitle={
              ynab.status === 'connected'
                ? ynab.canWrite
                  ? t('auth.ynab.canWrite')
                  : t('auth.ynab.readOnly')
                : undefined
            }
            onPress={() => router.push('/write-access')}
            chevron
          />
        </Card>

        <SectionHeader title={t('settings.budget')} />
        <Card flush>
          <ListRow
            title={t('settings.changeBudget')}
            subtitle={t('settings.changeBudgetExplainer')}
            // Clearing the choice is the whole of it: the redirect chain sees
            // no budget and shows the picker.
            onPress={() => void selectBudget(null)}
            chevron
          />
        </Card>

        {__DEV__ ? (
          <>
            <SectionHeader title={t('settings.developer')} />
            <Card flush>
              <ListRow
                title={t('settings.debug')}
                onPress={() => router.push('/debug')}
                chevron
              />
            </Card>
            <Text variant="caption" tone="faint">
              {t('settings.developerExplainer')}
            </Text>
          </>
        ) : null}
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { paddingHorizontal: Spacing.edge, paddingBottom: Spacing.loose, gap: Spacing.snug },
});
