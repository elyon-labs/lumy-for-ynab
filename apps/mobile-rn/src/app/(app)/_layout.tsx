import { Redirect, Stack } from 'expo-router';
import { useTranslation } from 'react-i18next';

import { AuthLinkRouter, ErrorScreen, Splash, useShellDecision } from '@/navigation';
import { SyncOnResume } from '@/sync';

/**
 * Everything that needs an account, a YNAB token, a chosen budget, and that
 * budget's data.
 *
 * The guard is here as well as on the index route so that a deep link into any
 * of these screens cannot walk past it. `useAccount`, `useDatabase`, and
 * `useBudgetId` all throw rather than returning null, and this layout is what
 * makes those throws unreachable.
 */
export default function AppLayout() {
  const { t } = useTranslation();
  const decision = useShellDecision();

  if (decision.kind === 'wait') return <Splash />;

  if (decision.kind === 'failed') {
    return <ErrorScreen title={t('errors.databaseTitle')} message={t('errors.databaseMessage')} />;
  }

  if (decision.kind === 'onboarding') return <Redirect href={decision.path} />;

  return (
    <>
      {/* Inside the guard, so a link's destination is only navigated to once
          there is a shell to navigate it within. */}
      <AuthLinkRouter />
      {/* Also inside it, so a resume cannot race the first sync: the screen
          that performs that one is above this layout, not within it. */}
      <SyncOnResume />
      <Stack screenOptions={{ headerShown: false }} />
    </>
  );
}
