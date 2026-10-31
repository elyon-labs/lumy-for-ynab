import { router } from 'expo-router';

import { ChangeEmailScreen } from '@/auth';

export default function ChangeEmail() {
  return <ChangeEmailScreen onDone={() => router.back()} />;
}
