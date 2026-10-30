/**
 * YNAB's OAuth scopes.
 *
 * A token is issued either read-only or with full access. Lumy asks for
 * read-only on first connect and upgrades only when a template is about to
 * create a transaction, so most installs never hold a token that can write.
 */
export const READ_ONLY_SCOPE = 'read-only';

declare const writeAccessBrand: unique symbol;

/**
 * Proof that the token in hand can write.
 *
 * `createTransaction` takes one of these, and the only way to get one is to
 * pass the token's scope through `writeAccess()`. The check cannot be
 * forgotten, because without it there is no value to pass — a request YNAB
 * would reject with `403.3` does not compile.
 */
export interface WriteAccess {
  readonly [writeAccessBrand]: true;
}

/**
 * Grants write access if the scope carries it, and null otherwise.
 *
 * YNAB reports a read-only token as the scope string `read-only`; anything
 * else is a full-access token.
 */
export function writeAccess(scope: string | null | undefined): WriteAccess | null {
  if (scope === null || scope === undefined) return null;

  const scopes = scope.split(/\s+/).filter((part) => part.length > 0);
  if (scopes.length === 0 || scopes.includes(READ_ONLY_SCOPE)) return null;

  return {} as WriteAccess;
}
