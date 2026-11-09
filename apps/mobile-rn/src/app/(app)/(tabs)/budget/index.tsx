import { EmptyState, Screen } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { RefreshControl, ScrollView, StyleSheet } from 'react-native';

import { useRefresh } from '@/sync';

/**
 * The Budget tab, which the shell exists to hold.
 *
 * Empty until the budget tab proper arrives: category groups, balances, and
 * month navigation are their own PR. What is here already is the pull-to-
 * refresh, because that belongs to the tab rather than to what fills it — the
 * Flutter app wrapped its whole shell in one `RefreshIndicator` and passed the
 * callback down through a provider so that any descendant could reach it.
 */
export default function Budget() {
  const { t } = useTranslation();
  const refresh = useRefresh();

  return (
    <Screen title={t('navigation.budget')}>
      <ScrollView
        contentContainerStyle={styles.body}
        refreshControl={
          <RefreshControl refreshing={refresh.isRefreshing} onRefresh={refresh.refresh} />
        }
      >
        <EmptyState
          icon="wallet-outline"
          title={t('navigation.budget')}
          message={t('tabs.comingSoon')}
        />
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  // `flexGrow` rather than `flex`, so the empty state fills the tab and there
  // is still somewhere to pull from.
  body: { flexGrow: 1 },
});
