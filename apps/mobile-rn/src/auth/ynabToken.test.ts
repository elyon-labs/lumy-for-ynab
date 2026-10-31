import { describe, expect, it } from 'vitest';

import {
  canWrite,
  EXPIRY_MARGIN_SECONDS,
  expiresAt,
  isExpired,
  parseToken,
  type YnabToken,
} from './ynabToken';

const CREATED_AT = 1_800_000_000;

function aToken(overrides: Partial<YnabToken> = {}): YnabToken {
  return {
    accessToken: 'access',
    refreshToken: 'refresh',
    expiresIn: 7200,
    createdAt: CREATED_AT,
    scope: 'read-only',
    ...overrides,
  };
}

/** A clock, `seconds` after the token was issued. */
function secondsAfterIssue(seconds: number): Date {
  return new Date((CREATED_AT + seconds) * 1000);
}

describe('when a token expires', () => {
  it('is its creation plus its lifetime, in seconds', () => {
    expect(expiresAt(aToken())).toBe(CREATED_AT + 7200);
  });

  it('is not expired while there is time left', () => {
    expect(isExpired(aToken(), secondsAfterIssue(0))).toBe(false);
    expect(isExpired(aToken(), secondsAfterIssue(7000))).toBe(false);
  });

  it('is expired once it has run out', () => {
    expect(isExpired(aToken(), secondsAfterIssue(7200))).toBe(true);
    expect(isExpired(aToken(), secondsAfterIssue(100_000))).toBe(true);
  });

  it('is expired a minute early, so a request does not carry it over the line', () => {
    // A token that expires during the request carrying it is a 401 and a
    // retry; the margin turns almost all of those into a refresh beforehand.
    expect(isExpired(aToken(), secondsAfterIssue(7200 - EXPIRY_MARGIN_SECONDS))).toBe(true);
    expect(isExpired(aToken(), secondsAfterIssue(7200 - EXPIRY_MARGIN_SECONDS - 1))).toBe(false);
  });
});

describe('what a token may do', () => {
  it('cannot write with YNAB read-only scope', () => {
    expect(canWrite(aToken({ scope: 'read-only' }))).toBe(false);
  });

  it('can write with any other scope', () => {
    // YNAB grants full access by returning a scope that is not `read-only`.
    expect(canWrite(aToken({ scope: '' }))).toBe(false);
    expect(canWrite(aToken({ scope: 'read-write' }))).toBe(true);
  });

  it('cannot write when there is no token', () => {
    expect(canWrite(null)).toBe(false);
  });
});

describe('reading a stored token back', () => {
  it('accepts a whole record', () => {
    expect(parseToken(aToken())).toEqual(aToken());
  });

  it.each([
    ['nothing', null],
    ['not an object', 'access'],
    ['no access token', { ...aToken(), accessToken: undefined }],
    ['an empty access token', { ...aToken(), accessToken: '' }],
    ['no refresh token', { ...aToken(), refreshToken: undefined }],
    ['an empty refresh token', { ...aToken(), refreshToken: '' }],
    ['no lifetime', { ...aToken(), expiresIn: undefined }],
    ['a lifetime that is not a number', { ...aToken(), expiresIn: '7200' }],
    ['no creation time', { ...aToken(), createdAt: null }],
    ['no scope', { ...aToken(), scope: undefined }],
  ])('reads %s as no token', (_case, raw) => {
    // The alternative is an app that cannot launch because of a record some
    // other build wrote. Reconnecting is a tap.
    expect(parseToken(raw)).toBeNull();
  });
});
