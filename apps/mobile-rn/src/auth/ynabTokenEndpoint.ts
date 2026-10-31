import type { YnabToken } from './ynabToken';

/**
 * Lumy's own token server, which is the only thing that can mint a YNAB token.
 *
 * YNAB's token endpoint needs the client secret, and a mobile app cannot keep
 * one — so `apps/server` holds it and this app posts a code or a refresh token
 * to that server instead. Nothing here sends a secret, and there is none to
 * send.
 *
 * The body is form-encoded because that is what the server reads: it takes the
 * request body as a string and runs `Uri.splitQueryString` over it.
 */

export interface TokenEndpointOptions {
  tokenUrl: string;
  clientId: string;
  /** Must be the URI YNAB has allow-listed, or YNAB rejects the exchange. */
  redirectUri: string;
  fetch?: typeof globalThis.fetch;
  /** The app's version, which the server logs. */
  appVersion?: string;
}

/** Why a token request failed, in the terms the caller acts on. */
export type TokenFailure =
  /**
   * YNAB will not honour the credential. For a refresh this is the revoked
   * case and the stored token is worthless — it has to be thrown away rather
   * than retried. The server answers 400 for a revoked grant and 401 for a
   * rejected one, and both mean the same thing here.
   */
  | 'unauthorized'
  /** The server or the network. The stored token may still be good. */
  | 'unavailable'
  /** A 200 whose body is not a token. A bug worth seeing. */
  | 'malformed';

export class TokenEndpointError extends Error {
  constructor(
    readonly failure: TokenFailure,
    message: string,
    readonly options: { status?: number; cause?: unknown } = {},
  ) {
    super(message, { cause: options.cause });
    this.name = 'TokenEndpointError';
  }
}

interface TokenResponseBody {
  access_token?: unknown;
  refresh_token?: unknown;
  expires_in?: unknown;
  created_at?: unknown;
  scope?: unknown;
  error?: unknown;
  error_description?: unknown;
}

function toToken(body: TokenResponseBody): YnabToken {
  const { access_token, refresh_token, expires_in, created_at, scope } = body;

  if (
    typeof access_token !== 'string' ||
    typeof refresh_token !== 'string' ||
    !Number.isFinite(expires_in) ||
    !Number.isFinite(created_at)
  ) {
    throw new TokenEndpointError('malformed', 'The token server returned an unusable token.');
  }

  return {
    accessToken: access_token,
    refreshToken: refresh_token,
    expiresIn: expires_in as number,
    createdAt: created_at as number,
    // YNAB omits `scope` on some responses, and the Flutter app read that as
    // read-only. Read-only is the safe reading: it denies a write the token
    // might have allowed, where the opposite would attempt one YNAB rejects.
    scope: typeof scope === 'string' ? scope : 'read-only',
  };
}

function failureForStatus(status: number): TokenFailure {
  // The server forwards YNAB's status. A revoked grant comes back as 400,
  // which is why it cannot be treated as an ordinary bad request.
  if (status === 400 || status === 401) return 'unauthorized';

  return 'unavailable';
}

async function post(
  options: TokenEndpointOptions,
  body: Record<string, string>,
): Promise<YnabToken> {
  const doFetch = options.fetch ?? globalThis.fetch;
  const headers: Record<string, string> = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  if (options.appVersion !== undefined) headers['X-App-Version'] = options.appVersion;

  let response: Response;
  try {
    response = await doFetch(options.tokenUrl, {
      method: 'POST',
      headers,
      body: new URLSearchParams(body).toString(),
    });
  } catch (cause) {
    throw new TokenEndpointError('unavailable', 'Could not reach the token server.', { cause });
  }

  const payload = (await response.json().catch(() => null)) as TokenResponseBody | null;

  if (!response.ok) {
    const description =
      payload !== null && typeof payload.error_description === 'string'
        ? payload.error_description
        : `The token server returned ${response.status}.`;

    throw new TokenEndpointError(failureForStatus(response.status), description, {
      status: response.status,
    });
  }

  if (payload === null) {
    throw new TokenEndpointError('malformed', 'The token server returned no body.');
  }

  return toToken(payload);
}

/** Turns the code from the browser redirect into a token. */
export function exchangeCodeForToken(
  options: TokenEndpointOptions,
  code: string,
): Promise<YnabToken> {
  return post(options, {
    client_id: options.clientId,
    code,
    grant_type: 'authorization_code',
    redirect_uri: options.redirectUri,
  });
}

/**
 * Trades the refresh token for a new access token.
 *
 * The scope is sent along so the refreshed token keeps the access the person
 * granted: a write-scoped token that came back read-only would send someone
 * through the upgrade flow again for no reason.
 */
export function refreshToken(
  options: TokenEndpointOptions,
  token: YnabToken,
): Promise<YnabToken> {
  return post(options, {
    client_id: options.clientId,
    refresh_token: token.refreshToken,
    grant_type: 'refresh_token',
    redirect_uri: options.redirectUri,
    scope: token.scope,
  });
}
