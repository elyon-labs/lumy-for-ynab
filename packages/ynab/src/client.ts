import type { z } from 'zod';

import { YnabError, errorForResponse } from './errors';
import { accountsResponseSchema, type Account } from './schemas/accounts';
import { budgetsResponseSchema, type Budget } from './schemas/budgets';
import { categoriesResponseSchema, type CategoryGroup } from './schemas/categories';
import {
  monthResponseSchema,
  monthsResponseSchema,
  type Month,
  type SingleMonth,
} from './schemas/months';
import { payeesResponseSchema, type Payee } from './schemas/payees';
import {
  scheduledTransactionsResponseSchema,
  type ScheduledTransaction,
} from './schemas/scheduledTransactions';
import {
  createTransactionResponseSchema,
  transactionsResponseSchema,
  type Transaction,
} from './schemas/transactions';
import type { WriteAccess } from './scope';

export const YNAB_API_BASE = 'https://api.ynab.com/v1';

/**
 * How many requests YNAB allows against one token per rolling hour.
 *
 * Here so the sync engine can pace against the same number the server is
 * counting to, rather than discovering it at 429.
 */
export const RATE_LIMIT_PER_HOUR = 200;

/**
 * The earliest date a full transaction fetch asks for.
 *
 * YNAB requires `since_date` or `last_knowledge_of_server` on a transactions
 * request; a date before any budget could exist is how "everything" is said.
 */
const BEGINNING_OF_TIME = '1900-01-01';

export interface YnabClientOptions {
  /**
   * Supplies the bearer token for each request.
   *
   * A callback rather than a string so a refreshed token takes effect without
   * rebuilding the client. Refresh itself belongs to whoever holds the
   * credentials, not here: this package knows nothing about secure storage.
   */
  getAccessToken: () => string | Promise<string>;
  /** Defaults to the global. Supplied by tests, and by nothing else. */
  fetch?: typeof globalThis.fetch;
  baseUrl?: string;
  /** Called after every response with what YNAB said is left of the hour. */
  onRateLimit?: (remaining: RateLimit) => void;
}

/** YNAB's `X-Rate-Limit` header, which reports usage as `used/limit`. */
export interface RateLimit {
  used: number;
  limit: number;
  remaining: number;
}

/** A page of a delta-synced resource, with the knowledge that describes it. */
export interface DeltaPage<T> {
  entities: T[];
  /**
   * Where the server now stands.
   *
   * Written in the same SQL transaction as the entities above, or not at all:
   * advancing it separately is how a client comes to believe it holds data it
   * never stored.
   */
  serverKnowledge: number;
}

export interface DeltaRequest {
  budgetId: string;
  /** Omitted for a full snapshot — first sync, and repair. */
  lastKnowledgeOfServer?: number;
}

/** A transaction to create, in the shape YNAB's write endpoint takes. */
export interface TransactionDraft {
  accountId: string;
  /** YYYY-MM-DD. */
  date: string;
  amount: number;
  payeeId?: string | null;
  payeeName?: string | null;
  categoryId?: string | null;
  memo?: string | null;
  flagColor?: string | null;
  approved?: boolean;
  subtransactions?: {
    amount: number;
    categoryId?: string | null;
    memo?: string | null;
  }[];
}

function parseRateLimit(header: string | null): RateLimit | null {
  if (header === null) return null;

  const [used, limit] = header.split('/').map(Number);
  if (!Number.isFinite(used) || !Number.isFinite(limit)) return null;

  return { used, limit, remaining: Math.max(0, limit - used) };
}

export interface YnabClient {
  getBudgets(): Promise<Budget[]>;
  getAccounts(request: DeltaRequest): Promise<DeltaPage<Account>>;
  getPayees(request: DeltaRequest): Promise<DeltaPage<Payee>>;
  getCategories(request: DeltaRequest): Promise<DeltaPage<CategoryGroup>>;
  getTransactions(request: DeltaRequest): Promise<DeltaPage<Transaction>>;
  getScheduledTransactions(request: DeltaRequest): Promise<DeltaPage<ScheduledTransaction>>;
  getMonths(request: DeltaRequest): Promise<DeltaPage<Month>>;
  /** One month with its categories, which is where per-month figures come from. */
  getMonth(budgetId: string, month: string): Promise<SingleMonth>;
  /**
   * Creates a transaction.
   *
   * Takes proof that the token can write, so the scope check happens at the
   * call site rather than at YNAB.
   */
  createTransaction(
    budgetId: string,
    draft: TransactionDraft,
    access: WriteAccess,
  ): Promise<Transaction>;
}

export function createYnabClient(options: YnabClientOptions): YnabClient {
  const baseUrl = options.baseUrl ?? YNAB_API_BASE;
  const doFetch = options.fetch ?? globalThis.fetch;

  async function request<T>(
    path: string,
    schema: z.ZodType<T>,
    init: { method?: string; body?: unknown; query?: Record<string, string | undefined> } = {},
  ): Promise<T> {
    const url = new URL(`${baseUrl}${path}`);
    for (const [key, value] of Object.entries(init.query ?? {})) {
      if (value !== undefined) url.searchParams.set(key, value);
    }

    const token = await options.getAccessToken();

    let httpResponse: Response;
    try {
      httpResponse = await doFetch(url.toString(), {
        method: init.method ?? 'GET',
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: 'application/json',
          ...(init.body === undefined ? {} : { 'Content-Type': 'application/json' }),
        },
        body: init.body === undefined ? undefined : JSON.stringify(init.body),
      });
    } catch (cause) {
      // Offline, DNS, TLS: nothing reached YNAB, so retrying is reasonable in
      // a way that none of the server's own answers are.
      throw new YnabError('transport', 'Could not reach YNAB.', { cause });
    }

    const limit = parseRateLimit(httpResponse.headers.get('X-Rate-Limit'));
    if (limit !== null) options.onRateLimit?.(limit);

    const text = await httpResponse.text();
    let payload: unknown;
    try {
      payload = text.length === 0 ? null : JSON.parse(text);
    } catch (cause) {
      if (!httpResponse.ok) throw errorForResponse(httpResponse.status, null, httpResponse.headers);

      throw new YnabError('malformed', 'YNAB returned a body that is not JSON.', { cause });
    }

    if (!httpResponse.ok) {
      throw errorForResponse(httpResponse.status, payload, httpResponse.headers);
    }

    const parsed = schema.safeParse(payload);
    if (!parsed.success) {
      // Loudly, at the boundary. A payload that does not match means a field
      // changed shape, and guessing at it here is how a wrong number gets
      // stored and then summed.
      throw new YnabError('malformed', `YNAB sent an unexpected ${path} payload: ${
        parsed.error.issues
          .slice(0, 3)
          .map((issue) => `${issue.path.join('.') || '(root)'} ${issue.message}`)
          .join('; ')
      }`, { cause: parsed.error });
    }

    return parsed.data;
  }

  function deltaQuery(request: DeltaRequest): Record<string, string | undefined> {
    return {
      last_knowledge_of_server:
        request.lastKnowledgeOfServer === undefined
          ? undefined
          : String(request.lastKnowledgeOfServer),
    };
  }

  return {
    async getBudgets() {
      const { data } = await request('/budgets', budgetsResponseSchema, {
        query: { include_accounts: 'false' },
      });

      return data.budgets;
    },

    async getAccounts(delta) {
      const { data } = await request(
        `/budgets/${delta.budgetId}/accounts`,
        accountsResponseSchema,
        { query: deltaQuery(delta) },
      );

      return { entities: data.accounts, serverKnowledge: data.server_knowledge };
    },

    async getPayees(delta) {
      const { data } = await request(`/budgets/${delta.budgetId}/payees`, payeesResponseSchema, {
        query: deltaQuery(delta),
      });

      return { entities: data.payees, serverKnowledge: data.server_knowledge };
    },

    async getCategories(delta) {
      const { data } = await request(
        `/budgets/${delta.budgetId}/categories`,
        categoriesResponseSchema,
        { query: deltaQuery(delta) },
      );

      return { entities: data.category_groups, serverKnowledge: data.server_knowledge };
    },

    async getTransactions(delta) {
      const { data } = await request(
        `/budgets/${delta.budgetId}/transactions`,
        transactionsResponseSchema,
        {
          query: {
            ...deltaQuery(delta),
            // YNAB needs one or the other, and sends nothing at all without.
            since_date: delta.lastKnowledgeOfServer === undefined ? BEGINNING_OF_TIME : undefined,
          },
        },
      );

      return { entities: data.transactions, serverKnowledge: data.server_knowledge };
    },

    async getScheduledTransactions(delta) {
      const { data } = await request(
        `/budgets/${delta.budgetId}/scheduled_transactions`,
        scheduledTransactionsResponseSchema,
        { query: deltaQuery(delta) },
      );

      return { entities: data.scheduled_transactions, serverKnowledge: data.server_knowledge };
    },

    async getMonths(delta) {
      const { data } = await request(`/budgets/${delta.budgetId}/months`, monthsResponseSchema, {
        query: deltaQuery(delta),
      });

      return { entities: data.months, serverKnowledge: data.server_knowledge };
    },

    async getMonth(budgetId, month) {
      const { data } = await request(
        `/budgets/${budgetId}/months/${month}`,
        monthResponseSchema,
      );

      return data.month;
    },

    async createTransaction(budgetId, draft, _access) {
      const { data } = await request(
        `/budgets/${budgetId}/transactions`,
        createTransactionResponseSchema,
        {
          method: 'POST',
          body: {
            transaction: {
              account_id: draft.accountId,
              date: draft.date,
              amount: draft.amount,
              payee_id: draft.payeeId ?? null,
              payee_name: draft.payeeName ?? null,
              category_id: draft.categoryId ?? null,
              memo: draft.memo ?? null,
              flag_color: draft.flagColor ?? null,
              approved: draft.approved ?? true,
              subtransactions: draft.subtransactions?.map((leg) => ({
                amount: leg.amount,
                category_id: leg.categoryId ?? null,
                memo: leg.memo ?? null,
              })),
            },
          },
        },
      );

      return data.transaction;
    },
  };
}
