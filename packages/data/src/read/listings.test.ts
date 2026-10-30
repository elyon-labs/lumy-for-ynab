import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { rebuildLedgerForBudget } from '../ledger';
import {
  BUDGET_ID,
  createHarness,
  seedAccount,
  seedBudget,
  seedCategory,
  seedCategoryGroup,
  seedPayee,
  seedSubtransaction,
  seedTransaction,
  type Harness,
} from '../testing';
import type { LedgerCondition } from './conditions';
import {
  ledgerEntryPageStatement,
  listLedgerEntries,
  listTransactions,
  transactionPageStatement,
  type CompiledStatement,
  type LedgerCursor,
  type Page,
} from './listings';

describe('the listings', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;

    await seedBudget(db);
    await seedAccount(db, { id: 'checking', name: 'Checking' });
    await seedAccount(db, { id: 'savings', name: 'Savings' });
    await seedPayee(db, { id: 'grocer', name: 'Grocer' });
    await seedPayee(db, { id: 'employer', name: 'Employer' });
    await seedCategoryGroup(db, { id: 'everyday', name: 'Everyday Expenses' });
    await seedCategoryGroup(db, { id: 'internal', name: 'Internal Master Category' });
    await seedCategory(db, { id: 'food', name: 'Groceries', categoryGroupId: 'everyday' });
    await seedCategory(db, { id: 'fun', name: 'Fun Money', categoryGroupId: 'everyday' });
    await seedCategory(db, {
      id: 'ready',
      name: 'Inflow: Ready to Assign',
      categoryGroupId: 'internal',
    });
  });

  afterEach(async () => {
    await harness.close();
  });

  async function derive(): Promise<void> {
    await rebuildLedgerForBudget(db, BUDGET_ID);
  }

  async function entries(
    options: {
      condition?: LedgerCondition;
      limit?: number;
      cursor?: LedgerCursor | null;
    } = {},
  ): Promise<Page<Awaited<ReturnType<typeof listLedgerEntries>>['rows'][number]>> {
    return listLedgerEntries(db, {
      budgetId: BUDGET_ID,
      limit: options.limit ?? 50,
      condition: options.condition,
      cursor: options.cursor,
    });
  }

  describe('a ledger entry page', () => {
    beforeEach(async () => {
      await seedTransaction(db, {
        id: 'tx-1',
        accountId: 'checking',
        date: '2026-10-03',
        payeeId: 'grocer',
        categoryId: 'food',
        amount: -4_000,
        memo: 'Weekly shop',
        flagColor: 'red',
      });
      await seedTransaction(db, {
        id: 'tx-2',
        accountId: 'checking',
        date: '2026-10-01',
        payeeId: 'grocer',
        amount: -10_000,
      });
      await seedSubtransaction(db, {
        id: 'sub-1',
        transactionId: 'tx-2',
        categoryId: 'food',
        amount: -3_000,
      });
      await seedSubtransaction(db, {
        id: 'sub-2',
        transactionId: 'tx-2',
        categoryId: 'fun',
        amount: -7_000,
      });
      await derive();
    });

    it('returns newest first', async () => {
      const page = await entries();

      expect(page.rows.map((row) => row.entryId)).toEqual(['tx-1', 'sub-2', 'sub-1']);
    });

    it('resolves the names a row renders', async () => {
      const page = await entries();

      expect(page.rows[0]).toMatchObject({
        accountName: 'Checking',
        payeeName: 'Grocer',
        categoryName: 'Groceries',
        categoryGroupName: 'Everyday Expenses',
        memo: 'Weekly shop',
        flagColor: 'red',
        amount: -4_000,
      });
    });

    it('shows a split as its legs, not as its sum', async () => {
      const page = await entries();
      const legs = page.rows.filter((row) => row.transactionId === 'tx-2');

      expect(legs.map((row) => row.amount)).toEqual([-7_000, -3_000]);
      expect(legs.every((row) => row.isSubtransaction)).toBe(true);
    });

    it('marks the first row of each date group', async () => {
      const page = await entries();

      expect(page.rows.map((row) => [row.date, row.startsDateGroup])).toEqual([
        ['2026-10-03', true],
        ['2026-10-01', true],
        ['2026-10-01', false],
      ]);
    });
  });

  describe('pagination', () => {
    beforeEach(async () => {
      // Two per day, so a page boundary can land inside a date group.
      for (let day = 1; day <= 6; day += 1) {
        const date = `2026-10-0${day}`;
        for (const half of ['a', 'b']) {
          await seedTransaction(db, {
            id: `tx-${day}${half}`,
            accountId: 'checking',
            date,
            categoryId: 'food',
            payeeId: 'grocer',
          });
        }
      }
      await derive();
    });

    it('walks the whole list without repeating or skipping a row', async () => {
      const seen: string[] = [];
      let cursor: LedgerCursor | null = null;

      do {
        const page: Page<{ entryId: string }> = await entries({ limit: 5, cursor });
        seen.push(...page.rows.map((row) => row.entryId));
        cursor = page.nextCursor;
      } while (cursor !== null);

      expect(seen).toHaveLength(12);
      expect(new Set(seen).size).toBe(12);
    });

    it('reports no cursor on the last page', async () => {
      const page = await entries({ limit: 50 });

      expect(page.rows).toHaveLength(12);
      expect(page.nextCursor).toBeNull();
    });

    it('returns exactly the limit, never the extra row it reads', async () => {
      const page = await entries({ limit: 5 });

      expect(page.rows).toHaveLength(5);
      expect(page.rows.map((row) => row.entryId)).toEqual([
        'tx-6b',
        'tx-6a',
        'tx-5b',
        'tx-5a',
        'tx-4b',
      ]);
      expect(page.nextCursor).toEqual({ date: '2026-10-04', id: 'tx-4b' });
    });

    it('does not repeat a date header the previous page already rendered', async () => {
      // Four rows covers 06b, 06a, 05b, 05a — so page two opens on 2026-10-04.
      const first = await entries({ limit: 3 });
      expect(first.rows.map((row) => row.startsDateGroup)).toEqual([true, false, true]);

      const second = await entries({ limit: 3, cursor: first.nextCursor });

      // 05a continues the group 05b opened on the previous page.
      expect(second.rows.map((row) => [row.entryId, row.startsDateGroup])).toEqual([
        ['tx-5a', false],
        ['tx-4b', true],
        ['tx-4a', false],
      ]);
    });
  });

  describe('a transaction page', () => {
    beforeEach(async () => {
      await seedTransaction(db, {
        id: 'tx-1',
        accountId: 'checking',
        date: '2026-10-03',
        payeeId: 'grocer',
        categoryId: 'food',
        amount: -4_000,
        memo: 'Weekly shop',
        flagColor: 'red',
      });
      await seedTransaction(db, {
        id: 'tx-2',
        accountId: 'savings',
        date: '2026-10-01',
        payeeId: 'grocer',
        amount: -10_000,
        memo: 'Split',
      });
      await seedSubtransaction(db, {
        id: 'sub-1',
        transactionId: 'tx-2',
        categoryId: 'food',
        amount: -3_000,
      });
      await seedSubtransaction(db, {
        id: 'sub-2',
        transactionId: 'tx-2',
        categoryId: 'fun',
        amount: -7_000,
      });
      await derive();
    });

    async function transactions(condition?: LedgerCondition) {
      return listTransactions(db, { budgetId: BUDGET_ID, limit: 50, condition });
    }

    it('returns one row per transaction, newest first', async () => {
      const page = await transactions();

      expect(page.rows.map((row) => row.transactionId)).toEqual(['tx-1', 'tx-2']);
    });

    it('sums a split into one row and says how many legs it has', async () => {
      const page = await transactions();

      expect(page.rows[1]).toMatchObject({
        transactionId: 'tx-2',
        amount: -10_000,
        legCount: 2,
        categoryId: null,
        categoryName: null,
        accountName: 'Savings',
        memo: 'Split',
      });
    });

    it('names the category of a transaction that has one', async () => {
      const page = await transactions();

      expect(page.rows[0]).toMatchObject({
        legCount: 1,
        categoryId: 'food',
        categoryName: 'Groceries',
      });
    });

    it('carries only the matching legs when a filter narrows it', async () => {
      const page = await transactions({ test: 'hasCategoryId', ids: ['food'] });

      expect(page.rows.map((row) => [row.transactionId, row.amount, row.legCount])).toEqual([
        ['tx-1', -4_000, 1],
        ['tx-2', -3_000, 1],
      ]);
    });

    it('names the category of a split narrowed to one leg', async () => {
      const page = await transactions({ test: 'hasCategoryId', ids: ['fun'] });

      expect(page.rows[0]).toMatchObject({
        transactionId: 'tx-2',
        categoryName: 'Fun Money',
        amount: -7_000,
      });
    });

    it('marks its date groups too', async () => {
      const page = await transactions();

      expect(page.rows.map((row) => row.startsDateGroup)).toEqual([true, true]);
    });
  });

  describe('filtering', () => {
    beforeEach(async () => {
      await seedTransaction(db, {
        id: 'shop',
        accountId: 'checking',
        date: '2026-10-05',
        payeeId: 'grocer',
        categoryId: 'food',
        amount: -4_000,
        memo: 'Weekly shop',
        flagColor: 'red',
      });
      await seedTransaction(db, {
        id: 'pay',
        accountId: 'checking',
        date: '2026-09-30',
        payeeId: 'employer',
        categoryId: 'ready',
        amount: 300_000,
      });
      await seedTransaction(db, {
        id: 'refund',
        accountId: 'savings',
        date: '2026-10-02',
        payeeId: 'grocer',
        categoryId: 'food',
        amount: 1_500,
        memo: 'Returned the 50% off item',
      });
      await seedTransaction(db, {
        id: 'bulk',
        accountId: 'checking',
        date: '2026-10-04',
        payeeId: 'grocer',
        categoryId: 'fun',
        amount: -2_000,
        memo: 'Returned 500 items',
      });
      await seedTransaction(db, {
        id: 'uncategorised',
        accountId: 'savings',
        date: '2026-10-01',
        payeeName: 'Someone',
        amount: -900,
      });
      await derive();
    });

    async function matching(condition: LedgerCondition): Promise<string[]> {
      const page = await entries({ condition });

      return page.rows.map((row) => row.entryId);
    }

    it.each([
      ['hasAccountId', { test: 'hasAccountId', ids: ['savings'] }, ['refund', 'uncategorised']],
      [
        'hasAccountId over several',
        { test: 'hasAccountId', ids: ['checking', 'savings'] },
        ['shop', 'bulk', 'refund', 'uncategorised', 'pay'],
      ],
      ['hasPayeeId', { test: 'hasPayeeId', ids: ['employer'] }, ['pay']],
      ['hasPayeeId with no payee', { test: 'hasPayeeId', ids: [null] }, ['uncategorised']],
      ['hasCategoryId', { test: 'hasCategoryId', ids: ['food'] }, ['shop', 'refund']],
      [
        'hasCategoryId with no category',
        { test: 'hasCategoryId', ids: [null] },
        ['uncategorised'],
      ],
      [
        'hasCategoryGroupId',
        { test: 'hasCategoryGroupId', ids: ['everyday'] },
        ['shop', 'bulk', 'refund'],
      ],
      ['hasFlagColor', { test: 'hasFlagColor', colors: ['red'] }, ['shop']],
      [
        'hasFlagColor with no flag',
        { test: 'hasFlagColor', colors: [null] },
        ['bulk', 'refund', 'uncategorised', 'pay'],
      ],
      ['hasMemoKeyword', { test: 'hasMemoKeyword', keyword: 'shop' }, ['shop']],
      [
        'hasMemoKeyword matching case-insensitively',
        { test: 'hasMemoKeyword', keyword: 'WEEKLY' },
        ['shop'],
      ],
      [
        // `bulk` has a memo reading `Returned 500 items`, which an unescaped
        // `%50%%` would match and a literal `50%` must not.
        'hasMemoKeyword with a literal wildcard',
        { test: 'hasMemoKeyword', keyword: '50%' },
        ['refund'],
      ],
      ['isIncome', { test: 'isIncome' }, ['pay']],
      ['isExpense', { test: 'isExpense' }, ['shop', 'bulk', 'refund']],
      ['isInflow', { test: 'isInflow' }, ['refund', 'pay']],
      ['isOutflow', { test: 'isOutflow' }, ['shop', 'bulk', 'uncategorised']],
      [
        'dateRange',
        { test: 'dateRange', from: '2026-10-01', to: '2026-10-02' },
        ['refund', 'uncategorised'],
      ],
    ] satisfies [string, LedgerCondition, string[]][])(
      'selects by %s',
      async (_name, condition, expected) => {
        expect(await matching(condition)).toEqual(expected);
      },
    );

    it('negates a test over a row the column is null for', async () => {
      // The entry with no memo does not contain the keyword, so negating the
      // test has to keep it. SQL would answer null and drop it.
      expect(await matching({ test: 'not', of: { test: 'hasMemoKeyword', keyword: 'shop' } })).toEqual(
        ['bulk', 'refund', 'uncategorised', 'pay'],
      );
    });

    it('negates a category test over an uncategorised row', async () => {
      expect(
        await matching({ test: 'not', of: { test: 'hasCategoryId', ids: ['food'] } }),
      ).toEqual(['bulk', 'uncategorised', 'pay']);
    });

    it('combines nested branches', async () => {
      expect(
        await matching({
          test: 'all',
          of: [
            { test: 'hasCategoryGroupId', ids: ['everyday'] },
            { test: 'any', of: [{ test: 'isInflow' }, { test: 'hasFlagColor', colors: ['red'] }] },
          ],
        }),
      ).toEqual(['shop', 'refund']);
    });

    it('returns nothing for an empty choice', async () => {
      expect(await matching({ test: 'any', of: [] })).toEqual([]);
    });

    it('returns everything for an empty filter', async () => {
      expect(await matching({ test: 'all', of: [] })).toHaveLength(5);
    });
  });

  describe('the query plans', () => {
    /**
     * The plan for the statement that ships, not a transcription of it.
     *
     * A listing is only paginated if the database can stop at the limit. These
     * assert the page itself comes off an index in the order it is asked for,
     * so the work is the size of the page rather than the size of the budget.
     */
    async function plan(statement: CompiledStatement): Promise<string> {
      const rows = await db.all<{ detail: string }>(
        `EXPLAIN QUERY PLAN ${statement.sql}`,
        statement.params,
      );

      return rows.map((row) => row.detail).join('\n');
    }

    const cursor: LedgerCursor = { date: '2026-10-01', id: 'tx-1' };

    it('reads an entry page off the date index without sorting it', async () => {
      const detail = await plan(
        ledgerEntryPageStatement({ budgetId: BUDGET_ID, limit: 50, cursor }),
      );

      expect(detail, detail).toContain('ledger_by_date');
      expect(detail, detail).not.toContain('USE TEMP B-TREE');
    });

    it('reads a transaction page off its own index, already ordered', async () => {
      const detail = await plan(
        transactionPageStatement({ budgetId: BUDGET_ID, limit: 50, cursor }),
      );

      // The page itself comes off the index with no sort. The two temp b-trees
      // further down the plan group and order the page — fifty rows — not the
      // budget, which is the whole reason the page is selected first.
      expect(detail, detail).toContain(
        'SEARCH ledger_entries USING COVERING INDEX ledger_by_date_transaction',
      );
    });

    it('drives the aggregation from the page, not from the budget', async () => {
      const detail = await plan(
        transactionPageStatement({ budgetId: BUDGET_ID, limit: 50, cursor }),
      );

      // `SCAN p` is the page; `e` is reached one transaction at a time. The
      // other way round — driving from the budget's entries and looking the
      // page up — reads every row in the budget to render fifty.
      expect(detail, detail).toContain('SCAN p');
      expect(detail, detail).toContain('SEARCH e USING INDEX ledger_by_transaction');
    });
  });
});
