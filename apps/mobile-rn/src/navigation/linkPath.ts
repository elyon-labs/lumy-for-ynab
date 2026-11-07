/**
 * Where an emailed link asked to land, if the shell has somewhere to put it.
 *
 * `completeAuthFromUrl` returns the path the link carried, and that path is
 * the only thing separating a sign-in from a confirmed email change: both
 * arrive as a deep link, go through the same listener, and exchange the same
 * kind of code. Supabase is told where to send each by `emailRedirectTo`, and
 * both URLs are allow-listed in the project, so a path cannot be changed here
 * without changing it there first.
 */

/**
 * The link destinations that exist.
 *
 * `/settings/sync-status` is not among them yet — it is the sync status
 * screen, which arrives with the sync UI — so a confirmed email change
 * currently resolves to nothing and falls back to wherever the redirect chain
 * was already sending it. This list is what has to catch up; the allow-listed
 * URL stays as it is.
 */
export const LINK_ROUTES = ['/budget', '/reports', '/settings'] as const;

export type LinkRoute = (typeof LINK_ROUTES)[number];

/**
 * Resolves a link's path to a route, or null when nothing answers to it.
 *
 * Null is the ordinary case for a path the app will understand a PR from now,
 * not an error: the session has already been established by the time this is
 * asked, so the worst a null does is leave someone where the chain put them.
 * Routing the path unresolved would instead land a confirmed email change on
 * the not-found screen.
 */
export function resolveLinkPath(path: string): LinkRoute | null {
  const withoutQuery = path.split('?')[0] ?? '';
  const normalised = `/${withoutQuery.replace(/^\/+|\/+$/g, '')}`;

  return LINK_ROUTES.find((route) => route === normalised) ?? null;
}
