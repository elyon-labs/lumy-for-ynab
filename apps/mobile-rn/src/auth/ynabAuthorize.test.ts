import { describe, expect, it } from 'vitest';

import { scopesFor } from './ynabAuthorize';

/**
 * YNAB grants full access unless `read-only` is asked for explicitly, so the
 * write case is the one that sends no scope at all. Getting this backwards
 * would hand every install a token that can write.
 */
describe('the scope asked for', () => {
  it('is read-only by default', () => {
    expect(scopesFor(false)).toEqual(['read-only']);
  });

  it('is nothing at all when write access is wanted', () => {
    expect(scopesFor(true)).toEqual([]);
  });
});
