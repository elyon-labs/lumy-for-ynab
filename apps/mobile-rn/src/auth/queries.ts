import { Settings } from '@lumy/data';
import { useMutation, type UseMutationResult } from '@tanstack/react-query';

import { useSetting } from '@/settings';

import { useAuth } from './AuthProvider';

/**
 * The account mutations, one per thing the person can do.
 *
 * Each wraps one call on the account API and nothing else. Sending a link also
 * records when, which is what the resend cooldown is measured from — and it is
 * recorded only on success, so a rejected request does not start a wait for
 * an email that was never sent.
 */

export function useSignInWithEmail(): UseMutationResult<void, Error, string> {
  const { api } = useAuth();
  const { setValue: setSentAt } = useSetting(Settings.lastAuthLinkSentAt);

  return useMutation({
    mutationFn: async (email: string) => {
      await api.signInWithEmail(email);
      await setSentAt(new Date().toISOString());
    },
  });
}

export function useChangeEmail(): UseMutationResult<void, Error, string> {
  const { api } = useAuth();
  const { setValue: setSentAt } = useSetting(Settings.lastAuthLinkSentAt);

  return useMutation({
    mutationFn: async (email: string) => {
      await api.changeEmail(email);
      await setSentAt(new Date().toISOString());
    },
  });
}

export function useSignOut(): UseMutationResult<void, Error, void> {
  const { api } = useAuth();

  return useMutation({ mutationFn: () => api.signOut() });
}

export function useDeleteAccount(): UseMutationResult<void, Error, void> {
  const { api } = useAuth();

  return useMutation({ mutationFn: () => api.deleteAccount() });
}
