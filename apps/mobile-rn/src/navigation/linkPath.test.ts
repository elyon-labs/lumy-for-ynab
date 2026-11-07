import { describe, expect, it } from 'vitest';

import { resolveLinkPath } from './linkPath';

describe('resolveLinkPath', () => {
  it('resolves the path a sign-in link asks for', () => {
    // `lumy://budget`, which is what `redirects.signIn` is set to.
    expect(resolveLinkPath('/budget')).toBe('/budget');
  });

  it('resolves a path carrying the parameters the link was sent with', () => {
    expect(resolveLinkPath('/budget?code=abc123')).toBe('/budget');
  });

  it('does not resolve the sync status screen until it exists', () => {
    // `redirects.emailChange`. The session is established either way; this
    // only decides whether the path is worth navigating to.
    expect(resolveLinkPath('/settings/sync-status?email-change-confirmed=true')).toBeNull();
  });

  it('does not resolve a path nothing answers to', () => {
    expect(resolveLinkPath('/nowhere')).toBeNull();
    expect(resolveLinkPath('')).toBeNull();
    expect(resolveLinkPath('/')).toBeNull();
  });

  it('ignores the slashes a deep link arrives with', () => {
    // `parseUrl` splits on punctuation rather than parsing a URL, so what
    // reaches here depends on which engine produced it.
    expect(resolveLinkPath('budget')).toBe('/budget');
    expect(resolveLinkPath('//budget/')).toBe('/budget');
  });

  it('does not resolve a path by prefix', () => {
    expect(resolveLinkPath('/budgets')).toBeNull();
    expect(resolveLinkPath('/budget/category/1')).toBeNull();
  });
});
