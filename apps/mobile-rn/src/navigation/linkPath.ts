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
 * `/settings/sync-status` is the one a confirmed email change lands on, and
 * the allow-listed URL carries `?email-change-confirmed=true` with it — which
 * is why a link's query survives resolution rather than being stripped with
 * the rest of the URL.
 */
export const LINK_ROUTES = [
  '/budget',
  '/reports',
  '/settings',
  '/settings/sync-status',
] as const;

export type LinkRoute = (typeof LINK_ROUTES)[number];

export interface ResolvedLink {
  route: LinkRoute;
  /** The link's query, which the destination screen reads. */
  params: Record<string, string>;
}

/**
 * The query a link carried, as the router takes it.
 *
 * Only the first value of a repeated key is kept. A link Lumy sent has no
 * repeated keys, and a second value for one is something nobody asked for.
 */
function paramsIn(query: string): Record<string, string> {
  const params: Record<string, string> = {};

  for (const pair of query.split('&')) {
    if (pair === '') continue;

    const [key, value = ''] = pair.split('=');
    const name = decodeURIComponent(key);
    if (name !== '' && !(name in params)) params[name] = decodeURIComponent(value);
  }

  return params;
}

/**
 * Resolves a link's path to a route, or null when nothing answers to it.
 *
 * Null is not an error: the session has already been established by the time
 * this is asked, so the worst a null does is leave someone where the redirect
 * chain put them. Routing the path unresolved would instead land a link on the
 * not-found screen.
 *
 * The path is matched against the whole list rather than walked segment by
 * segment, so a nested route is matched as itself — `/settings/sync-status` is
 * not `/settings`, and a prefix match would send a confirmed email change to
 * the settings index with nothing to say about it.
 */
export function resolveLink(path: string): ResolvedLink | null {
  const [withoutQuery = '', query = ''] = path.split('?');
  const normalised = `/${withoutQuery.replace(/^\/+|\/+$/g, '')}`;
  const route = LINK_ROUTES.find((candidate) => candidate === normalised);

  return route === undefined ? null : { route, params: paramsIn(query) };
}
