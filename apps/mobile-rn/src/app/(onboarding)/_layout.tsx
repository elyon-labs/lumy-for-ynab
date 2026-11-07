import { Redirect, Stack, usePathname } from 'expo-router';
import { useTranslation } from 'react-i18next';

import { ErrorScreen, Splash, onboardingRedirect, useShellDecision } from '@/navigation';

/**
 * The steps before the shell: welcome, sign in, connect YNAB, choose a budget.
 *
 * What it redirects on is whether the screen being looked at is still the step
 * the chain is asking for. Redirecting straight to the chain's answer would
 * pull someone off the sign-in screen the moment they opened it, since the
 * answer while signed out is the welcome screen; ignoring the answer entirely
 * would leave them on the connect screen after they had connected.
 */
export default function OnboardingLayout() {
  const { t } = useTranslation();
  const decision = useShellDecision();
  const pathname = usePathname();

  if (decision.kind === 'wait') return <Splash />;

  if (decision.kind === 'failed') {
    return <ErrorScreen title={t('errors.databaseTitle')} message={t('errors.databaseMessage')} />;
  }

  if (decision.kind === 'app') return <Redirect href="/budget" />;

  const target = onboardingRedirect(pathname, decision.path);
  if (target !== null) return <Redirect href={target} />;

  return <Stack screenOptions={{ headerShown: false }} />;
}
