import { useEffect, useRef } from 'react';
import { AppState, type AppStateStatus } from 'react-native';

import { now } from '@/settings';

import { isStale } from './lastFetch';
import { useRefresh, useSyncStatus } from './queries';
import { useSyncProgress } from './SyncProvider';

/**
 * Syncs when someone comes back to a Lumy that has gone stale.
 *
 * The Flutter app did this from a `LifecycleListener` with the same fifteen
 * minute window, and it is the reason the app usually looks current without
 * anyone pulling. Mounted inside the shell, so it only runs for someone who
 * has a budget with data in it — a first sync is the first-run screen's job
 * and must not be raced by this.
 *
 * Whether the data is stale is `isStale`, which is pure and tested. What is
 * here is only the listener and the guard against starting a second run.
 */
export function SyncOnResume(): null {
  const status = useSyncStatus();
  const progress = useSyncProgress();
  const refresh = useRefresh();

  // Read through a ref so the subscription is made once rather than torn down
  // and rebuilt every time the status re-reads — which it does after every
  // sync, including the ones this starts.
  const latest = useRef({ status, progress, refresh });

  useEffect(() => {
    latest.current = { status, progress, refresh };
  }, [status, progress, refresh]);

  useEffect(() => {
    const onChange = (next: AppStateStatus) => {
      if (next !== 'active') return;

      const current = latest.current;
      if (current.progress.status === 'running' || current.refresh.isRefreshing) return;
      if (current.status.data === undefined) return;

      if (isStale(current.status.data.lastFetchedAt, now())) current.refresh.refresh();
    };

    const subscription = AppState.addEventListener('change', onChange);

    return () => subscription.remove();
  }, []);

  return null;
}
