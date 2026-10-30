import type {
  Account,
  Budget,
  CategoryGroup,
  DeltaPage,
  DeltaRequest,
  Month,
  Payee,
  ScheduledTransaction,
  SingleMonth,
  Transaction,
  YnabClient,
} from '@lumy/ynab';

/**
 * A `YnabClient` that answers from a script.
 *
 * The sync engine's correctness is about sequencing — what commits with what,
 * and what the next request asks for — so the tests need to state a page
 * exactly and then read back what was requested. A stub does that in a line;
 * a fixture server would not.
 *
 * Each resource holds a queue. A resource that runs out of queued pages
 * answers with an empty page carrying the knowledge it last reported, which
 * is what YNAB does for a client that is already up to date.
 */

export interface StubPage<T> {
  entities: readonly T[];
  serverKnowledge: number;
  /** Thrown instead of answering, to test what a failed fetch leaves behind. */
  error?: unknown;
}

export interface StubScript {
  budgets?: readonly Budget[];
  accounts?: readonly StubPage<Account>[];
  payees?: readonly StubPage<Payee>[];
  categories?: readonly StubPage<CategoryGroup>[];
  months?: readonly StubPage<Month>[];
  transactions?: readonly StubPage<Transaction>[];
  scheduledTransactions?: readonly StubPage<ScheduledTransaction>[];
  monthDetail?: readonly SingleMonth[];
}

export interface RecordedRequest {
  resource: string;
  budgetId: string;
  lastKnowledgeOfServer: number | undefined;
}

export interface StubClient extends YnabClient {
  /** Every request made, in order. */
  readonly requests: readonly RecordedRequest[];
  /** The last knowledge each resource was asked with. */
  lastRequestFor(resource: string): RecordedRequest | undefined;
}

export function createStubClient(script: StubScript = {}): StubClient {
  const requests: RecordedRequest[] = [];
  const queues = new Map<string, StubPage<unknown>[]>();
  const lastKnowledge = new Map<string, number>();

  function queue<T>(resource: string, pages: readonly StubPage<T>[] | undefined): void {
    queues.set(resource, [...(pages ?? [])] as StubPage<unknown>[]);
  }

  queue('accounts', script.accounts);
  queue('payees', script.payees);
  queue('categories', script.categories);
  queue('months', script.months);
  queue('transactions', script.transactions);
  queue('scheduled_transactions', script.scheduledTransactions);

  const monthDetails = [...(script.monthDetail ?? [])];

  function next<T>(resource: string, request: DeltaRequest): DeltaPage<T> {
    requests.push({
      resource,
      budgetId: request.budgetId,
      lastKnowledgeOfServer: request.lastKnowledgeOfServer,
    });

    const page = queues.get(resource)?.shift();
    if (page === undefined) {
      return { entities: [], serverKnowledge: lastKnowledge.get(resource) ?? 0 };
    }
    if (page.error !== undefined) throw page.error;

    lastKnowledge.set(resource, page.serverKnowledge);

    return { entities: page.entities as T[], serverKnowledge: page.serverKnowledge };
  }

  return {
    requests,

    lastRequestFor(resource) {
      return [...requests].reverse().find((request) => request.resource === resource);
    },

    async getBudgets() {
      requests.push({ resource: 'budgets', budgetId: '', lastKnowledgeOfServer: undefined });

      return [...(script.budgets ?? [])];
    },

    async getAccounts(request) {
      return next<Account>('accounts', request);
    },

    async getPayees(request) {
      return next<Payee>('payees', request);
    },

    async getCategories(request) {
      return next<CategoryGroup>('categories', request);
    },

    async getTransactions(request) {
      return next<Transaction>('transactions', request);
    },

    async getScheduledTransactions(request) {
      return next<ScheduledTransaction>('scheduled_transactions', request);
    },

    async getMonths(request) {
      return next<Month>('months', request);
    },

    async getMonth(budgetId, month) {
      requests.push({ resource: 'month_detail', budgetId, lastKnowledgeOfServer: undefined });

      const detail = monthDetails.shift();
      if (detail === undefined) {
        throw new Error(`The stub has no month detail queued for ${month}.`);
      }

      return detail;
    },

    async createTransaction() {
      throw new Error('The sync engine never writes to YNAB.');
    },
  };
}
