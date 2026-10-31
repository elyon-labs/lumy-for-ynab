import { describe, expect, it } from 'vitest';

import { parseConfig } from './config';

/**
 * A missing value should fail on launch naming itself, rather than as a
 * request to `undefined/auth/v1/otp` that looks like a network problem.
 */

const COMPLETE = {
  supabaseUrl: 'https://project.supabase.co',
  supabaseAnonKey: 'anon-key',
  deepLinkScheme: 'com.brandontrautmann.lumy',
  supportEmail: 'support@example.com',
};

describe('the app config', () => {
  it('reads what app.config.ts put in extra', () => {
    expect(parseConfig(COMPLETE)).toEqual(COMPLETE);
  });

  it('names every missing value at once', () => {
    // Finding them one launch at a time is the slowest way to configure an app.
    expect(() => parseConfig({ deepLinkScheme: 'com.brandontrautmann.lumy' })).toThrow(
      /supabaseUrl, supabaseAnonKey, supportEmail/,
    );
  });

  it('treats an empty string as missing, which is what an unset variable is', () => {
    // `app.config.ts` falls back to `''` rather than leaving the key out, so
    // a present-but-empty value is the normal shape of a mistake here.
    expect(() => parseConfig({ ...COMPLETE, supabaseAnonKey: '' })).toThrow(/supabaseAnonKey/);
  });

  it('rejects a value of the wrong type', () => {
    expect(() => parseConfig({ ...COMPLETE, supabaseUrl: 42 })).toThrow(/supabaseUrl/);
  });

  it('says what to do about it', () => {
    expect(() => parseConfig({})).toThrow(/\.env\.example/);
  });

  it('reports everything missing when there is no extra at all', () => {
    for (const extra of [undefined, null, 'nonsense']) {
      expect(() => parseConfig(extra)).toThrow(/supabaseUrl/);
    }
  });
});
