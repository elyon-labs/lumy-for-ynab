import { describe, expect, it } from 'vitest';

import { createYnabClient, type RateLimit, type YnabClient } from './client';
import { YnabError, YnabRateLimitError } from './errors';
import { writeAccess } from './scope';
import { fixtures, stubFetch, type StubResponse } from './testing';

const BASE = 'https://ynab.test/v1';

function client(
  script: StubResponse[],
  options: { onRateLimit?: (limit: RateLimit) => void; token?: string } = {},
): { client: YnabClient; stub: ReturnType<typeof stubFetch> } {
  const stub = stubFetch(...script);

  return {
    stub,
    client: createYnabClient({
      baseUrl: BASE,
      fetch: stub.fetch,
      getAccessToken: () => options.token ?? 'test-token',
      onRateLimit: options.onRateLimit,
    }),
  };
}

const ok = (body: unknown, headers?: Record<string, string>): StubResponse => ({ body, headers });

describe('requests', () => {
  it('sends the bearer token', async () => {
    const { client: ynab, stub } = client([ok(fixtures.budgets)], { token: 'abc123' });

    await ynab.getBudgets();

    expect(stub.only.headers.Authorization).toBe('Bearer abc123');
  });

  it('asks for the token per request, so a refresh takes effect', async () => {
    const stub = stubFetch(ok(fixtures.budgets), ok(fixtures.budgets));
    let token = 'first';
    const ynab = createYnabClient({
      baseUrl: BASE,
      fetch: stub.fetch,
      getAccessToken: () => token,
    });

    await ynab.getBudgets();
    token = 'second';
    await ynab.getBudgets();

    expect(stub.requests.map((request) => request.headers.Authorization)).toEqual([
      'Bearer first',
      'Bearer second',
    ]);
  });

  it('carries last_knowledge_of_server when it has one', async () => {
    const { client: ynab, stub } = client([ok(fixtures.accounts)]);

    await ynab.getAccounts({ budgetId: 'b-main', lastKnowledgeOfServer: 980 });

    expect(stub.only.url.pathname).toBe('/v1/budgets/b-main/accounts');
    expect(stub.only.url.searchParams.get('last_knowledge_of_server')).toBe('980');
  });

  it('omits it for a full snapshot', async () => {
    const { client: ynab, stub } = client([ok(fixtures.accounts)]);

    await ynab.getAccounts({ budgetId: 'b-main' });

    expect(stub.only.url.searchParams.has('last_knowledge_of_server')).toBe(false);
  });

  it('asks transactions for all of history when it has no knowledge', async () => {
    // YNAB answers a transactions request with neither parameter by sending
    // nothing at all, so a first sync has to say how far back it means.
    const { client: ynab, stub } = client([ok(fixtures.transactionsFirstPage)]);

    await ynab.getTransactions({ budgetId: 'b-main' });

    expect(stub.only.url.searchParams.get('since_date')).toBe('1900-01-01');
  });

  it('drops since_date once it is syncing deltas', async () => {
    const { client: ynab, stub } = client([ok(fixtures.transactionsDeltaPage)]);

    await ynab.getTransactions({ budgetId: 'b-main', lastKnowledgeOfServer: 1200 });

    expect(stub.only.url.searchParams.has('since_date')).toBe(false);
    expect(stub.only.url.searchParams.get('last_knowledge_of_server')).toBe('1200');
  });
});

describe('parsing', () => {
  it('returns budgets with their currency format flattened', async () => {
    const { client: ynab } = client([ok(fixtures.budgets)]);

    const budgets = await ynab.getBudgets();

    expect(budgets[0]).toMatchObject({
      id: 'b-main',
      name: 'My Budget',
      firstMonth: '2024-01-01',
      currencyFormat: {
        isoCode: 'GBP',
        decimalDigits: 2,
        currencySymbol: '£',
        symbolFirst: true,
        displaySymbol: true,
      },
    });
  });

  it('accepts a budget with no currency format', async () => {
    const { client: ynab } = client([ok(fixtures.budgets)]);

    const budgets = await ynab.getBudgets();

    expect(budgets[1]).toMatchObject({ id: 'b-no-format', currencyFormat: null, firstMonth: null });
  });

  it('flattens the three debt maps into one row per month', async () => {
    const { client: ynab } = client([ok(fixtures.accounts)]);

    const { entities } = await ynab.getAccounts({ budgetId: 'b-main' });

    expect(entities[1].debtMonths).toEqual([
      { month: '2026-09-01', interestRate: 4250, minimumPayment: null, escrowAmount: null },
      { month: '2026-10-01', interestRate: 4250, minimumPayment: 1420000, escrowAmount: 310000 },
    ]);
  });

  it('keeps a deleted account rather than dropping it', async () => {
    // The flag is what tells the writer to stop counting the rows it owns;
    // an omitted entity would just look unchanged.
    const { client: ynab } = client([ok(fixtures.accounts)]);

    const { entities } = await ynab.getAccounts({ budgetId: 'b-main' });

    expect(entities.map((account) => [account.id, account.deleted])).toEqual([
      ['a-checking', false],
      ['a-mortgage', false],
      ['a-old', true],
    ]);
  });

  it('returns category groups with their categories nested in payload order', async () => {
    // The nesting is the only statement YNAB makes about ordering.
    const { client: ynab } = client([ok(fixtures.categories)]);

    const { entities, serverKnowledge } = await ynab.getCategories({ budgetId: 'b-main' });

    expect(entities.map((group) => group.id)).toEqual(['g-internal', 'g-everyday']);
    expect(entities[1].categories.map((category) => category.id)).toEqual([
      'c-groceries',
      'c-fun',
    ]);
    expect(serverKnowledge).toBe(1101);
  });

  it('renames the goal fields to targets', async () => {
    const { client: ynab } = client([ok(fixtures.categories)]);

    const { entities } = await ynab.getCategories({ budgetId: 'b-main' });

    expect(entities[1].categories[0].target).toMatchObject({
      type: 'NEED',
      balance: 500000,
      percentageComplete: 100,
      month: null,
    });
  });

  it('reads a split and its legs', async () => {
    const { client: ynab } = client([ok(fixtures.transactionsFirstPage)]);

    const { entities } = await ynab.getTransactions({ budgetId: 'b-main' });
    const split = entities.find((transaction) => transaction.id === 't-split');

    expect(split?.categoryId).toBeNull();
    expect(split?.subtransactions.map((leg) => [leg.id, leg.amount, leg.categoryId])).toEqual([
      ['s-food', -40000, 'c-groceries'],
      ['s-fun', -18000, 'c-fun'],
    ]);
  });

  it('reads a leg that overrides the payee', async () => {
    const { client: ynab } = client([ok(fixtures.transactionsFirstPage)]);

    const { entities } = await ynab.getTransactions({ budgetId: 'b-main' });
    const leg = entities
      .find((transaction) => transaction.id === 't-split')
      ?.subtransactions.find((candidate) => candidate.id === 's-fun');

    expect(leg).toMatchObject({ payeeId: 'p-newsagent', payeeName: 'Newsagent' });
  });

  it('reads an empty flag colour as no flag', async () => {
    const { client: ynab } = client([ok(fixtures.transactionsFirstPage)]);

    const { entities } = await ynab.getTransactions({ budgetId: 'b-main' });

    expect(entities.find((t) => t.id === 't-opening')?.flagColor).toBeNull();
    expect(entities.find((t) => t.id === 't-simple')?.flagColor).toBe('red');
  });

  it('reads a month with its categories', async () => {
    const { client: ynab } = client([ok(fixtures.month)]);

    const month = await ynab.getMonth('b-main', '2026-10-01');

    expect(month).toMatchObject({ month: '2026-10-01', toBeBudgeted: 900000, ageOfMoney: 41 });
    expect(month.categories.map((category) => category.id)).toEqual(['c-groceries', 'c-fun']);
  });

  it('reads scheduled transactions and their legs', async () => {
    const { client: ynab } = client([ok(fixtures.scheduledTransactions)]);

    const { entities } = await ynab.getScheduledTransactions({ budgetId: 'b-main' });

    expect(entities[0]).toMatchObject({ dateNext: '2026-11-01', frequency: 'monthly' });
    expect(entities[1].subtransactions.map((leg) => leg.id)).toEqual(['sst-power', 'sst-water']);
  });

  it('reads payees, including a transfer payee', async () => {
    const { client: ynab } = client([ok(fixtures.payees)]);

    const { entities } = await ynab.getPayees({ budgetId: 'b-main' });

    expect(entities[2]).toMatchObject({
      name: 'Transfer : Savings',
      transferAccountId: 'a-savings',
    });
  });
});

describe('the delta page the Flutter writer got wrong', () => {
  it('omits a removed leg rather than marking it deleted', async () => {
    const { client: ynab } = client([ok(fixtures.transactionsDeltaPage)]);

    const { entities } = await ynab.getTransactions({
      budgetId: 'b-main',
      lastKnowledgeOfServer: 1200,
    });
    const split = entities.find((transaction) => transaction.id === 't-split');

    // `s-fun` is simply gone. Nothing in the payload says so, which is why
    // the writer has to reconcile the set rather than upsert what arrived.
    expect(split?.subtransactions.map((leg) => leg.id)).toEqual(['s-food']);
  });

  it('marks a removed transaction deleted', async () => {
    const { client: ynab } = client([ok(fixtures.transactionsDeltaPage)]);

    const { entities, serverKnowledge } = await ynab.getTransactions({
      budgetId: 'b-main',
      lastKnowledgeOfServer: 1200,
    });

    expect(entities.find((transaction) => transaction.id === 't-simple')?.deleted).toBe(true);
    expect(serverKnowledge).toBe(1247);
  });
});

describe('failures', () => {
  const ynabError = (id: string, name: string, detail: string) => ({ error: { id, name, detail } });

  it.each([
    ['401', 401, ynabError('401', 'unauthorized', 'Not authorized'), 'auth'],
    ['403.1', 403, ynabError('403.1', 'subscription_lapsed', 'Lapsed'), 'subscription'],
    ['403.2', 403, ynabError('403.2', 'trial_expired', 'Expired'), 'subscription'],
    ['403.3', 403, ynabError('403.3', 'unauthorized_scope', 'No scope'), 'scope'],
    ['404.2', 404, ynabError('404.2', 'resource_not_found', 'Gone'), 'notFound'],
    ['409', 409, ynabError('409', 'conflict', 'Conflict'), 'conflict'],
    ['500', 500, ynabError('500', 'internal_server_error', 'Oops'), 'server'],
  ])('reads %s as a %s failure', async (_id, status, body, failure) => {
    const { client: ynab } = client([{ status, body }]);

    await expect(ynab.getBudgets()).rejects.toMatchObject({ failure });
  });

  it('distinguishes a missing scope from a lapsed subscription', async () => {
    // Both are 403, and they lead to completely different places: one is an
    // upgrade flow in the app, the other is a problem at YNAB.
    const { client: scoped } = client([
      { status: 403, body: ynabError('403.3', 'unauthorized_scope', 'No scope') },
    ]);
    const { client: lapsed } = client([
      { status: 403, body: ynabError('403.1', 'subscription_lapsed', 'Lapsed') },
    ]);

    await expect(scoped.getBudgets()).rejects.toMatchObject({ failure: 'scope' });
    await expect(lapsed.getBudgets()).rejects.toMatchObject({ failure: 'subscription' });
  });

  it('falls back to the status when the body says nothing', async () => {
    const { client: ynab } = client([{ status: 401, text: '<html>nope</html>' }]);

    await expect(ynab.getBudgets()).rejects.toMatchObject({ failure: 'auth' });
  });

  it('reports a request that never reached YNAB as transport', async () => {
    const { client: ynab } = client([{ throws: new TypeError('Network request failed') }]);

    await expect(ynab.getBudgets()).rejects.toMatchObject({ failure: 'transport' });
  });

  it('fails loudly on a payload that does not match', async () => {
    // Quietly coercing it is how a field that changed shape becomes a wrong
    // number that is then stored and summed.
    const { client: ynab } = client([
      ok({ data: { budgets: [{ id: 'b-main', name: 42 }] } }),
    ]);

    await expect(ynab.getBudgets()).rejects.toMatchObject({ failure: 'malformed' });
  });

  it('names the field that was wrong', async () => {
    const { client: ynab } = client([ok({ data: { budgets: [{ id: 'b-main' }] } })]);

    await expect(ynab.getBudgets()).rejects.toThrow(/budgets\.0\.name/);
  });

  it('refuses a fractional amount', async () => {
    // A milliunit with a fraction means something upstream did money
    // arithmetic in floating point.
    const { client: ynab } = client([
      ok({ data: { accounts: [{ ...wholeAccount, balance: 1200.5 }], server_knowledge: 1 } }),
    ]);

    await expect(ynab.getAccounts({ budgetId: 'b-main' })).rejects.toMatchObject({
      failure: 'malformed',
    });
  });
});

const wholeAccount = {
  id: 'a-checking',
  name: 'Checking',
  type: 'checking',
  on_budget: true,
  closed: false,
  balance: 0,
  deleted: false,
  debt_interest_rates: {},
  debt_minimum_payments: {},
  debt_escrow_amounts: {},
};

describe('rate limiting', () => {
  it('reports what is left of the hour', async () => {
    const seen: RateLimit[] = [];
    const { client: ynab } = client([ok(fixtures.budgets, { 'X-Rate-Limit': '36/200' })], {
      onRateLimit: (limit) => seen.push(limit),
    });

    await ynab.getBudgets();

    expect(seen).toEqual([{ used: 36, limit: 200, remaining: 164 }]);
  });

  it('throws a rate-limit error carrying retry-after', async () => {
    const { client: ynab } = client([
      {
        status: 429,
        body: { error: { id: '429', name: 'too_many_requests', detail: 'Slow down' } },
        headers: { 'Retry-After': '90' },
      },
    ]);

    const error = await ynab.getBudgets().catch((caught: unknown) => caught);

    expect(error).toBeInstanceOf(YnabRateLimitError);
    expect(error).toMatchObject({ failure: 'rateLimit', retryAfterSeconds: 90 });
  });

  it('says so when YNAB gives no retry-after', async () => {
    const { client: ynab } = client([
      { status: 429, body: { error: { id: '429', name: 'too_many_requests', detail: 'Slow' } } },
    ]);

    const error = await ynab.getBudgets().catch((caught: unknown) => caught);

    expect(error).toMatchObject({ retryAfterSeconds: null });
  });

  it('does not retry on its own', async () => {
    // The sync engine serialises its fetches and is the only thing that knows
    // what else it was about to ask for; a client that quietly slept would
    // hide the limit from it.
    const { client: ynab, stub } = client([
      { status: 429, body: { error: { id: '429', name: 'too_many_requests', detail: 'Slow' } } },
      ok(fixtures.budgets),
    ]);

    await expect(ynab.getBudgets()).rejects.toBeInstanceOf(YnabError);

    expect(stub.requests).toHaveLength(1);
  });
});

describe('writes', () => {
  const draft = {
    accountId: 'a-checking',
    date: '2026-10-29',
    amount: -12000,
    payeeId: 'p-grocer',
    categoryId: 'c-groceries',
    memo: 'From a template',
  };

  const created = {
    data: {
      transaction: {
        ...fixtures.transactionsFirstPage.data.transactions[0],
        id: 't-created',
      },
      server_knowledge: 1300,
    },
  };

  it('needs proof that the token can write', () => {
    expect(writeAccess('read-only')).toBeNull();
    expect(writeAccess(null)).toBeNull();
    expect(writeAccess('')).toBeNull();
    expect(writeAccess('public')).not.toBeNull();
  });

  it("posts the draft in YNAB's own shape", async () => {
    const access = writeAccess('public');
    if (access === null) throw new Error('unreachable');
    const { client: ynab, stub } = client([{ status: 201, body: created }]);

    await ynab.createTransaction('b-main', draft, access);

    expect(stub.only.method).toBe('POST');
    expect(stub.only.url.pathname).toBe('/v1/budgets/b-main/transactions');
    expect(stub.only.body).toEqual({
      transaction: {
        account_id: 'a-checking',
        date: '2026-10-29',
        amount: -12000,
        payee_id: 'p-grocer',
        payee_name: null,
        category_id: 'c-groceries',
        memo: 'From a template',
        flag_color: null,
        approved: true,
      },
    });
  });

  it('posts a split draft with its legs', async () => {
    const access = writeAccess('public');
    if (access === null) throw new Error('unreachable');
    const { client: ynab, stub } = client([{ status: 201, body: created }]);

    await ynab.createTransaction(
      'b-main',
      { ...draft, subtransactions: [{ amount: -8000, categoryId: 'c-fun', memo: 'Half' }] },
      access,
    );

    expect((stub.only.body as { transaction: { subtransactions: unknown } }).transaction
      .subtransactions).toEqual([{ amount: -8000, category_id: 'c-fun', memo: 'Half' }]);
  });

  it('returns the transaction YNAB created', async () => {
    const access = writeAccess('public');
    if (access === null) throw new Error('unreachable');
    const { client: ynab } = client([{ status: 201, body: created }]);

    expect(await ynab.createTransaction('b-main', draft, access)).toMatchObject({
      id: 't-created',
    });
  });
});
