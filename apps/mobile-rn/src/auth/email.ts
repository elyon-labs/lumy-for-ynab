/**
 * Whether an address is worth emailing.
 *
 * Deliberately shallow. The only authority on whether an address exists is
 * whether the link arrives, so the point of checking here is to catch the
 * typo that would otherwise cost a round trip and a wait — a missing `@`, a
 * domain with no dot, a stray space from a paste or an autocomplete.
 * Anything stricter rejects addresses that work.
 */
export function isValidEmail(value: string): boolean {
  const trimmed = value.trim();
  if (trimmed.length === 0 || /\s/.test(trimmed)) return false;

  const parts = trimmed.split('@');
  if (parts.length !== 2) return false;

  const [local, domain] = parts;

  return local.length > 0 && /^[^.]+(\.[^.]+)+$/.test(domain);
}
