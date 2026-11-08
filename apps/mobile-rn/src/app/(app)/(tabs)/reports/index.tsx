import { EmptyState, Screen } from '@lumy/ui';
import { useTranslation } from 'react-i18next';
import { RefreshControl, ScrollView, StyleSheet } from 'react-native';

import { useRefresh } from '@/sync';

export default function Reports() {
  const { t } = useTranslation();
  const refresh = useRefresh();

  return (
    <Screen title={t('navigation.reports')}>
      <ScrollView
        contentContainerStyle={styles.body}
        refreshControl={
          <RefreshControl refreshing={refresh.isRefreshing} onRefresh={refresh.refresh} />
        }
      >
        <EmptyState
          icon="analytics-outline"
          title={t('navigation.reports')}
          message={t('tabs.comingSoon')}
        />
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flexGrow: 1 },
});
