import { useMutation, type UseMutationResult } from '@tanstack/react-query';

import { useYnabAuth } from './YnabAuthProvider';
import type { ConnectOutcome } from './ynabSession';

/**
 * Connecting YNAB, upgrading the permission, and disconnecting.
 *
 * Each wraps one call on the session. Backing out of the browser is a success
 * that changed nothing, not a failure — the outcome says which, so a screen
 * does not show an error for someone who pressed cancel.
 */

export function useConnectYnab(): UseMutationResult<ConnectOutcome, Error, void> {
  const { connect } = useYnabAuth();

  return useMutation({ mutationFn: () => connect() });
}

export function useGrantWriteAccess(): UseMutationResult<ConnectOutcome, Error, void> {
  const { connect } = useYnabAuth();

  return useMutation({ mutationFn: () => connect({ write: true }) });
}

export function useDisconnectYnab(): UseMutationResult<void, Error, void> {
  const { disconnect } = useYnabAuth();

  return useMutation({ mutationFn: () => disconnect() });
}
