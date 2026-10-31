import { writeAccess, type WriteAccess } from '@lumy/ynab';

/**
 * The YNAB token, as the token server reports it.
 *
 * Kept as one record rather than the Flutter app's five separate secure-store
 * entries (`access_token`, `refresh_token`, `expires_in`, `created_at`,
 * `scope`). Five writes are five chances to half-succeed, and its reader had
 * to treat a missing `scope` as read-only to cope with exactly that.
 *
 * `createdAt` and `expiresIn` are seconds, which is what YNAB returns.
 */
export interface YnabToken {
  accessToken: string;
  refreshToken: string;
  /** Seconds the access token is good for, from `createdAt`. */
  expiresIn: number;
  /** Unix seconds. */
  createdAt: number;
  scope: string;
}

/**
 * How early a token is treated as expired.
 *
 * A token that expires during the request carrying it is a 401 and a retry.
 * A minute's margin turns almost all of those into a refresh that happens
 * before the request instead.
 */
export const EXPIRY_MARGIN_SECONDS = 60;

/** Unix seconds at which YNAB stops accepting the access token. */
export function expiresAt(token: YnabToken): number {
  return token.createdAt + token.expiresIn;
}

/** Whether the access token should be refreshed before it is used again. */
export function isExpired(token: YnabToken, now: Date): boolean {
  const seconds = Math.floor(now.getTime() / 1000);

  return seconds + EXPIRY_MARGIN_SECONDS >= expiresAt(token);
}

/**
 * Proof the token can write, or null.
 *
 * The check lives in `@lumy/ynab` so that `createTransaction` can demand the
 * result; this is only where the app's stored scope meets it.
 */
export function tokenWriteAccess(token: YnabToken | null): WriteAccess | null {
  return token === null ? null : writeAccess(token.scope);
}

/** Whether the stored token already carries write access. */
export function canWrite(token: YnabToken | null): boolean {
  return tokenWriteAccess(token) !== null;
}

/**
 * Reads a token back out of what was stored, or reports nothing.
 *
 * Anything that does not decode reads as no token, for the same reason a
 * settings value does: the alternative is an app that cannot launch because of
 * a record some other build wrote. The person reconnects, which is a tap.
 */
export function parseToken(raw: unknown): YnabToken | null {
  if (typeof raw !== 'object' || raw === null) return null;

  const { accessToken, refreshToken, expiresIn, createdAt, scope } = raw as Record<
    string,
    unknown
  >;

  if (typeof accessToken !== 'string' || accessToken === '') return null;
  if (typeof refreshToken !== 'string' || refreshToken === '') return null;
  if (!Number.isFinite(expiresIn) || !Number.isFinite(createdAt)) return null;
  if (typeof scope !== 'string') return null;

  return {
    accessToken,
    refreshToken,
    expiresIn: expiresIn as number,
    createdAt: createdAt as number,
    scope,
  };
}
