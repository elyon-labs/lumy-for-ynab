/**
 * Pairing the Supabase account with the YNAB one.
 *
 * The `users` row is what makes the same person on another device recognised
 * as themselves, and it needs both ids: `ynab_user_id` is not nullable. Either
 * can arrive first — somebody can connect YNAB before signing in, or the other
 * way round — so the question is not "which step writes it" but "do we now
 * know something we have not written".
 *
 * That question is this function, and it is pure. The Flutter app asked it by
 * combining two streams, de-duplicating with `distinct()`, and writing from
 * the listener; the shape of the answer was never separable from the plumbing.
 */

export interface Pairing {
  /** The Supabase account id. */
  id: string;
  ynabUserId: string;
}

export interface PairingInputs {
  accountId: string | null;
  ynabUserId: string | null;
  /** What was last written in this session, to avoid writing it again. */
  lastWritten: Pairing | null;
}

/**
 * The pairing to write, or null when there is nothing new to say.
 *
 * Deliberately not keyed on the email address: an email change is confirmed by
 * Supabase and the row's own `email` column is updated by the same upsert, but
 * a change to it is not a reason to re-pair anything.
 */
export function pairingToWrite({
  accountId,
  ynabUserId,
  lastWritten,
}: PairingInputs): Pairing | null {
  if (accountId === null || ynabUserId === null) return null;

  if (lastWritten !== null && lastWritten.id === accountId && lastWritten.ynabUserId === ynabUserId) {
    return null;
  }

  return { id: accountId, ynabUserId };
}
