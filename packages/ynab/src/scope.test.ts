import { describe, expect, it } from 'vitest';

import { createYnabClient } from './client';
import { writeAccess, type WriteAccess } from './scope';

const client = createYnabClient({ getAccessToken: () => 'token' });
const draft = { accountId: 'a', date: '2026-10-29', amount: -1000 };

describe('write access', () => {
  it('is refused for a read-only token', () => {
    expect(writeAccess('read-only')).toBeNull();
  });

  it('is refused for an unknown or absent scope', () => {
    expect(writeAccess(null)).toBeNull();
    expect(writeAccess(undefined)).toBeNull();
    expect(writeAccess('   ')).toBeNull();
  });

  it('is granted for a full-access token', () => {
    expect(writeAccess('public')).not.toBeNull();
  });

  it('is refused when read-only appears among several scopes', () => {
    expect(writeAccess('read-only something-else')).toBeNull();
  });

  it('cannot be forged or skipped', () => {
    // The point of the brand: a create that has not been through the scope
    // check does not compile, so the check cannot be left out by accident.
    // @ts-expect-error -- no proof supplied
    void (() => client.createTransaction('b', draft));
    // @ts-expect-error -- a plain object is not proof
    void (() => client.createTransaction('b', draft, {}));
    // @ts-expect-error -- neither is the null a failed check returns
    void (() => client.createTransaction('b', draft, writeAccess('read-only')));

    const granted: WriteAccess | null = writeAccess('public');
    if (granted === null) throw new Error('unreachable');
    void (() => client.createTransaction('b', draft, granted));

    expect(granted).not.toBeNull();
  });
});
