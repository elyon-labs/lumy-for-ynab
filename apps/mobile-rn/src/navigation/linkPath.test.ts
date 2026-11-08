import { describe, expect, it } from 'vitest';

import { resolveLink } from './linkPath';

describe('resolveLink', () => {
  it('resolves the path a sign-in link asks for', () => {
    // `lumy://budget`, which is what `redirects.signIn` is set to.
    expect(resolveLink('/budget')).toEqual({ route: '/budget', params: {} });
  });

  it('resolves the sync status screen a confirmed email change lands on', () => {
    // `redirects.emailChange`. The allow-listed URL is unchanged and the route
    // now exists, so the link goes where it asked rather than falling back to
    // wherever the redirect chain was already sending someone.
    expect(resolveLink('/settings/sync-status?email-change-confirmed=true')).toEqual({
      route: '/settings/sync-status',
      params: { 'email-change-confirmed': 'true' },
    });
  });

  it('carries the parameters the link was sent with', () => {
    // The screen reads these, so dropping the query would mean a confirmed
    // email change arriving with nothing to say about itself.
    expect(resolveLink('/budget?code=abc123&state=xyz')).toEqual({
      route: '/budget',
      params: { code: 'abc123', state: 'xyz' },
    });
  });

  it('decodes a parameter that arrived encoded', () => {
    expect(resolveLink('/budget?email=someone%40example.com')).toEqual({
      route: '/budget',
      params: { email: 'someone@example.com' },
    });
  });

  it('keeps the first value of a repeated key', () => {
    expect(resolveLink('/budget?code=first&code=second')?.params).toEqual({ code: 'first' });
  });

  it('resolves a path with no query at all', () => {
    expect(resolveLink('/settings/sync-status')).toEqual({
      route: '/settings/sync-status',
      params: {},
    });
  });

  it('does not resolve a path nothing answers to', () => {
    expect(resolveLink('/nowhere')).toBeNull();
    expect(resolveLink('')).toBeNull();
    expect(resolveLink('/')).toBeNull();
  });

  it('ignores the slashes a deep link arrives with', () => {
    // `parseUrl` splits on punctuation rather than parsing a URL, so what
    // reaches here depends on which engine produced it.
    expect(resolveLink('budget')?.route).toBe('/budget');
    expect(resolveLink('//budget/')?.route).toBe('/budget');
  });

  it('does not resolve a path by prefix', () => {
    expect(resolveLink('/budgets')).toBeNull();
    expect(resolveLink('/budget/category/1')).toBeNull();
  });

  it('matches a nested route as itself rather than as its parent', () => {
    // `/settings/sync-status` is a route of its own, and a prefix match would
    // send a confirmed email change to the settings index instead.
    expect(resolveLink('/settings/sync-status')?.route).toBe('/settings/sync-status');
    expect(resolveLink('/settings')?.route).toBe('/settings');
    expect(resolveLink('/settings/sync-status/extra')).toBeNull();
  });
});
