import { Redirect } from 'expo-router';
import { useTranslation } from 'react-i18next';

import { ErrorScreen, Splash, useShellDecision } from '@/navigation';

/**
 * The redirect chain, which is all this route is.
 *
 * Every cold start lands here and goes somewhere else. The group layouts guard
 * their own subtrees so a deep link cannot walk past them, but this is where
 * the decision is first acted on, and it is the only screen that renders every
 * one of the decision's four answers.
 */
export default function Index() {
  const { t } = useTranslation();
  const decision = useShellDecision();

  switch (decision.kind) {
    case 'wait':
      return <Splash />;

    case 'failed':
      return (
        <ErrorScreen
          title={t('errors.databaseTitle')}
          message={t('errors.databaseMessage')}
        />
      );

    case 'onboarding':
      return <Redirect href={decision.path} />;

    case 'app':
      return <Redirect href="/budget" />;
  }
}
