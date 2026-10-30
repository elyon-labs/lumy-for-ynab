/**
 * Why a YNAB call failed, in the terms the app has to act on.
 *
 * Each of these leads somewhere different: `auth` refreshes a token, `scope`
 * sends the user through the write-access upgrade, `subscription` explains
 * that YNAB itself needs attention, `rateLimit` waits, `transport` retries,
 * and `malformed` is a bug worth seeing rather than a number worth storing.
 * A single opaque failure would collapse all of that into "try again".
 */
export type YnabFailure =
  | 'auth'
  | 'scope'
  | 'subscription'
  | 'rateLimit'
  | 'notFound'
  | 'conflict'
  | 'request'
  | 'server'
  | 'transport'
  | 'malformed';

export class YnabError extends Error {
  constructor(
    readonly failure: YnabFailure,
    message: string,
    readonly options: {
      /** YNAB's own error id, such as `403.1`. Absent when nothing parsed. */
      readonly id?: string;
      readonly status?: number;
      readonly cause?: unknown;
    } = {},
  ) {
    super(message, { cause: options.cause });
    this.name = 'YnabError';
  }
}

/**
 * Thrown on 429.
 *
 * YNAB allows 200 requests an hour against a token. Nothing is retried here:
 * the sync engine serialises its fetches and is the only thing that knows
 * what else it was about to ask for, so a client that quietly slept would be
 * hiding the limit from the one component able to pace against it.
 */
export class YnabRateLimitError extends YnabError {
  constructor(
    message: string,
    /** From `Retry-After`, in seconds. Null when YNAB did not say. */
    readonly retryAfterSeconds: number | null,
    options: { readonly id?: string; readonly status?: number } = {},
  ) {
    super('rateLimit', message, options);
    this.name = 'YnabRateLimitError';
  }
}

/** YNAB's error body: `{ "error": { "id", "name", "detail" } }`. */
interface YnabErrorBody {
  id: string;
  name: string;
  detail: string;
}

function errorBody(payload: unknown): YnabErrorBody | null {
  if (typeof payload !== 'object' || payload === null) return null;

  const error = (payload as { error?: unknown }).error;
  if (typeof error !== 'object' || error === null) return null;

  const { id, name, detail } = error as Record<string, unknown>;
  if (typeof id !== 'string') return null;

  return {
    id,
    name: typeof name === 'string' ? name : id,
    detail: typeof detail === 'string' ? detail : id,
  };
}

/**
 * YNAB's error ids, which are finer than the status codes carrying them.
 *
 * A 403 is a lapsed subscription, an expired trial, a missing scope, or a
 * data limit, and only the first two mean the same thing to the user.
 */
function failureForId(id: string): YnabFailure | null {
  switch (id) {
    case '401':
      return 'auth';
    case '403.1':
    case '403.2':
      return 'subscription';
    case '403.3':
      return 'scope';
    case '403.4':
      return 'request';
    case '404.1':
    case '404.2':
      return 'notFound';
    case '409':
      return 'conflict';
    case '429':
      return 'rateLimit';
    default:
      return null;
  }
}

function failureForStatus(status: number): YnabFailure {
  if (status === 401) return 'auth';
  if (status === 403) return 'subscription';
  if (status === 404) return 'notFound';
  if (status === 409) return 'conflict';
  if (status === 429) return 'rateLimit';
  if (status >= 500) return 'server';

  return 'request';
}

/** `Retry-After` as seconds, accepting both the delta and HTTP-date forms. */
export function retryAfterSeconds(header: string | null, now: number = Date.now()): number | null {
  if (header === null) return null;

  const seconds = Number(header);
  if (Number.isFinite(seconds)) return Math.max(0, Math.round(seconds));

  const when = Date.parse(header);
  if (Number.isNaN(when)) return null;

  return Math.max(0, Math.round((when - now) / 1000));
}

/** Turns a failed response into the error the app acts on. */
export function errorForResponse(
  status: number,
  payload: unknown,
  headers: { get(name: string): string | null },
): YnabError {
  const body = errorBody(payload);
  const failure = (body === null ? null : failureForId(body.id)) ?? failureForStatus(status);
  const message = body === null ? `YNAB returned ${status}.` : `${body.name}: ${body.detail}`;

  if (failure === 'rateLimit') {
    return new YnabRateLimitError(message, retryAfterSeconds(headers.get('Retry-After')), {
      id: body?.id,
      status,
    });
  }

  return new YnabError(failure, message, { id: body?.id, status });
}
