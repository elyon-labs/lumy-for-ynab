import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { AppState } from 'react-native';

import { appConfig } from '@/config';

import { secureStore } from './secureStore';
import { createChunkedStorage } from './sessionStore';

/**
 * The one Supabase client.
 *
 * Created lazily so that importing anything in this folder does not read the
 * config, which a test would then have to provide.
 */
let client: SupabaseClient | null = null;

export function supabase(): SupabaseClient {
  if (client === null) {
    const { supabaseUrl, supabaseAnonKey } = appConfig();

    client = createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        storage: createChunkedStorage(secureStore),
        persistSession: true,
        autoRefreshToken: true,
        // There is no URL bar on a phone. A magic link arrives as a deep link
        // and is exchanged by `completeAuthFromUrl`, which is the one place
        // that happens.
        detectSessionInUrl: false,
        // PKCE rather than the Flutter app's implicit flow. The link then
        // carries a one-time code instead of the tokens themselves, and the
        // code is worthless without the verifier this device kept — so a link
        // sitting in an inbox or a mail provider's link scanner is not a
        // session. The flow only completes on the device that asked for it,
        // which is the only device the app is on anyway.
        flowType: 'pkce',
      },
    });
  }

  return client;
}

/**
 * Keeps the access token fresh while the app is in front.
 *
 * `autoRefreshToken` runs on a timer, and a timer does not fire while the app
 * is suspended. Without this, coming back to a backgrounded app means the
 * first request goes out with an expired token. Returns the function that
 * stops listening.
 */
export function startAutoRefresh(): () => void {
  const auth = supabase().auth;

  const subscription = AppState.addEventListener('change', (state) => {
    if (state === 'active') {
      void auth.startAutoRefresh();
    } else {
      void auth.stopAutoRefresh();
    }
  });

  if (AppState.currentState === 'active') {
    void auth.startAutoRefresh();
  }

  return () => {
    subscription.remove();
    void auth.stopAutoRefresh();
  };
}
