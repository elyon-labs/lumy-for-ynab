import { describe, expect, it } from 'vitest';

import { RESEND_COOLDOWN_SECONDS, secondsUntilResend } from './resend';

const SENT = '2026-10-31T12:00:00.000Z';

function secondsAfterSending(seconds: number): Date {
  return new Date(Date.parse(SENT) + seconds * 1000);
}

describe('the resend cooldown', () => {
  it('is the whole wait the moment a link is sent', () => {
    expect(secondsUntilResend(SENT, secondsAfterSending(0))).toBe(RESEND_COOLDOWN_SECONDS);
  });

  it('counts down', () => {
    expect(secondsUntilResend(SENT, secondsAfterSending(20))).toBe(40);
  });

  it('rounds up, so the button never says zero while it is still shut', () => {
    expect(secondsUntilResend(SENT, secondsAfterSending(59.4))).toBe(1);
  });

  it('is over once the wait has passed', () => {
    expect(secondsUntilResend(SENT, secondsAfterSending(60))).toBe(0);
    expect(secondsUntilResend(SENT, secondsAfterSending(600))).toBe(0);
  });

  it('is nothing when no link has been sent', () => {
    expect(secondsUntilResend(null, new Date())).toBe(0);
  });

  it('is nothing for a timestamp in the future', () => {
    // A clock that moved, or a device that travelled. Reading it as a wait
    // would shut the button for up to however far out the timestamp is.
    expect(secondsUntilResend(SENT, secondsAfterSending(-3600))).toBe(0);
  });

  it('is nothing for a stored value that is not a date', () => {
    expect(secondsUntilResend('whenever', new Date())).toBe(0);
  });
});
