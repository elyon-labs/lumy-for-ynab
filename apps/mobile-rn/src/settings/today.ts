/**
 * What day it is, where the person is.
 *
 * A period that ends "today" has to be resolved against the device's own
 * calendar day, so this is the one place in the app that reads a clock for a
 * date. Everything below it takes `YYYY-MM-DD` and is pure, which is how the
 * period arithmetic in `@lumy/data` stays testable without a clock at all.
 */

/** The device's current date as `YYYY-MM-DD`, in local time rather than UTC. */
export function today(now: Date = new Date()): string {
  const pad = (value: number) => String(value).padStart(2, '0');

  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;
}

/**
 * How long until the date changes.
 *
 * Built from local calendar parts rather than by adding 24 hours, so the day
 * the clocks change is still one timer and still lands on midnight. The
 * Flutter app recomputed the chosen period once a minute instead, whether or
 * not anything had moved.
 */
export function millisecondsUntilTomorrow(now: Date = new Date()): number {
  const midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);

  return midnight.getTime() - now.getTime();
}
