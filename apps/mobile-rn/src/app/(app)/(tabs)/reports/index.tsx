import { EmptyState, Screen } from '@lumy/ui';
import { useTranslation } from 'react-i18next';

export default function Reports() {
  const { t } = useTranslation();

  return (
    <Screen title={t('navigation.reports')}>
      <EmptyState
        icon="analytics-outline"
        title={t('navigation.reports')}
        message={t('tabs.comingSoon')}
      />
    </Screen>
  );
}
