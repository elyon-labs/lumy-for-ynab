import { createSyncEngine, type SyncEngine, type SyncProgress } from '@lumy/data';
import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
  useSyncExternalStore,
  type ReactNode,
} from 'react';

import { useYnabAuth } from '@/auth';
import { useDatabaseState } from '@/data';

import {
  advanceSyncProgress,
  IDLE_SYNC_PROGRESS,
  type SyncProgressState,
} from './progress';

/**
 * The sync engine, as the app holds it.
 *
 * It is composed here and nowhere else, from the two things it needs: the open
 * database and a YNAB client that refreshes its own token. Both can be absent
 * — the database is opening, YNAB is not connected — so the engine is null
 * until they are not, and every caller is a screen the redirect chain only
 * reaches once they are.
 *
 * The progress fan-out is the reason this is a provider rather than a hook
 * that builds an engine per screen. `onProgress` is on `SyncEngineOptions` and
 * not on `syncBudget`, so it belongs to the engine rather than to a call: a
 * screen cannot pass its own callback down. So the engine is created once with
 * one callback that writes to a store here, and any screen subscribes to that.
 * Building an engine per caller would also mean two of them writing to the
 * same database with no idea of each other.
 */

export interface SyncValue {
  /** Null until the database is open and YNAB is connected. */
  engine: SyncEngine | null;
}

const SyncContext = createContext<SyncValue | null>(null);

/**
 * The latest progress, and who is watching it.
 *
 * A store with its own subscribers rather than provider state, because the
 * engine emits a progress event per committed chunk — a first sync of a large
 * budget emits hundreds — and routing each one through a `setState` here would
 * re-render everything below. `useSyncExternalStore` re-renders only what
 * reads the value.
 */
interface ProgressStore {
  get: () => SyncProgressState;
  set: (next: SyncProgressState) => void;
  subscribe: (listener: () => void) => () => void;
}

function createProgressStore(): ProgressStore {
  let state = IDLE_SYNC_PROGRESS;
  const listeners = new Set<() => void>();

  return {
    get: () => state,
    set: (next) => {
      state = next;
      for (const listener of listeners) listener();
    },
    subscribe: (listener) => {
      listeners.add(listener);

      return () => listeners.delete(listener);
    },
  };
}

const ProgressContext = createContext<ProgressStore | null>(null);

export function SyncProvider({ children }: { children: ReactNode }) {
  const database = useDatabaseState();
  const { client } = useYnabAuth();

  // Created once for the life of the provider. The store is the identity every
  // subscriber holds, so a second one would silently orphan them.
  const [progress] = useState(createProgressStore);

  const adapter = database.status === 'ready' ? database.database.adapter : null;

  const engine = useMemo(
    () =>
      adapter === null || client === null
        ? null
        : createSyncEngine({
            db: adapter,
            client,
            onProgress: (event: SyncProgress) =>
              progress.set(advanceSyncProgress(progress.get(), event)),
          }),
    [adapter, client, progress],
  );

  const value = useMemo<SyncValue>(() => ({ engine }), [engine]);

  return (
    <ProgressContext.Provider value={progress}>
      <SyncContext.Provider value={value}>{children}</SyncContext.Provider>
    </ProgressContext.Provider>
  );
}

function useProgressStore(): ProgressStore {
  const store = useContext(ProgressContext);
  if (store === null) {
    throw new Error('useSyncProgress must be called inside a SyncProvider.');
  }

  return store;
}

export function useSync(): SyncValue {
  const value = useContext(SyncContext);
  if (value === null) {
    throw new Error('useSync must be called inside a SyncProvider.');
  }

  return value;
}

/** The current run's progress, re-rendering only what reads it. */
export function useSyncProgress(): SyncProgressState {
  const store = useProgressStore();

  return useSyncExternalStore(store.subscribe, store.get, store.get);
}

/** Replaces the progress state, for the hooks that start and finish a run. */
export function useSetSyncProgress(): (
  update: (state: SyncProgressState) => SyncProgressState,
) => void {
  const store = useProgressStore();

  return useCallback((update) => store.set(update(store.get())), [store]);
}
