import { migrate, schemaVersion, type DatabaseAdapter } from '@lumy/data';
import { openAppDatabase } from '@lumy/data/expo';
import { useEffect, useState } from 'react';

export interface DatabaseState {
  adapter: DatabaseAdapter | null;
  sqliteVersion: string | null;
  schema: number | null;
  error: Error | null;
}

/**
 * Opens the database and brings it up to the current schema.
 *
 * Temporary: the real thing is a provider the whole app reads from, which
 * arrives with the settings store. This exists so the Expo adapter — the one
 * part of the data package that cannot be covered by the node tests — is
 * exercised on a device.
 */
export function useDatabase(): DatabaseState {
  const [state, setState] = useState<DatabaseState>({
    adapter: null,
    sqliteVersion: null,
    schema: null,
    error: null,
  });

  useEffect(() => {
    let cancelled = false;
    let opened: DatabaseAdapter | null = null;

    void (async () => {
      try {
        const adapter = await openAppDatabase();
        opened = adapter;
        await migrate(adapter);

        const [sqliteVersion, schema] = await Promise.all([
          adapter.sqliteVersion(),
          schemaVersion(adapter),
        ]);

        if (!cancelled) {
          setState({ adapter, sqliteVersion, schema, error: null });
        }
      } catch (error) {
        if (!cancelled) {
          setState({
            adapter: null,
            sqliteVersion: null,
            schema: null,
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
