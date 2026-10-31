/**
 * How long before another link can be sent.
 *
 * Supabase rate-limits the emails itself and answers a request made too soon
 * with an error, which is a worse way to find out than a button that says
 * when. One minute, as in the Flutter app.
 *
 * Measured from a stored timestamp rather than from component state, so the
 * cooldown survives the app being closed while the person goes to look at
 * their inbox — which is the usual way this screen is left.
 */

export const RESEND_COOLDOWN_SECONDS = 60;

/**
 * Seconds left of the cooldown, or zero.
 *
 * A timestamp in the future — a clock that moved, or a device that travelled —
 * reads as no cooldown rather than as a wait of up to forever.
 */
export function secondsUntilResend(sentAt: string | null, now: Date): number {
  if (sentAt === null) return 0;

  const sent = Date.parse(sentAt);
  if (Number.isNaN(sent)) return 0;

  const elapsed = (now.getTime() - sent) / 1000;
  if (elapsed < 0) return 0;

  return Math.max(0, Math.ceil(RESEND_COOLDOWN_SECONDS - elapsed));
}
