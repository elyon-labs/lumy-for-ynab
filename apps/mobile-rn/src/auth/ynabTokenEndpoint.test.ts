import { beforeEach, describe, expect, it } from 'vitest';

import {
  exchangeCodeForToken,
  refreshToken,
  TokenEndpointError,
  type TokenEndpointOptions,
} from './ynabTokenEndpoint';
import type { YnabToken } from './ynabToken';

/**
 * The token server is what turns a code into a token, because the client
 * secret cannot live in the app. What matters here is the shape of the request
 * it reads — it parses the body as a query string — and what each failure
 * means: a refresh YNAB answers 400 to is a revoked grant, not a bad request,
 * and treating it as retryable would leave someone stuck.
 */

const REDIRECT_URI = 'com.brandontrautmann.lumy://oauth';

interface Call {
  url: string;
  method: string | undefined;
  headers: Record<string, string>;
  body: Record<string, string>;
}

interface Stub {
  options: TokenEndpointOptions;
  calls: Call[];
  reply: (status: number, body: unknown) => void;
  fail: (error: unknown) => void;
}

function createStub(): Stub {
  const calls: Call[] = [];
  let next: { status: number; body: unknown } = {
    status: 200,
    body: {
      access_token: 'fresh-access',
      refresh_token: 'fresh-refresh',
      expires_in: 7200,
      created_at: 1_800_000_000,
      scope: 'read-only',
    },
  };
  let thrown: unknown = null;

  const stubFetch: typeof globalThis.fetch = async (input, init) => {
    if (thrown !== null) throw thrown;

    calls.push({
      url: String(input),
      method: init?.method,
      headers: (init?.headers ?? {}) as Record<string, string>,
      body: Object.fromEntries(new URLSearchParams(String(init?.body ?? ''))),
    });

    return new Response(next.body === null ? null : JSON.stringify(next.body), {
      status: next.status,
      headers: { 'Content-Type': 'application/json' },
    });
  };

  return {
    calls,
    reply: (status, body) => {
      next = { status, body };
    },
    fail: (error) => {
      thrown = error;
    },
    options: {
      tokenUrl: 'https://token.lumy.app/token',
      clientId: 'lumy-client',
      redirectUri: REDIRECT_URI,
      fetch: stubFetch,
      appVersion: '2.0.0',
    },
  };
}

function aToken(overrides: Partial<YnabToken> = {}): YnabToken {
  return {
    accessToken: 'stale-access',
    refreshToken: 'stale-refresh',
    expiresIn: 7200,
    createdAt: 1_799_000_000,
    scope: 'read-only',
    ...overrides,
  };
}

describe('exchanging a code', () => {
  let stub: Stub;

  beforeEach(() => {
    stub = createStub();
  });

  it('posts the code form-encoded, which is what the server parses', async () => {
    await exchangeCodeForToken(stub.options, 'the-code');

    expect(stub.calls).toHaveLength(1);
    expect(stub.calls[0].method).toBe('POST');
    expect(stub.calls[0].headers['Content-Type']).toBe('application/x-www-form-urlencoded');
    expect(stub.calls[0].body).toEqual({
      client_id: 'lumy-client',
      code: 'the-code',
      grant_type: 'authorization_code',
      redirect_uri: REDIRECT_URI,
    });
  });

  it('sends no secret, because the app has none', async () => {
    await exchangeCodeForToken(stub.options, 'the-code');

    expect(Object.keys(stub.calls[0].body)).not.toContain('client_secret');
  });

  it('returns the token in the shape the app stores', async () => {
    const token = await exchangeCodeForToken(stub.options, 'the-code');

    expect(token).toEqual({
      accessToken: 'fresh-access',
      refreshToken: 'fresh-refresh',
      expiresIn: 7200,
      createdAt: 1_800_000_000,
      scope: 'read-only',
    });
  });

  it('reads a response with no scope as read-only', async () => {
    // YNAB has been seen to omit it. Read-only denies a write the token might
    // have allowed, where the opposite attempts one YNAB rejects.
    stub.reply(200, {
      access_token: 'a',
      refresh_token: 'r',
      expires_in: 7200,
      created_at: 1_800_000_000,
    });

    expect((await exchangeCodeForToken(stub.options, 'c')).scope).toBe('read-only');
  });
});

describe('a token request that fails', () => {
  let stub: Stub;

  beforeEach(() => {
    stub = createStub();
  });

  it('reports a 400 as unauthorized, because that is the revoked case', async () => {
    // YNAB answers 400 when the grant has been revoked in its own settings.
    // Read as a bad request it would be retried forever against a credential
    // that can never work again.
    stub.reply(400, { error: 'invalid_grant', error_description: 'Grant revoked' });

    await expect(refreshToken(stub.options, aToken())).rejects.toMatchObject({
      failure: 'unauthorized',
      message: 'Grant revoked',
    });
  });

  it('reports a 401 as unauthorized', async () => {
    stub.reply(401, { error: 'invalid_client' });

    await expect(exchangeCodeForToken(stub.options, 'c')).rejects.toMatchObject({
      failure: 'unauthorized',
    });
  });

  it.each([500, 502, 404])('reports %i as unavailable, so the token is kept', async (status) => {
    stub.reply(status, {});

    await expect(exchangeCodeForToken(stub.options, 'c')).rejects.toMatchObject({
      failure: 'unavailable',
    });
  });

  it('reports an unreachable server as unavailable', async () => {
    stub.fail(new TypeError('Network request failed'));

    await expect(exchangeCodeForToken(stub.options, 'c')).rejects.toMatchObject({
      failure: 'unavailable',
    });
  });

  it('reports a 200 that is not a token as malformed', async () => {
    stub.reply(200, { access_token: 'a' });

    await expect(exchangeCodeForToken(stub.options, 'c')).rejects.toMatchObject({
      failure: 'malformed',
    });
  });

  it('is a TokenEndpointError, so the session can tell the cases apart', async () => {
    stub.reply(400, {});

    await expect(exchangeCodeForToken(stub.options, 'c')).rejects.toBeInstanceOf(
      TokenEndpointError,
    );
  });
});

describe('refreshing', () => {
  let stub: Stub;

  beforeEach(() => {
    stub = createStub();
  });

  it('sends the refresh token and the grant type', async () => {
    await refreshToken(stub.options, aToken());

    expect(stub.calls[0].body).toMatchObject({
      client_id: 'lumy-client',
      refresh_token: 'stale-refresh',
      grant_type: 'refresh_token',
      redirect_uri: REDIRECT_URI,
    });
  });

  it('sends the scope, so a write token does not come back read-only', async () => {
    // Otherwise someone who granted write access is sent through the upgrade
    // flow again the first time their token refreshes.
    await refreshToken(stub.options, aToken({ scope: 'read-write' }));

    expect(stub.calls[0].body.scope).toBe('read-write');
  });
});
