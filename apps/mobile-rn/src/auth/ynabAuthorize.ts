import { READ_ONLY_SCOPE } from '@lumy/ynab';

/**
 * Sending the person to YNAB and getting a code back.
 *
 * What the flow means is here; the browser that performs it is in
 * `ynabBrowser.ts`, which is the only module naming `expo-auth-session` — so
 * everything around it is testable without a device, as with the Keychain.
 *
 * There is no PKCE, and deliberately. The Flutter app's `_pkceState` is named
 * for it but is only the `state` parameter; the code is exchanged by Lumy's
 * token server using the client secret, and neither that server nor YNAB's
 * token endpoint accepts a `code_verifier`. Sending a `code_challenge` that
 * nothing verifies would look like protection without being any.
 */

/** What came back from the browser. */
export type AuthorizeOutcome =
  | { kind: 'authorized'; code: string }
  /** The person closed the browser or pressed cancel. Not an error. */
  | { kind: 'dismissed' };

export interface AuthorizeOptions {
  authorizeUrl: string;
  clientId: string;
  /** Must be what YNAB has allow-listed for this OAuth application. */
  redirectUri: string;
  /** Asks for a token that can create transactions. */
  write: boolean;
}

/**
 * Opens the browser, or whatever stands in for it.
 *
 * An interface because the browser is the one part of this that cannot run
 * outside a device, and everything around it — the scope asked for, what a
 * dismissal means, what an error says — can then be tested.
 */
export interface Authorizer {
  authorize: (options: AuthorizeOptions) => Promise<AuthorizeOutcome>;
}

/**
 * The scope asked for.
 *
 * YNAB grants full access unless `read-only` is asked for explicitly, so the
 * write case is the one that sends no scope at all. Lumy asks for read-only on
 * first connect and upgrades only when a template is about to create a
 * transaction, so most installs never hold a token that can write.
 */
export function scopesFor(write: boolean): string[] {
  return write ? [] : [READ_ONLY_SCOPE];
}
