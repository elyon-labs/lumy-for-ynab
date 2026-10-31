/**
 * Everything the app does to an account.
 *
 * Supabase reports failure by returning an `error` rather than throwing, which
 * is easy to forget at a call site and silent when you do — the Flutter app
 * wrapped every call in a `Result` for the same reason. Here each operation
 * throws instead, so a mutation's error state is the error and nothing has to
 * remember to look.
 *
 * The dependencies are declared as the narrowest interfaces that cover what is
 * called, so a test drives a plain object and the real client is checked
 * against them structurally where it is passed in.
 */

export interface AuthError {
  message: string;
}

interface AuthResult {
  error: AuthError | null;
}

export interface SupabaseAuthSlice {
  signInWithOtp(credentials: {
    email: string;
    options?: { emailRedirectTo?: string; shouldCreateUser?: boolean };
  }): Promise<AuthResult>;
  exchangeCodeForSession(code: string): Promise<AuthResult>;
  updateUser(
    attributes: { email?: string },
    options?: { emailRedirectTo?: string },
  ): Promise<AuthResult>;
  signOut(): Promise<AuthResult>;
}

export interface SupabaseFunctionsSlice {
  invoke(name: string, options?: { body?: unknown }): Promise<{ error: AuthError | null }>;
}

export interface SupabaseTableSlice {
  upsert(values: Record<string, unknown>): Promise<{ error: AuthError | null }>;
}

export interface AccountDependencies {
  auth: SupabaseAuthSlice;
  functions: SupabaseFunctionsSlice;
  table: (name: string) => SupabaseTableSlice;
  /**
   * Where an emailed link comes back to.
   *
   * These paths are unchanged from the Flutter app because they are
   * allow-listed in the Supabase project's redirect configuration. Changing
   * one means changing that first, or the link arrives as an error.
   */
  redirects: { signIn: string; emailChange: string };
}

function raise(result: { error: AuthError | null }): void {
  if (result.error !== null) throw new Error(result.error.message);
}

/** The name of the Edge Function that can actually delete an account. */
export const DELETE_ACCOUNT_FUNCTION = 'delete-account';

/** What a link the app was opened with turned out to be. */
export type AuthLinkOutcome =
  | { kind: 'ignored' }
  /** A session was established. `path` is where the link asked to land. */
  | { kind: 'signedIn'; path: string };

export interface AccountApi {
  /** Emails a sign-in link. Nothing happens until it is opened. */
  signInWithEmail: (email: string) => Promise<void>;
  /** Exchanges the code in a link for a session, if the link carries one. */
  completeAuthFromUrl: (url: string) => Promise<AuthLinkOutcome>;
  signOut: () => Promise<void>;
  /** Emails a confirmation. The address does not change until it is opened. */
  changeEmail: (email: string) => Promise<void>;
  deleteAccount: () => Promise<void>;
  upsertUser: (user: { id: string; email: string | null; ynabUserId: string }) => Promise<void>;
}

export function createAccountApi(deps: AccountDependencies): AccountApi {
  return {
    async signInWithEmail(email) {
      raise(
        await deps.auth.signInWithOtp({
          email: email.trim(),
          options: { emailRedirectTo: deps.redirects.signIn },
        }),
      );
    },

    completeAuthFromUrl: (url) => completeAuthFromUrl(deps.auth, url),

    async signOut() {
      raise(await deps.auth.signOut());
    },

    async changeEmail(email) {
      raise(
        await deps.auth.updateUser(
          { email: email.trim() },
          { emailRedirectTo: deps.redirects.emailChange },
        ),
      );
    },

    /**
     * Deletes the account, then forgets the session.
     *
     * The deletion itself is an Edge Function, because nothing a client holds
     * can do it: there is no delete policy on `users`, and removing the row in
     * `auth.users` needs the service role. Signing out comes second — if the
     * function fails, the person is still signed in and can see why.
     */
    async deleteAccount() {
      raise(await deps.functions.invoke(DELETE_ACCOUNT_FUNCTION));
      raise(await deps.auth.signOut());
    },

    /**
     * The `users` row, which pairs a Supabase account with a YNAB one.
     *
     * `ynab_user_id` is not nullable, so this cannot be written before the
     * YNAB account is known — PR 16 is what learns it and what calls this.
     */
    async upsertUser({ id, email, ynabUserId }) {
      raise(
        await deps.table('users').upsert({ id, email, ynab_user_id: ynabUserId }),
      );
    },
  };
}

/**
 * Reads a deep link and finishes the sign-in it belongs to.
 *
 * `detectSessionInUrl` is off, because a phone has no URL bar and the client's
 * own detection is written for one. A link therefore arrives here, and this is
 * the only place a session is established from one.
 *
 * A link carrying `error_description` is the expired-or-reused case, and the
 * message is Supabase's own — it already says "Email link is invalid or has
 * expired", which is more use than anything this could write. A link with
 * neither a code nor an error is some other deep link and is left alone.
 */
export async function completeAuthFromUrl(
  auth: SupabaseAuthSlice,
  url: string,
): Promise<AuthLinkOutcome> {
  const parsed = parseUrl(url);
  if (parsed === null) return { kind: 'ignored' };

  const error = parsed.params.get('error_description') ?? parsed.params.get('error');
  if (error !== null) throw new Error(error);

  const code = parsed.params.get('code');
  if (code === null) return { kind: 'ignored' };

  raise(await auth.exchangeCodeForSession(code));

  return { kind: 'signedIn', path: parsed.path };
}

/**
 * Splits a deep link into the path it asked for and its parameters.
 *
 * `URL` does not give a useful pathname for a custom scheme — `lumy://budget`
 * puts `budget` in the host on some engines and the path on others — so the
 * link is split on its own punctuation instead. Nothing here needs the scheme:
 * the only links reaching this are the app's own.
 */
function parseUrl(url: string): { path: string; params: URLSearchParams } | null {
  const afterScheme = url.split('://')[1];
  if (afterScheme === undefined) return null;

  const [beforeQuery, query = ''] = afterScheme.split('?');
  const path = `/${beforeQuery.replace(/^\/+|\/+$/g, '')}`;

  return { path, params: new URLSearchParams(query) };
}
