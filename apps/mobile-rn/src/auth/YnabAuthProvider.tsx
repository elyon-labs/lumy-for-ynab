import { Settings } from '@lumy/data';
import { createYnabClient, type YnabClient } from '@lumy/ynab';
import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from 'react';

import { appConfig } from '@/config';
import { useSetting } from '@/settings';

import { useAuth } from './AuthProvider';
import { pairingToWrite, type Pairing } from './pairing';
import { secureStore } from './secureStore';
import { systemBrowserAuthorizer } from './ynabBrowser';
import { createYnabSession, type ConnectOutcome, type YnabSession } from './ynabSession';
import { canWrite, type YnabToken } from './ynabToken';
import { createYnabTokenStore } from './ynabTokenStore';

/**
 * Whether Lumy can read the person's budget, and whether it can write to it.
 *
 * Separate from `AuthProvider`, which says who they are to Lumy. The Flutter
 * app combined the two into one `User` union whose `accessToken` an
 * unauthenticated user could also hold, and every consumer of either had to
 * reason about both.
 */

export type YnabAuthState =
  | { status: 'loading' }
  | { status: 'disconnected' }
  | { status: 'connected'; canWrite: boolean };

export interface YnabAuthValue {
  state: YnabAuthState;
  /** Sends the person to YNAB. `write` asks for permission to create transactions. */
  connect: (options?: { write?: boolean }) => Promise<ConnectOutcome>;
  disconnect: () => Promise<void>;
  /**
   * A client that refreshes the token when YNAB rejects it.
   *
   * Null until YNAB is connected. The sync engine takes this.
   */
  client: YnabClient | null;
}

const YnabAuthContext = createContext<YnabAuthValue | null>(null);

/** The YNAB session, pointed at the real browser and the real Keychain. */
function createSession(onTokenChanged: (token: YnabToken | null) => void): YnabSession {
  const { ynabClientId, ynabAuthorizeUrl, ynabTokenUrl, deepLinkScheme } = appConfig();

  return createYnabSession({
    store: createYnabTokenStore(secureStore),
    authorizer: systemBrowserAuthorizer,
    authorizeUrl: ynabAuthorizeUrl,
    endpoint: {
      tokenUrl: ynabTokenUrl,
      clientId: ynabClientId,
      // Unchanged from the Flutter app, because this is the URI YNAB has
      // allow-listed for the OAuth application. A new one means changing that
      // first, or YNAB refuses the exchange.
      redirectUri: `${deepLinkScheme}://oauth`,
    },
    onTokenChanged,
  });
}

export function YnabAuthProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<YnabAuthState>({ status: 'loading' });

  const session = useMemo(
    () =>
      createSession((token) => {
        setState(
          token === null
            ? { status: 'disconnected' }
            : { status: 'connected', canWrite: canWrite(token) },
        );
      }),
    [],
  );

  useEffect(() => {
    void session.load();
  }, [session]);

  // One client for the life of the session: `getAccessToken` is a callback, so
  // a refreshed token takes effect without rebuilding it.
  const client = useMemo<YnabClient>(
    () => createYnabClient({ getAccessToken: () => session.accessToken() }),
    [session],
  );

  const value = useMemo<YnabAuthValue>(
    () => ({
      state,
      connect: (options) => session.connect(options),
      disconnect: () => session.disconnect(),
      client: state.status === 'connected' ? client : null,
    }),
    [state, session, client],
  );

  return (
    <YnabAuthContext.Provider value={value}>
      <LearnYnabUser session={session} client={client} connected={state.status === 'connected'} />
      <PairAccounts />
      {children}
    </YnabAuthContext.Provider>
  );
}

/**
 * Asks YNAB who the token belongs to, once.
 *
 * `GET /user` is the cheapest call there is and the only way to learn the id
 * the `users` row needs. It runs through `session.run`, so a token YNAB has
 * stopped accepting is refreshed rather than reported as a failure to connect.
 */
function LearnYnabUser({
  session,
  client,
  connected,
}: {
  session: YnabSession;
  client: YnabClient;
  connected: boolean;
}): null {
  const { value: ynabUserId, setValue: setYnabUserId } = useSetting(Settings.ynabUserId);
  const asking = useRef(false);

  useEffect(() => {
    if (!connected || ynabUserId !== null || asking.current) return;

    asking.current = true;
    void (async () => {
      try {
        const user = await session.run(() => client.getUser());
        await setYnabUserId(user.id);
      } catch {
        // Nothing here is worth interrupting the app for: the id is needed to
        // pair the accounts, and the next launch asks again.
      } finally {
        asking.current = false;
      }
    })();
  }, [connected, ynabUserId, session, client, setYnabUserId]);

  return null;
}

/** Writes the `users` row once both ids are known. */
function PairAccounts(): null {
  const { state, api } = useAuth();
  const { value: ynabUserId } = useSetting(Settings.ynabUserId);
  const written = useRef<Pairing | null>(null);

  const accountId = state.status === 'signedIn' ? state.account.userId : null;
  const email = state.status === 'signedIn' ? state.account.email : null;

  useEffect(() => {
    const pairing = pairingToWrite({ accountId, ynabUserId, lastWritten: written.current });
    if (pairing === null) return;

    void (async () => {
      try {
        await api.upsertUser({ ...pairing, email });
        written.current = pairing;
      } catch {
        // Retried on the next change to either id, or the next launch. A row
        // that is not there costs nothing until another device signs in.
      }
    })();
  }, [accountId, email, ynabUserId, api]);

  return null;
}

export function useYnabAuth(): YnabAuthValue {
  const value = useContext(YnabAuthContext);
  if (!value) {
    throw new Error('useYnabAuth must be called inside a YnabAuthProvider.');
  }

  return value;
}

/**
 * The YNAB client, for a screen that only renders once there is one.
 *
 * Throws rather than returning null, for the same reason `useDatabase` does:
 * every screen behind the connect guard has a token.
 */
export function useYnabClient(): YnabClient {
  const { client } = useYnabAuth();
  if (client === null) {
    throw new Error('YNAB is not connected; render this below a connect guard.');
  }

  return client;
}
