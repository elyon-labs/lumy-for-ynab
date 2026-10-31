import { beforeEach, describe, expect, it } from 'vitest';

import {
  completeAuthFromUrl,
  createAccountApi,
  DELETE_ACCOUNT_FUNCTION,
  type AccountApi,
  type AccountDependencies,
  type AuthError,
} from './account';

/**
 * The account operations, against a stub shaped like the slice of the client
 * they use.
 *
 * Supabase reports failure by returning an `error` rather than throwing, which
 * is the thing most worth asserting here: an operation that forgot to look
 * would report success for a request that failed, and the person would sit
 * waiting for an email nobody sent.
 */

const SCHEME = 'com.brandontrautmann.lumy';

const REDIRECTS = {
  signIn: `${SCHEME}://budget`,
  emailChange: `${SCHEME}://settings/sync-status?email-change-confirmed=true`,
};

interface Call {
  name: string;
  args: unknown;
}

interface Stub {
  deps: AccountDependencies;
  calls: Call[];
  /** Set to make the next call of that name fail. */
  failures: Map<string, AuthError>;
}

function createStub(): Stub {
  const calls: Call[] = [];
  const failures = new Map<string, AuthError>();

  function record(name: string, args: unknown): { error: AuthError | null } {
    calls.push({ name, args });

    return { error: failures.get(name) ?? null };
  }

  return {
    calls,
    failures,
    deps: {
      auth: {
        signInWithOtp: async (credentials) => record('signInWithOtp', credentials),
        exchangeCodeForSession: async (code) => record('exchangeCodeForSession', code),
        updateUser: async (attributes, options) =>
          record('updateUser', { attributes, options }),
        signOut: async () => record('signOut', undefined),
      },
      functions: {
        invoke: async (name, options) => record('invoke', { name, options }),
      },
      table: (name) => ({
        upsert: async (values) => record('upsert', { name, values }),
      }),
      redirects: REDIRECTS,
    },
  };
}

describe('sending a sign-in link', () => {
  let stub: Stub;
  let api: AccountApi;

  beforeEach(() => {
    stub = createStub();
    api = createAccountApi(stub.deps);
  });

  it('asks for the link to come back to the allow-listed redirect', async () => {
    // These URLs are configured in the Supabase project. A path this does not
    // match arrives as an error rather than a session.
    await api.signInWithEmail('someone@example.com');

    expect(stub.calls).toEqual([
      {
        name: 'signInWithOtp',
        args: {
          email: 'someone@example.com',
          options: { emailRedirectTo: REDIRECTS.signIn },
        },
      },
    ]);
  });

  it('trims the address, because a keyboard adds a space', async () => {
    await api.signInWithEmail('  someone@example.com ');

    expect(stub.calls[0].args).toMatchObject({ email: 'someone@example.com' });
  });

  it('throws what Supabase said rather than reporting success', async () => {
    stub.failures.set('signInWithOtp', { message: 'Email rate limit exceeded' });

    await expect(api.signInWithEmail('someone@example.com')).rejects.toThrow(
      'Email rate limit exceeded',
    );
  });
});

describe('changing the email address', () => {
  let stub: Stub;
  let api: AccountApi;

  beforeEach(() => {
    stub = createStub();
    api = createAccountApi(stub.deps);
  });

  it('confirms the new address at the allow-listed redirect', async () => {
    await api.changeEmail('new@example.com');

    expect(stub.calls).toEqual([
      {
        name: 'updateUser',
        args: {
          attributes: { email: 'new@example.com' },
          options: { emailRedirectTo: REDIRECTS.emailChange },
        },
      },
    ]);
  });

  it('throws what Supabase said', async () => {
    stub.failures.set('updateUser', { message: 'A user with this email already exists' });

    await expect(api.changeEmail('taken@example.com')).rejects.toThrow('already exists');
  });
});

describe('deleting the account', () => {
  let stub: Stub;
  let api: AccountApi;

  beforeEach(() => {
    stub = createStub();
    api = createAccountApi(stub.deps);
  });

  it('calls the one function that can, then forgets the session', async () => {
    await api.deleteAccount();

    expect(stub.calls.map((call) => call.name)).toEqual(['invoke', 'signOut']);
    expect(stub.calls[0].args).toEqual({ name: DELETE_ACCOUNT_FUNCTION, options: undefined });
  });

  it('sends nothing with it, so no caller can name another account', async () => {
    // The function reads the account to delete out of the caller's JWT. A body
    // parameter would be a way to delete somebody else's, because nothing
    // re-checks the service role the function runs as.
    await api.deleteAccount();

    expect(stub.calls[0].args).toEqual({ name: DELETE_ACCOUNT_FUNCTION, options: undefined });
  });

  it('stays signed in when the deletion failed', async () => {
    // Otherwise the account is still there and the person is outside it, with
    // no way to see why or to try again.
    stub.failures.set('invoke', { message: 'Internal server error' });

    await expect(api.deleteAccount()).rejects.toThrow('Internal server error');
    expect(stub.calls.map((call) => call.name)).toEqual(['invoke']);
  });
});

describe('the users row', () => {
  it('pairs the Supabase account with the YNAB one, in the column names the table has', async () => {
    const stub = createStub();
    const api = createAccountApi(stub.deps);

    await api.upsertUser({
      id: 'supabase-user',
      email: 'someone@example.com',
      ynabUserId: 'ynab-user',
    });

    expect(stub.calls).toEqual([
      {
        name: 'upsert',
        args: {
          name: 'users',
          values: {
            id: 'supabase-user',
            email: 'someone@example.com',
            ynab_user_id: 'ynab-user',
          },
        },
      },
    ]);
  });
});

describe('a link the app was opened with', () => {
  let stub: Stub;

  beforeEach(() => {
    stub = createStub();
  });

  it('exchanges its code for a session and says where it asked to land', async () => {
    const outcome = await completeAuthFromUrl(
      stub.deps.auth,
      `${SCHEME}://budget?code=one-time-code`,
    );

    expect(outcome).toEqual({ kind: 'signedIn', path: '/budget' });
    expect(stub.calls).toEqual([{ name: 'exchangeCodeForSession', args: 'one-time-code' }]);
  });

  it('keeps the whole path, which is what the email-change link carries', async () => {
    const outcome = await completeAuthFromUrl(
      stub.deps.auth,
      `${SCHEME}://settings/sync-status?email-change-confirmed=true&code=abc`,
    );

    expect(outcome).toEqual({ kind: 'signedIn', path: '/settings/sync-status' });
  });

  it('throws the reason an expired link gives', async () => {
    await expect(
      completeAuthFromUrl(
        stub.deps.auth,
        `${SCHEME}://budget?error=access_denied&error_description=Email%20link%20is%20invalid%20or%20has%20expired`,
      ),
    ).rejects.toThrow('Email link is invalid or has expired');

    expect(stub.calls).toEqual([]);
  });

  it('leaves a link with no code for the router', async () => {
    const outcome = await completeAuthFromUrl(stub.deps.auth, `${SCHEME}://budget`);

    expect(outcome).toEqual({ kind: 'ignored' });
    expect(stub.calls).toEqual([]);
  });

  it('ignores something that is not a link at all', async () => {
    expect(await completeAuthFromUrl(stub.deps.auth, 'budget')).toEqual({ kind: 'ignored' });
  });

  it('throws when the exchange itself fails', async () => {
    stub.failures.set('exchangeCodeForSession', { message: 'invalid request' });

    await expect(
      completeAuthFromUrl(stub.deps.auth, `${SCHEME}://budget?code=stale`),
    ).rejects.toThrow('invalid request');
  });
});
