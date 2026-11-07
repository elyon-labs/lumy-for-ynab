import { router } from 'expo-router';

import { AccountScreen } from '@/auth';

export default function Account() {
  return <AccountScreen onChangeEmail={() => router.push('/change-email')} />;
}
