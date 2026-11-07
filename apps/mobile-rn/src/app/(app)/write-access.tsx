import { router } from 'expo-router';

import { WriteAccessScreen } from '@/auth';

export default function WriteAccess() {
  return <WriteAccessScreen onGranted={() => router.back()} />;
}
