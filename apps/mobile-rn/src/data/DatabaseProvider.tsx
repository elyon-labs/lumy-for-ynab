import { migrate, schemaVersion, type DatabaseAdapter } from '@lumy/data';
import { openAppDatabase } from '@lumy/data/expo';
import { QueryClient, QueryClientProvider, useQueryClient } from '@tanstack/react-query';
import { createContext, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';

import { subscribeToDatabaseChanges } from './liveQueries';

/**
 * Opens the database, brings it up to the current schema, and wires the one
 * subscriber that keeps every query honest.
 *
 * The provider owns both because they have the same lifetime: a subscription
 * to a database that has been closed is a leak, and a database with no
 * subscriber is a screen that shows what was true when it mounted.
 */

export interface Database {
  adapter: DatabaseAdapter;
  /** The schema version the device is at, for the debug screen. */
  schema: number;
  sqliteVersion: string;
}

export type DatabaseState =
  | { status: 'opening' }
  | { status: 'ready'; database: Database }
  | { status: 'failed'; error: Error };

const DatabaseContext = createContext<DatabaseState>({ status: 'opening' });

/**
 * Defaults chosen for a client whose data is local.
 *
 * A query is never stale on a timer, because the database says when it is
 * stale and says so exactly. Refetching on an interval would re-run SQL that
 * nothing has invalidated, and refetching on focus would do it on every tab
 * change. One retry, because a failing local read fails the same way twice.
 */
export function createQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: Infinity,
        refetchOnWindowFocus: false,
        refetchOnReconnect: false,
        retry: 1,
      },
    },
  });
}

function useOpenDatabase(): DatabaseState {
  const [state, setState] = useState<DatabaseState>({ status: 'opening' });

  useEffect(() => {
    let cancelled = false;
    let opened: DatabaseAdapter | null = null;

    void (async () => {
      try {
        const adapter = await openAppDatabase();
        opened = adapter;
        await migrate(adapter);

        const [schema, sqliteVersion] = await Promise.all([
          schemaVersion(adapter),
          adapter.sqliteVersion(),
        ]);

        if (!cancelled) {
          setState({ status: 'ready', database: { adapter, schema, sqliteVersion } });
        }
      } catch (error) {
        if (!cancelled) {
          setState({
            status: 'failed',
            error: error instanceof Error ? error : new Error(String(error)),
          });
        }
      }
    })();

    return () => {
      cancelled = true;
      void opened?.close();
    };
  }, []);

  return state;
}

/** Subscribes the query client to the database for as long as both exist. */
function DatabaseChangeSubscriber({ adapter }: { adapter: DatabaseAdapter }): null {
  const queryClient = useQueryClient();

  useEffect(
    () => subscribeToDatabaseChanges(adapter, queryClient),
    [adapter, queryClient],
  );

  return null;
}

export function DatabaseProvider({ children }: { children: ReactNode }) {
  const state = useOpenDatabase();
  const queryClient = useMemo(() => createQueryClient(), []);

  return (
    <QueryClientProvider client={queryClient}>
      {state.status === 'ready' ? (
        <DatabaseChangeSubscriber adapter={state.database.adapter} />
      ) : null}
      <DatabaseContext.Provider value={state}>{children}</DatabaseContext.Provider>
    </QueryClientProvider>
  );
}

export function useDatabaseState(): DatabaseState {
  return useContext(DatabaseContext);
}

/**
 * The open database, for a screen that only renders once there is one.
 *
 * Throws rather than returning null: every screen below the first-run sync
 * flow is reached only after the database is open, so a null check at each of
 * them would be dead code that still has to be read.
 */
export function useDatabase(): Database {
  const state = useDatabaseState();
  if (state.status !== 'ready') {
    throw new Error(`The database is ${state.status}; render this below a ready guard.`);
  }

  return state.database;
}
