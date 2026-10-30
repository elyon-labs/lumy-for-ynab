import { milliunits, type Milliunits } from '@lumy/money';
import { z } from 'zod';

/**
 * The pieces every YNAB resource is built from.
 *
 * Every field YNAB sends is validated here rather than cast. A payload that
 * does not match fails at the boundary with the path that was wrong, which is
 * the difference between a sync that stops and a sync that quietly stores a
 * number meaning something else.
 */

/**
 * An amount, as a branded integer.
 *
 * YNAB sends milliunits as a JSON number. Parsing through `milliunits()`
 * rather than casting means a fractional amount — which would mean YNAB or a
 * proxy did floating-point arithmetic on the way here — is caught at the
 * boundary instead of being stored and summed.
 */
export const amount = z.number().transform<Milliunits>((value, ctx) => {
  try {
    return milliunits(value);
  } catch {
    ctx.addIssue({ code: 'custom', message: `Not a whole milliunit amount: ${value}` });

    return z.NEVER;
  }
});

/** `YYYY-MM-DD`, kept as text because it already sorts and compares as a date. */
export const isoDate = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Expected a YYYY-MM-DD date');

/** A month, which YNAB always reports as the first day of it. */
export const isoMonth = isoDate;

/**
 * A flag colour.
 *
 * YNAB sends `null` for an unflagged transaction, but the empty string turns
 * up too, and the two have to mean the same thing before a filter compares
 * against either. Unknown colours pass through: a colour YNAB adds later
 * should not fail a sync.
 */
export const flagColor = z
  .string()
  .nullish()
  .transform((value) => (value === undefined || value === null || value === '' ? null : value));

/** A nullable string, flattening YNAB's `undefined`/`null`/`""` into one. */
export const optionalText = z
  .string()
  .nullish()
  .transform((value) => (value === undefined || value === null || value === '' ? null : value));

/** A nullable id, which unlike text is never meaningfully empty. */
export const optionalId = z
  .string()
  .nullish()
  .transform((value) => value ?? null);

/** `deleted` is required on every delta-synced entity. */
export const deleted = z.boolean();

/** How far a resource has been synced. */
export const serverKnowledge = z.number().int();

/** Every YNAB response is one object under `data`. */
export function response<T extends z.ZodType>(data: T) {
  return z.object({ data });
}
