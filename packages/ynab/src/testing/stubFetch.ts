/** One canned answer. */
export interface StubResponse {
  status?: number;
  body?: unknown;
  /** Sent verbatim, so a test can state the exact header it is about. */
  headers?: Record<string, string>;
  /** Thrown instead of answering, for the offline case. */
  throws?: unknown;
  /** Returned in place of a JSON body, for the unparseable case. */
  text?: string;
}

export interface RecordedRequest {
  url: URL;
  method: string;
  headers: Record<string, string>;
  body: unknown;
}

export interface StubFetch {
  fetch: typeof globalThis.fetch;
  /** Every request made, in order. */
  requests: RecordedRequest[];
  /** The only request made, which is what most tests are asserting about. */
  readonly only: RecordedRequest;
}

/**
 * A `fetch` that answers from a script.
 *
 * The client takes `fetch` as an option so its behaviour against a status, a
 * header, or a malformed body can be stated directly, with no network and
 * nothing global patched.
 */
export function stubFetch(...script: StubResponse[]): StubFetch {
  const requests: RecordedRequest[] = [];
  let next = 0;

  const fetchImpl = (async (input: RequestInfo | URL, init?: RequestInit) => {
    const url = new URL(typeof input === 'string' ? input : input.toString());
    const headers = Object.fromEntries(
      Object.entries((init?.headers ?? {}) as Record<string, string>),
    );

    requests.push({
      url,
      method: init?.method ?? 'GET',
      headers,
      body: typeof init?.body === 'string' ? JSON.parse(init.body) : null,
    });

    const answer = script[Math.min(next, script.length - 1)] ?? {};
    next += 1;

    if (answer.throws !== undefined) throw answer.throws;

    const body = answer.text ?? (answer.body === undefined ? '' : JSON.stringify(answer.body));

    return new Response(body, {
      status: answer.status ?? 200,
      headers: answer.headers,
    });
  }) as typeof globalThis.fetch;

  return {
    fetch: fetchImpl,
    requests,
    get only() {
      if (requests.length !== 1) {
        throw new Error(`Expected exactly one request, saw ${requests.length}.`);
      }

      return requests[0];
    },
  };
}
