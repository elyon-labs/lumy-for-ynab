/**
 * Where someone belongs, given what the app knows about them so far.
 *
 * This replaces the imperative `GoRouter.redirect` chain, which read the
 * credentials with two awaits on every navigation and decided from inside the
 * router. Here the decision is a pure function of four values and the router
 * only carries it out, which is the only way it can be tested: `apps/mobile-rn`
 * has no renderer, so a decision that lives inside a component is a decision
 * nothing can assert on.
 *
 * The five values resolve independently and in no guaranteed order — the
 * database is opening, the stored Supabase session is being read, the Keychain
 * is being read, and the selected budget and whether anything has been synced
 * for it are rows in the database that cannot be read until it is open.
 */

/** `DatabaseState['status']`. */
export type DatabaseStatus = 'opening' | 'ready' | 'failed';
/** `AuthState['status']`. */
export type AccountStatus = 'loading' | 'signedOut' | 'signedIn';
/** `YnabAuthState['status']`. */
export type YnabStatus = 'loading' | 'disconnected' | 'connected';

export interface ShellState {
  database: DatabaseStatus;
  account: AccountStatus;
  ynab: YnabStatus;
  /**
   * The chosen budget: `undefined` until the setting has been read, `null`
   * once it has been read and nothing was chosen.
   *
   * The two cannot be collapsed. An unread setting reads as its own default,
   * which for this one is `null` — so without the distinction every cold start
   * would send someone who has already chosen a budget to the picker for as
   * long as the first read takes.
   */
  selectedBudgetId: string | null | undefined;
  /**
   * Whether the selected budget has anything synced: `undefined` until the
   * read lands, `false` once it has and nothing is there.
   *
   * The same distinction `selectedBudgetId` needs, and for the same reason.
   * The answer for an unsynced budget is `false`, which is also what an unread
   * query defaults to — so collapsing the two would send someone who synced
   * months ago to the first-run screen on every cold start, for as long as the
   * read took.
   *
   * It is the absence of `server_knowledge` rows rather than the absence of
   * ledger entries, because a budget with no transactions in it has been
   * synced and has none.
   */
  hasSyncedData: boolean | undefined;
}

/** A step someone has to complete before the shell will render. */
export type OnboardingRoute =
  | '/welcome'
  | '/connect-ynab'
  | '/select-budget'
  | '/first-sync';

export type ShellDecision =
  /** Something is still resolving. Hold the splash screen. */
  | { kind: 'wait' }
  /** The database did not open, so there is nothing to show and no way on. */
  | { kind: 'failed' }
  | { kind: 'onboarding'; path: OnboardingRoute }
  /** Everything the shell needs is in place. */
  | { kind: 'app' };

/**
 * The first thing standing between someone and the shell.
 *
 * The order of these checks is the whole of it, and two of them are load
 * bearing:
 *
 * A loading credential is `wait`, never its signed-out answer. Otherwise a
 * cold start would show the welcome screen for as long as the Keychain read
 * takes and then yank it away from someone who was signed in the whole time.
 *
 * The budget is checked before the sync and only once both credentials are in
 * hand, because the picker's list comes from YNAB. Asking someone to choose a
 * budget before they have connected the account the budgets belong to would
 * show an empty list and no way to fill it, and syncing needs to know which
 * budget to sync.
 *
 * The first sync is last, and it gates the shell rather than rendering inside
 * the Budget tab. That is what keeps `useBudgetId`'s justification true: every
 * screen in the shell is reached only after a budget has been chosen *and*
 * filled, so Reports and the Budget tab never have to tolerate a budget with
 * nothing in it. The screen it sends to carries its own way out — repair,
 * change budget, sign out — because a sync that cannot succeed must not be a
 * locked door.
 */
export function shellDecision(state: ShellState): ShellDecision {
  // First, because every other value below is read from the database or
  // decided against something stored in it.
  if (state.database === 'failed') return { kind: 'failed' };
  if (state.database === 'opening') return { kind: 'wait' };

  if (state.account === 'loading') return { kind: 'wait' };
  if (state.account === 'signedOut') return { kind: 'onboarding', path: '/welcome' };

  if (state.ynab === 'loading') return { kind: 'wait' };
  if (state.ynab === 'disconnected') return { kind: 'onboarding', path: '/connect-ynab' };

  if (state.selectedBudgetId === undefined) return { kind: 'wait' };
  if (state.selectedBudgetId === null) return { kind: 'onboarding', path: '/select-budget' };

  if (state.hasSyncedData === undefined) return { kind: 'wait' };
  if (!state.hasSyncedData) return { kind: 'onboarding', path: '/first-sync' };

  return { kind: 'app' };
}

/**
 * Where to send someone looking at `current` when the chain is asking for
 * `required`, or null to leave them where they are.
 *
 * This is what makes onboarding advance without any screen knowing what comes
 * after it. Connecting YNAB stores a token, the token changes the chain's
 * answer, the answer no longer matches the screen being looked at, and this
 * moves them on — so the connect screen has no success handler to navigate
 * from and no idea that choosing a budget is next.
 *
 * Comparing for equality rather than looking the current route up means a step
 * always matches itself, so a step added later cannot redirect to itself for
 * want of a table entry.
 */
export function onboardingRedirect(
  current: string,
  required: OnboardingRoute,
): OnboardingRoute | null {
  // Sign-in is reached from the welcome screen and completes the same step, so
  // someone typing their email address is not pulled off the screen: the chain
  // answers `/welcome` for the whole time they are signed out.
  const step = current === '/sign-in' ? '/welcome' : current;

  return step === required ? null : required;
}
