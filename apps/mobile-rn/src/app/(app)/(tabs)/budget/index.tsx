import { EmptyState, Screen } from '@lumy/ui';
import { useTranslation } from 'react-i18next';

/**
 * The Budget tab, which the shell exists to hold.
 *
 * Empty until the budget tab proper arrives: category groups, balances, and
 * month navigation are their own PR, and the first sync that would fill them
 * is the one after this.
 */
export default function Budget() {
  const { t } = useTranslation();

  return (
    <Screen title={t('navigation.budget')}>
      <EmptyState icon="wallet-outline" title={t('navigation.budget')} message={t('tabs.comingSoon')} />
    </Screen>
  );
}
