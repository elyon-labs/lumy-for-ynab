import { describe, expect, it } from 'vitest';

import {
  onboardingRedirect,
  shellDecision,
  type AccountStatus,
  type DatabaseStatus,
  type OnboardingRoute,
  type ShellState,
  type YnabStatus,
} from './shellDecision';

const DATABASE: DatabaseStatus[] = ['opening', 'ready', 'failed'];
const ACCOUNT: AccountStatus[] = ['loading', 'signedOut', 'signedIn'];
const YNAB: YnabStatus[] = ['loading', 'disconnected', 'connected'];
const BUDGET: ShellState['selectedBudgetId'][] = [undefined, null, 'budget-1'];

/** Every state the four values can be in together. */
function everyState(): ShellState[] {
  return DATABASE.flatMap((database) =>
    ACCOUNT.flatMap((account) =>
      YNAB.flatMap((ynab) =>
        BUDGET.map((selectedBudgetId) => ({ database, account, ynab, selectedBudgetId })),
      ),
    ),
  );
}

const READY: ShellState = {
  database: 'ready',
  account: 'signedIn',
  ynab: 'connected',
  selectedBudgetId: 'budget-1',
};

describe('shellDecision', () => {
  it('covers every combination of the four states', () => {
    expect(everyState()).toHaveLength(81);

    for (const state of everyState()) {
      expect(shellDecision(state).kind).toBeDefined();
    }
  });

  it('lets someone through only when everything is in place', () => {
    for (const state of everyState()) {
      const isComplete =
        state.database === 'ready' &&
        state.account === 'signedIn' &&
        state.ynab === 'connected' &&
        typeof state.selectedBudgetId === 'string';

      expect(shellDecision(state).kind === 'app').toBe(isComplete);
    }
  });

  it('never shows an onboarding screen while a credential is still loading', () => {
    for (const state of everyState()) {
      if (state.account !== 'loading' && state.ynab !== 'loading') continue;
      if (state.database === 'failed') continue;

      // The property that stops a cold start flashing the welcome screen at
      // someone who turns out to be signed in.
      if (state.account === 'loading') {
        expect(shellDecision(state)).toEqual({ kind: 'wait' });
      }
    }
  });

  it('answers a failed database before anything else', () => {
    for (const state of everyState()) {
      if (state.database !== 'failed') continue;

      expect(shellDecision(state)).toEqual({ kind: 'failed' });
    }
  });

  it('waits while the database is opening', () => {
    for (const state of everyState()) {
      if (state.database !== 'opening') continue;

      expect(shellDecision(state)).toEqual({ kind: 'wait' });
    }
  });

  it('sends someone with no account to the welcome screen', () => {
    for (const state of everyState()) {
      if (state.database !== 'ready' || state.account !== 'signedOut') continue;

      // Whatever the YNAB token and the budget say. An unauthenticated person
      // holding a YNAB token is the Flutter app's migration case, and there is
      // no migration path: they sign in normally.
      expect(shellDecision(state)).toEqual({ kind: 'onboarding', path: '/welcome' });
    }
  });

  it('asks for YNAB once there is an account', () => {
    expect(shellDecision({ ...READY, ynab: 'disconnected', selectedBudgetId: null })).toEqual({
      kind: 'onboarding',
      path: '/connect-ynab',
    });

    // Even for someone who already has a budget stored from a previous
    // install, because nothing can be fetched for it without a token.
    expect(shellDecision({ ...READY, ynab: 'disconnected' })).toEqual({
      kind: 'onboarding',
      path: '/connect-ynab',
    });
  });

  it('waits on the budget setting rather than reading its default as a choice', () => {
    expect(shellDecision({ ...READY, selectedBudgetId: undefined })).toEqual({ kind: 'wait' });
    expect(shellDecision({ ...READY, selectedBudgetId: null })).toEqual({
      kind: 'onboarding',
      path: '/select-budget',
    });
  });

  it('asks for a budget only after both credentials are in hand', () => {
    for (const state of everyState()) {
      const decision = shellDecision(state);
      if (decision.kind !== 'onboarding' || decision.path !== '/select-budget') continue;

      expect(state.account).toBe('signedIn');
      expect(state.ynab).toBe('connected');
    }
  });

  it('lets a complete state through', () => {
    expect(shellDecision(READY)).toEqual({ kind: 'app' });
  });
});

describe('onboardingRedirect', () => {
  it('leaves someone on the step they are up to', () => {
    expect(onboardingRedirect('/welcome', '/welcome')).toBeNull();
    expect(onboardingRedirect('/connect-ynab', '/connect-ynab')).toBeNull();
    expect(onboardingRedirect('/select-budget', '/select-budget')).toBeNull();
  });

  it('keeps someone on the sign-in screen while they are signed out', () => {
    // Sign-in completes the welcome step, so the chain still answers
    // `/welcome` for the whole time someone is typing their address.
    expect(onboardingRedirect('/sign-in', '/welcome')).toBeNull();
  });

  it('moves someone on when the step they are looking at is done', () => {
    // Connecting YNAB is what changes the answer; the connect screen itself
    // has no idea what comes next.
    expect(onboardingRedirect('/connect-ynab', '/select-budget')).toBe('/select-budget');
    expect(onboardingRedirect('/sign-in', '/connect-ynab')).toBe('/connect-ynab');
    expect(onboardingRedirect('/welcome', '/connect-ynab')).toBe('/connect-ynab');
  });

  it('sends someone back to the step they skipped', () => {
    expect(onboardingRedirect('/select-budget', '/welcome')).toBe('/welcome');
    expect(onboardingRedirect('/connect-ynab', '/welcome')).toBe('/welcome');
  });

  it('sends an unrecognised screen to the step the chain asks for', () => {
    expect(onboardingRedirect('/budget', '/welcome')).toBe('/welcome');
    expect(onboardingRedirect('', '/connect-ynab')).toBe('/connect-ynab');
  });

  it('never redirects a step to itself', () => {
    // The property that stops a step added later looping for want of an entry
    // in a lookup table.
    const steps: OnboardingRoute[] = ['/welcome', '/connect-ynab', '/select-budget'];

    for (const step of steps) {
      expect(onboardingRedirect(step, step)).toBeNull();
    }
  });
});
