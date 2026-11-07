import { Screen } from '@lumy/ui';

/**
 * What a `wait` decision renders.
 *
 * Deliberately empty rather than a spinner. The splash screen is still up at
 * this point on a cold start, and the states being waited on are a database
 * open and two keychain reads — fast enough that a spinner would be a flash of
 * one.
 */
export function Splash() {
  return <Screen>{null}</Screen>;
}
