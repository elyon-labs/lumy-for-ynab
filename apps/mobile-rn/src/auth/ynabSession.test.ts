import { YnabError } from '@lumy/ynab';
import { beforeEach, describe, expect, it } from 'vitest';

import type { KeyValueStore } from './sessionStore';
import type { AuthorizeOptions, Authorizer, AuthorizeOutcome } from './ynabAuthorize';
import { createYnabSession, NotConnectedError, type YnabSession } from './ynabSession';
import type { YnabToken } from './ynabToken';
import { createYnabTokenStore } from './ynabTokenStore';

/**
 * The whole life of the YNAB credential, against a stub browser and a stub
 * token server.
 *
 * The things worth asserting are the ones the Flutter app could not: that a
 * revoked grant throws the token away where a server outage does not, that
 * several callers refreshing at once make one request, and that a rejection
 * YNAB gives mid-sync is retried exactly once.
 */

const CREATED_AT = 1_800_000_000;
const NOW = new Date((CREATED_AT + 100) * 1000);

function aToken(overrides: Partial<YnabToken> = {}): YnabToken {
  return {
    accessToken: 'access-1',
    refreshToken: 'refresh-1',
    expiresIn: 7200,
    createdAt: CREATED_AT,
    scope: 'read-only',
    ...overrides,
  };
}

function createMemoryStore(): KeyValueStore {
  const items = new Map<string, string>();

  return {
    getItem: async (key) => items.get(key) ?? null,
    setItem: async (key, value) => void items.set(key, value),
    removeItem: async (key) => void items.delete(key),
  };
}

interface Harness {
  session: YnabSession;
  /** Every authorize call, so the scope asked for is assertable. */
  authorizations: AuthorizeOptions[];
  /** Every POST to the token server. */
  posts: Record<string, string>[];
  authorizeWith: (outcome: AuthorizeOutcome) => void;
  reply: (status: number, body: unknown) => void;
  /** Lets a reply hang until released, for the concurrency cases. */
  hold: () => () => void;
  states: (YnabToken | null)[];
  store: ReturnType<typeof createYnabTokenStore>;
  now: Date;
  setNow: (when: Date) => void;
}

function createHarness(): Harness {
  const authorizations: AuthorizeOptions[] = [];
  const posts: Record<string, string>[] = [];
  const states: (YnabToken | null)[] = [];
  let outcome: AuthorizeOutcome = { kind: 'authorized', code: 'the-code' };
  let next: { status: number; body: unknown } = {
    status: 200,
    body: {
      access_token: 'access-2',
      refresh_token: 'refresh-2',
      expires_in: 7200,
      created_at: CREATED_AT + 7000,
      scope: 'read-only',
    },
  };
  let gate: Promise<void> | null = null;
  let open: (() => void) | null = null;
  let now = NOW;

  const authorizer: Authorizer = {
    authorize: async (options) => {
      authorizations.push(options);

      return outcome;
    },
  };

  const stubFetch: typeof globalThis.fetch = async (_input, init) => {
    posts.push(Object.fromEntries(new URLSearchParams(String(init?.body ?? ''))));
    if (gate !== null) await gate;

    return new Response(JSON.stringify(next.body), {
      status: next.status,
      headers: { 'Content-Type': 'application/json' },
    });
  };

  const store = createYnabTokenStore(createMemoryStore());

  const session = createYnabSession({
    store,
    authorizer,
    authorizeUrl: 'https://app.ynab.com/oauth/authorize',
    endpoint: {
      tokenUrl: 'https://token.lumy.app/token',
      clientId: 'lumy-client',
      redirectUri: 'com.brandontrautmann.lumy://oauth',
      fetch: stubFetch,
    },
    now: () => now,
    onTokenChanged: (token) => states.push(token),
  });

  return {
    session,
    authorizations,
    posts,
    states,
    store,
    now,
    setNow: (when) => {
      now = when;
    },
    authorizeWith: (value) => {
      outcome = value;
    },
    reply: (status, body) => {
      next = { status, body };
    },
    hold: () => {
      gate = new Promise((resolve) => {
        open = resolve;
      });

      return () => {
        open?.();
        gate = null;
      };
    },
  };
}

/** Writes a token straight to the store, as a previous launch would have. */
async function seedToken(harness: Harness, token: YnabToken): Promise<void> {
  await harness.store.write(token);
  await harness.session.load();
  harness.states.length = 0;
}

describe('connecting', () => {
  let harness: Harness;

  beforeEach(() => {
    harness = createHarness();
  });

  it('asks YNAB for read-only, and keeps the token it gets', async () => {
    const outcome = await harness.session.connect();

    expect(harness.authorizations).toEqual([
      {
        authorizeUrl: 'https://app.ynab.com/oauth/authorize',
        clientId: 'lumy-client',
        redirectUri: 'com.brandontrautmann.lumy://oauth',
        write: false,
      },
    ]);
    expect(outcome).toMatchObject({ kind: 'connected' });
    expect(await harness.store.read()).toMatchObject({ accessToken: 'access-2' });
    expect(harness.session.current()).toMatchObject({ accessToken: 'access-2' });
  });

  it('asks for write access when the upgrade flow runs', async () => {
    await harness.session.connect({ write: true });

    expect(harness.authorizations[0].write).toBe(true);
  });

  it('changes nothing when the person backs out of the browser', async () => {
    harness.authorizeWith({ kind: 'dismissed' });

    expect(await harness.session.connect()).toEqual({ kind: 'dismissed' });
    expect(harness.posts).toEqual([]);
    expect(await harness.store.read()).toBeNull();
    expect(harness.states).toEqual([]);
  });

  it('reports the token change, so the provider follows', async () => {
    await harness.session.connect();

    expect(harness.states).toHaveLength(1);
    expect(harness.states[0]).toMatchObject({ accessToken: 'access-2' });
  });
});

describe('disconnecting', () => {
  it('forgets the token and says so', async () => {
    const harness = createHarness();
    await seedToken(harness, aToken());

    await harness.session.disconnect();

    expect(await harness.store.read()).toBeNull();
    expect(harness.session.current()).toBeNull();
    expect(harness.states).toEqual([null]);
  });
});

describe('getting a token to use', () => {
  let harness: Harness;

  beforeEach(() => {
    harness = createHarness();
  });

  it('refuses when YNAB has never been connected', async () => {
    await expect(harness.session.accessToken()).rejects.toBeInstanceOf(NotConnectedError);
  });

  it('hands back the stored one while it is good', async () => {
    await seedToken(harness, aToken());

    expect(await harness.session.accessToken()).toBe('access-1');
    expect(harness.posts).toEqual([]);
  });

  it('refreshes first when it has expired', async () => {
    await seedToken(harness, aToken());
    harness.setNow(new Date((CREATED_AT + 7200) * 1000));

    expect(await harness.session.accessToken()).toBe('access-2');
    expect(harness.posts).toHaveLength(1);
    expect(harness.posts[0]).toMatchObject({ grant_type: 'refresh_token' });
  });

  it('refreshes once however many callers ask at the same time', async () => {
    // Not an optimisation. YNAB rotates the refresh token on every use, so a
    // second concurrent refresh would present one already spent and be
    // rejected — taking a working session with it. A sync issues several
    // requests at once, so this is the ordinary case.
    await seedToken(harness, aToken());
    harness.setNow(new Date((CREATED_AT + 7200) * 1000));
    const release = harness.hold();

    const asked = Promise.all([
      harness.session.accessToken(),
      harness.session.accessToken(),
      harness.session.accessToken(),
    ]);
    release();

    expect(await asked).toEqual(['access-2', 'access-2', 'access-2']);
    expect(harness.posts).toHaveLength(1);
  });

  it('throws the token away when YNAB says the grant is gone', async () => {
    // A 400 from the token endpoint is access revoked in YNAB's own settings.
    // Keeping it would mean refreshing a dead credential forever.
    await seedToken(harness, aToken());
    harness.setNow(new Date((CREATED_AT + 7200) * 1000));
    harness.reply(400, { error: 'invalid_grant' });

    await expect(harness.session.accessToken()).rejects.toMatchObject({
      failure: 'unauthorized',
    });
    expect(await harness.store.read()).toBeNull();
    expect(harness.states).toEqual([null]);
  });

  it('keeps the token when the refresh merely could not be made', async () => {
    // The server was unreachable or broken. The credential may be perfectly
    // good and the next attempt may work; throwing it away would sign someone
    // out of YNAB over an outage.
    await seedToken(harness, aToken());
    harness.setNow(new Date((CREATED_AT + 7200) * 1000));
    harness.reply(503, {});

    await expect(harness.session.accessToken()).rejects.toMatchObject({
      failure: 'unavailable',
    });
    expect(await harness.store.read()).toMatchObject({ accessToken: 'access-1' });
    expect(harness.states).toEqual([]);
  });

  it('can refresh again after one failed', async () => {
    await seedToken(harness, aToken());
    harness.setNow(new Date((CREATED_AT + 7200) * 1000));
    harness.reply(503, {});
    await expect(harness.session.accessToken()).rejects.toMatchObject({ failure: 'unavailable' });

    harness.reply(200, {
      access_token: 'access-3',
      refresh_token: 'refresh-3',
      expires_in: 7200,
      created_at: CREATED_AT + 7000,
      scope: 'read-only',
    });

    expect(await harness.session.accessToken()).toBe('access-3');
  });
});

describe('an operation YNAB rejects the token for', () => {
  let harness: Harness;

  beforeEach(async () => {
    harness = createHarness();
    await seedToken(harness, aToken());
  });

  /** An operation that fails `failures` times before succeeding. */
  function operation(failures: number, error: unknown = new YnabError('auth', '401')) {
    let attempts = 0;

    return {
      get attempts() {
        return attempts;
      },
      run: async () => {
        attempts += 1;
        if (attempts <= failures) throw error;

        return 'the answer';
      },
    };
  }

  it('is refreshed and retried once', async () => {
    const op = operation(1);

    expect(await harness.session.run(op.run)).toBe('the answer');
    expect(op.attempts).toBe(2);
    expect(harness.posts).toHaveLength(1);
  });

  it('is not retried twice, so a rejection cannot loop', async () => {
    // A second rejection of a freshly minted token is not staleness, and
    // looping on it would spend the hourly allowance on nothing.
    const op = operation(5);

    await expect(harness.session.run(op.run)).rejects.toMatchObject({ failure: 'auth' });
    expect(op.attempts).toBe(2);
    expect(harness.posts).toHaveLength(1);
  });

  it('is left alone when the failure is not about the token', async () => {
    const op = operation(1, new YnabError('rateLimit', '429'));

    await expect(harness.session.run(op.run)).rejects.toMatchObject({ failure: 'rateLimit' });
    expect(op.attempts).toBe(1);
    expect(harness.posts).toEqual([]);
  });

  it('is left alone when the failure is not a YNAB error at all', async () => {
    const op = operation(1, new TypeError('Network request failed'));

    await expect(harness.session.run(op.run)).rejects.toBeInstanceOf(TypeError);
    expect(op.attempts).toBe(1);
  });

  it('reports the rejection, not the refresh, when the refresh also fails', async () => {
    // The caller was already dealing with a 401; a second error about the
    // token server tells them less, not more.
    harness.reply(503, {});
    const op = operation(1);

    await expect(harness.session.run(op.run)).rejects.toMatchObject({ failure: 'auth' });
    expect(op.attempts).toBe(1);
  });

  it('disconnects when the refresh says the grant is gone', async () => {
    harness.reply(400, { error: 'invalid_grant' });
    const op = operation(1);

    await expect(harness.session.run(op.run)).rejects.toMatchObject({ failure: 'auth' });
    expect(await harness.store.read()).toBeNull();
  });

  it('succeeds without touching the token server when nothing failed', async () => {
    const op = operation(0);

    expect(await harness.session.run(op.run)).toBe('the answer');
    expect(op.attempts).toBe(1);
    expect(harness.posts).toEqual([]);
  });
});

describe('loading at startup', () => {
  it('reads the stored token and reports it', async () => {
    const harness = createHarness();
    await harness.store.write(aToken());

    expect(await harness.session.load()).toMatchObject({ accessToken: 'access-1' });
    expect(harness.states).toEqual([expect.objectContaining({ accessToken: 'access-1' })]);
  });

  it('reports nothing stored, so the app shows the connect screen', async () => {
    const harness = createHarness();

    expect(await harness.session.load()).toBeNull();
    expect(harness.states).toEqual([null]);
  });
});
