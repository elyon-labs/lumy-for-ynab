import * as Linking from 'expo-linking';
import { createContext, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';

import { appConfig } from '@/config';

import { createAccountApi, type AccountApi } from './account';
import { startAutoRefresh, supabase } from './supabase';

/**
 * Who is signed in, and what can be done about it.
 *
 * One context, driven by `onAuthStateChange`. The Flutter app combined that
 * stream with the YNAB token stream into a single `User` union, so every
 * consumer of either had to reason about both; here the YNAB token is PR 16's
 * concern and this says only who the Supabase account is.
 */

export interface Account {
  userId: string;
  email: string | null;
  /** Set between asking for an email change and confirming it. */
  pendingEmail: string | null;
}

export type AuthState =
  | { status: 'loading' }
  | { status: 'signedOut' }
  | { status: 'signedIn'; account: Account };

export interface AuthValue {
  state: AuthState;
  api: AccountApi;
  /** The most recent emailed link that could not be completed. */
  linkError: string | null;
  dismissLinkError: () => void;
}

const AuthContext = createContext<AuthValue | null>(null);

interface SessionUser {
  id: string;
  email?: string;
  new_email?: string;
}

function toAccount(user: SessionUser): Account {
  return {
    userId: user.id,
    email: user.email ?? null,
    pendingEmail: user.new_email ?? null,
  };
}

/** The account API, pointed at the real client. */
function createApi(): AccountApi {
  const client = supabase();
  const { deepLinkScheme } = appConfig();

  return createAccountApi({
    auth: client.auth,
    functions: client.functions,
    table: (name) => ({
      upsert: async (values) => {
        const { error } = await client.from(name).upsert(values);

        return { error };
      },
    }),
    // Unchanged from the Flutter app, because these are the URLs allow-listed
    // in the Supabase project. A new path means changing that first.
    redirects: {
      signIn: `${deepLinkScheme}://budget`,
      emailChange: `${deepLinkScheme}://settings/sync-status?email-change-confirmed=true`,
    },
  });
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const api = useMemo(() => createApi(), []);
  const [state, setState] = useState<AuthState>({ status: 'loading' });
  const [linkError, setLinkError] = useState<string | null>(null);

  useEffect(() => {
    const auth = supabase().auth;

    // The stored session, which is what makes signing in a one-time act.
    void auth.getSession().then(({ data }) => {
      setState(
        data.session === null
          ? { status: 'signedOut' }
          : { status: 'signedIn', account: toAccount(data.session.user) },
      );
    });

    const { data } = auth.onAuthStateChange((_event, session) => {
      setState(
        session === null
          ? { status: 'signedOut' }
          : { status: 'signedIn', account: toAccount(session.user) },
      );
    });

    const stopRefreshing = startAutoRefresh();

    return () => {
      data.subscription.unsubscribe();
      stopRefreshing();
    };
  }, []);

  // A magic link arrives as a deep link, on a cold start through
  // `getInitialURL` and afterwards through the listener. Both go to the same
  // place, and a link that carries no code is left for the router.
  useEffect(() => {
    let cancelled = false;

    async function complete(url: string | null): Promise<void> {
      if (url === null) return;

      try {
        await api.completeAuthFromUrl(url);
      } catch (error) {
        if (!cancelled) {
          setLinkError(error instanceof Error ? error.message : String(error));
        }
      }
    }

    void Linking.getInitialURL().then(complete);
    const subscription = Linking.addEventListener('url', ({ url }) => void complete(url));

    return () => {
      cancelled = true;
      subscription.remove();
    };
  }, [api]);

  const value = useMemo<AuthValue>(
    () => ({ state, api, linkError, dismissLinkError: () => setLinkError(null) }),
    [state, api, linkError],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthValue {
  const value = useContext(AuthContext);
  if (!value) {
    throw new Error('useAuth must be called inside an AuthProvider.');
  }

  return value;
}

/**
 * The signed-in account, for a screen that only renders once there is one.
 *
 * Throws rather than returning null, for the same reason `useDatabase` does:
 * every screen behind the auth redirect is reached only with an account, so a
 * null check at each of them would be dead code that still has to be read.
 */
export function useAccount(): Account {
  const { state } = useAuth();
  if (state.status !== 'signedIn') {
    throw new Error(`Nobody is signed in (${state.status}); render this below an auth guard.`);
  }

  return state.account;
}
