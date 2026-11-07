import { ConnectYnabScreen } from '@/auth';

/**
 * No success handler: storing the token changes the redirect chain's answer,
 * and the onboarding layout is what acts on that.
 */
export default function ConnectYnab() {
  return <ConnectYnabScreen />;
}
