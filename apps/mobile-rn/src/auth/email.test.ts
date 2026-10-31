import { describe, expect, it } from 'vitest';

import { isValidEmail } from './email';

/**
 * The check is there to catch a typo before it costs a round trip and a wait.
 * Anything stricter rejects addresses that work, so the accepted cases below
 * matter as much as the rejected ones.
 */
describe('an address worth emailing', () => {
  it.each([
    'someone@example.com',
    'someone+lumy@example.co.uk',
    'first.last@sub.example.com',
    "o'brien@example.com",
    'someone@example.photography',
  ])('accepts %s', (value) => {
    expect(isValidEmail(value)).toBe(true);
  });

  it('accepts an address someone pasted with spaces around it', () => {
    expect(isValidEmail('  someone@example.com  ')).toBe(true);
  });

  it.each([
    ['nothing at all', ''],
    ['no at sign', 'someone.example.com'],
    ['two at signs', 'someone@@example.com'],
    ['no local part', '@example.com'],
    ['no domain', 'someone@'],
    ['a domain with no dot', 'someone@localhost'],
    ['a domain ending in a dot', 'someone@example.'],
    ['a space in the middle', 'some one@example.com'],
  ])('rejects %s', (_case, value) => {
    expect(isValidEmail(value)).toBe(false);
  });
});
