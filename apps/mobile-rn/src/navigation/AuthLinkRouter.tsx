import { router } from 'expo-router';
import { useEffect } from 'react';

import { useAuth } from '@/auth';

import { resolveLinkPath } from './linkPath';

/**
 * Takes someone where the emailed link they opened asked to go.
 *
 * Mounted inside the shell rather than beside the deep-link listener, so that
 * it runs only once the redirect chain has already settled somewhere valid —
 * otherwise this and the chain would both be navigating at once and the last
 * one to win would decide.
 *
 * The path is cleared whether or not it resolved. An unresolved one is the
 * ordinary case for a screen that does not exist yet, and leaving it set would
 * re-resolve it on every render for the rest of the session.
 */
export function AuthLinkRouter(): null {
  const { linkPath, clearLinkPath } = useAuth();

  useEffect(() => {
    if (linkPath === null) return;

    const target = resolveLinkPath(linkPath);
    clearLinkPath();

    if (target !== null) router.replace(target);
  }, [linkPath, clearLinkPath]);

  return null;
}
