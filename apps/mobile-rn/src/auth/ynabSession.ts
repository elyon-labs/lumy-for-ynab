import { YnabError } from '@lumy/ynab';

import type { Authorizer } from './ynabAuthorize';
import { isExpired, type YnabToken } from './ynabToken';
import {
  exchangeCodeForToken,
  refreshToken as refreshAtEndpoint,
  TokenEndpointError,
  type TokenEndpointOptions,
} from './ynabTokenEndpoint';
import type { YnabTokenStore } from './ynabTokenStore';

/**
 * The YNAB credential, over its whole life.
 *
 * Connecting, refreshing, upgrading to write access, and disconnecting are one
 * object because they are one piece of state: a token on disk. The Flutter
 * app spread this across `YnabAuthHelper`, a Dio interceptor, four use-case
 * classes and a `BehaviorSubject`, and the refresh-on-401 path ended up in the
 * interceptor where nothing could test it.
 *
 * Nothing here is React. The provider above it is a few lines, and this is
 * what the tests drive.
 */

export interface YnabSessionOptions {
  store: YnabTokenStore;
  /** Opens the browser. Stubbed in tests. */
  authorizer: Authorizer;
  endpoint: TokenEndpointOptions;
  authorizeUrl: string;
  /** Defaults to the clock. Supplied by tests, and by nothing else. */
  now?: () => Date;
  /** Called whenever the stored token changes, including when it goes. */
  onTokenChanged?: (token: YnabToken | null) => void;
}

export type ConnectOutcome =
  | { kind: 'connected'; token: YnabToken }
  /** The person backed out of the browser. Nothing changed. */
  | { kind: 'dismissed' };

export interface YnabSession {
  /** Reads the stored token. Call once, at startup. */
  load: () => Promise<YnabToken | null>;
  /** The token in hand, without touching disk or the network. */
  current: () => YnabToken | null;
  connect: (options?: { write?: boolean }) => Promise<ConnectOutcome>;
  disconnect: () => Promise<void>;
  /** A token YNAB will accept, refreshed first if this one has expired. */
  accessToken: () => Promise<string>;
  /** Runs an operation, refreshing and retrying once if YNAB rejects the token. */
  run: <T>(operation: () => Promise<T>) => Promise<T>;
}

export class NotConnectedError extends Error {
  constructor() {
    super('YNAB is not connected.');
    this.name = 'NotConnectedError';
  }
}

export function createYnabSession(options: YnabSessionOptions): YnabSession {
  const now = options.now ?? (() => new Date());
  let token: YnabToken | null = null;

  /**
   * The refresh in flight, if there is one.
   *
   * Sharing it is not an optimisation. YNAB rotates the refresh token on every
   * use, so a second concurrent refresh would present one that has already
   * been spent and be rejected — taking a perfectly good session with it. A
   * sync issues several requests at once, so this is the ordinary case rather
   * than a race.
   */
  let refreshing: Promise<YnabToken> | null = null;

  async function store(next: YnabToken | null): Promise<void> {
    token = next;

    if (next === null) {
      await options.store.clear();
    } else {
      await options.store.write(next);
    }

    options.onTokenChanged?.(next);
  }

  /**
   * Refreshes, once, however many callers ask at the same time.
   *
   * A refresh YNAB rejects means the person revoked Lumy's access in YNAB's
   * own settings, and the stored token is worthless — so it goes, and the app
   * asks them to connect again. Any other failure leaves it alone: the token
   * may still be good and the next attempt may reach the server.
   */
  function refresh(expired: YnabToken): Promise<YnabToken> {
    refreshing ??= (async () => {
      try {
        const next = await refreshAtEndpoint(options.endpoint, expired);
        await store(next);

        return next;
      } catch (error) {
        if (error instanceof TokenEndpointError && error.failure === 'unauthorized') {
          await store(null);
        }

        throw error;
      } finally {
        refreshing = null;
      }
    })();

    return refreshing;
  }

  return {
    async load() {
      token = await options.store.read();
      options.onTokenChanged?.(token);

      return token;
    },

    current: () => token,

    async connect({ write = false } = {}) {
      const outcome = await options.authorizer.authorize({
        authorizeUrl: options.authorizeUrl,
        clientId: options.endpoint.clientId,
        redirectUri: options.endpoint.redirectUri,
        write,
      });

      if (outcome.kind === 'dismissed') return outcome;

      const next = await exchangeCodeForToken(options.endpoint, outcome.code);
      await store(next);

      return { kind: 'connected', token: next };
    },

    disconnect: () => store(null),

    async accessToken() {
      const held = token;
      if (held === null) throw new NotConnectedError();
      if (!isExpired(held, now())) return held.accessToken;

      const next = await refresh(held);

      return next.accessToken;
    },

    /**
     * Runs an operation, and refreshes once if YNAB rejects the token.
     *
     * The expiry check above catches almost everything; this catches the rest
     * — a token YNAB stopped accepting before it was due to expire. One retry,
     * because a second rejection of a freshly minted token is not a staleness
     * problem and looping on it would spend the hourly allowance on nothing.
     */
    async run(operation) {
      try {
        return await operation();
      } catch (error) {
        const held = token;
        if (!(error instanceof YnabError) || error.failure !== 'auth' || held === null) {
          throw error;
        }

        try {
          await refresh(held);
        } catch {
          // Whether the token survived is `refresh`'s decision. Either way the
          // caller gets the rejection it was already dealing with, rather than
          // a second error about the refresh.
          throw error;
        }

        return await operation();
      }
    },
  };
}
