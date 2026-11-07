import { router } from 'expo-router';
import { useTranslation } from 'react-i18next';

import { EmptyState, Screen } from '@lumy/ui';

/**
 * A link into the app that nothing answers to.
 *
 * An emailed link never arrives here: `resolveLinkPath` only navigates to a
 * path the shell has, so a confirmed email change pointing at a screen that
 * does not exist yet stays where the redirect chain put it. What reaches this
 * is a mistyped or stale deep link.
 */
export default function NotFound() {
  const { t } = useTranslation();

  return (
    <Screen>
      <EmptyState
        icon="help-circle-outline"
        title={t('notFound.title')}
        message={t('notFound.message')}
        actionLabel={t('notFound.goHome')}
        onAction={() => router.replace('/budget')}
      />
    </Screen>
  );
}
