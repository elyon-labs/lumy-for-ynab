import { describe, expect, it } from 'vitest';

import { en } from './en';
import { DEFAULT_LANGUAGE, resolveLanguage } from './language';

/**
 * The catalog's own rules.
 *
 * Types already stop a screen asking for a key that does not exist. What they
 * do not stop is a placeholder being renamed inside a string, which renders as
 * nothing and reads as a missing name — so the placeholders are declared and
 * checked, the same way the read dependencies in `packages/data` are.
 */

/** Every string that interpolates, with the names it interpolates. */
const PLACEHOLDERS: Record<string, readonly string[]> = {
  'auth.signIn.sentExplainer': ['email'],
  'auth.signIn.resendIn': ['seconds'],
  'auth.account.pendingEmailExplainer': ['email'],
  'auth.changeEmail.sentExplainer': ['email'],
};

/** The catalog as `key.path` → string. */
function flatten(catalog: object, prefix = ''): Map<string, string> {
  const flat = new Map<string, string>();

  for (const [key, value] of Object.entries(catalog)) {
    const path = prefix === '' ? key : `${prefix}.${key}`;

    if (typeof value === 'string') {
      flat.set(path, value);
    } else {
      for (const [nested, string] of flatten(value as object, path)) {
        flat.set(nested, string);
      }
    }
  }

  return flat;
}

function placeholdersIn(string: string): string[] {
  return [...string.matchAll(/\{\{(\w+)\}\}/g)].map((match) => match[1]).sort();
}

describe('the English catalog', () => {
  const flat = flatten(en);

  it('has something to say for every key', () => {
    for (const [key, value] of flat) {
      expect(value.trim(), key).not.toBe('');
    }
  });

  it('interpolates exactly the names that are declared', () => {
    const interpolating = [...flat]
      .filter(([, value]) => placeholdersIn(value).length > 0)
      .map(([key]) => key)
      .sort();

    expect(interpolating).toEqual(Object.keys(PLACEHOLDERS).sort());

    for (const [key, names] of Object.entries(PLACEHOLDERS)) {
      expect(placeholdersIn(flat.get(key) ?? ''), key).toEqual([...names].sort());
    }
  });
});

describe('the language a device gets', () => {
  it('is the first of its preferences there is a catalog for', () => {
    expect(resolveLanguage([{ languageCode: 'en' }])).toBe('en');
  });

  it('falls back when nothing it asked for exists', () => {
    expect(resolveLanguage([{ languageCode: 'de' }, { languageCode: 'fr' }])).toBe(
      DEFAULT_LANGUAGE,
    );
  });

  it('takes the device order rather than the catalog order', () => {
    expect(resolveLanguage([{ languageCode: 'fr' }, { languageCode: 'en' }], ['en', 'fr'])).toBe(
      'fr',
    );
  });

  it('falls back for a device that reports no language at all', () => {
    expect(resolveLanguage([])).toBe(DEFAULT_LANGUAGE);
    expect(resolveLanguage([{ languageCode: null }])).toBe(DEFAULT_LANGUAGE);
  });
});
