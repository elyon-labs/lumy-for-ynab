import { router } from 'expo-router';

import { WelcomeScreen } from '@/auth';

export default function Welcome() {
  return <WelcomeScreen onSignIn={() => router.push('/sign-in')} />;
}
