import { describe, expect, it } from 'vitest';

import { pairingToWrite } from './pairing';

/**
 * Either id can arrive first — somebody can connect YNAB before signing in, or
 * the other way round — so what matters is whether anything new is known, not
 * which step noticed.
 */

const ACCOUNT = 'supabase-user';
const YNAB = 'ynab-user';

describe('the pairing to write', () => {
  it('is both ids once both are known', () => {
    expect(pairingToWrite({ accountId: ACCOUNT, ynabUserId: YNAB, lastWritten: null })).toEqual({
      id: ACCOUNT,
      ynabUserId: YNAB,
    });
  });

  it('is nothing while only one is known', () => {
    // `ynab_user_id` is not nullable, so there is no row to write yet.
    expect(pairingToWrite({ accountId: ACCOUNT, ynabUserId: null, lastWritten: null })).toBeNull();
    expect(pairingToWrite({ accountId: null, ynabUserId: YNAB, lastWritten: null })).toBeNull();
    expect(pairingToWrite({ accountId: null, ynabUserId: null, lastWritten: null })).toBeNull();
  });

  it('is nothing when it is what was already written', () => {
    expect(
      pairingToWrite({
        accountId: ACCOUNT,
        ynabUserId: YNAB,
        lastWritten: { id: ACCOUNT, ynabUserId: YNAB },
      }),
    ).toBeNull();
  });

  it('is written again when the account changes', () => {
    // Signing out and in as somebody else on the same device.
    expect(
      pairingToWrite({
        accountId: 'another-user',
        ynabUserId: YNAB,
        lastWritten: { id: ACCOUNT, ynabUserId: YNAB },
      }),
    ).toEqual({ id: 'another-user', ynabUserId: YNAB });
  });

  it('is written again when the YNAB account changes', () => {
    expect(
      pairingToWrite({
        accountId: ACCOUNT,
        ynabUserId: 'another-ynab-user',
        lastWritten: { id: ACCOUNT, ynabUserId: YNAB },
      }),
    ).toEqual({ id: ACCOUNT, ynabUserId: 'another-ynab-user' });
  });
});
