import { router } from 'expo-router';

import { ConnectYnabScreen } from '@/auth';

export default function ConnectYnab() {
  return <ConnectYnabScreen onConnected={() => router.back()} />;
}
