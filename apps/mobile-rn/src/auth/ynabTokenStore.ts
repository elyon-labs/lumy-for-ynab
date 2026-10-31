import { parseToken, type YnabToken } from './ynabToken';
import { createChunkedStorage, type KeyValueStore } from './sessionStore';

/**
 * Where the YNAB token lives.
 *
 * The same credential store as the Supabase session, through the same chunked
 * storage. A YNAB token record is small enough for one Keychain entry today,
 * but going through the one adapter means there is no second answer to the
 * question of how a credential is written — and nothing to revisit if YNAB's
 * tokens grow.
 */

export const YNAB_TOKEN_KEY = 'lumy.ynab.token';

export interface YnabTokenStore {
  read: () => Promise<YnabToken | null>;
  write: (token: YnabToken) => Promise<void>;
  clear: () => Promise<void>;
}

export function createYnabTokenStore(store: KeyValueStore): YnabTokenStore {
  const storage = createChunkedStorage(store);

  return {
    async read() {
      const raw = await storage.getItem(YNAB_TOKEN_KEY);
      if (raw === null) return null;

      try {
        return parseToken(JSON.parse(raw));
      } catch {
        // Not JSON. Reads as no token, so the next connect writes a whole one.
        return null;
      }
    },

    write: (token) => storage.setItem(YNAB_TOKEN_KEY, JSON.stringify(token)),

    clear: () => storage.removeItem(YNAB_TOKEN_KEY),
  };
}
