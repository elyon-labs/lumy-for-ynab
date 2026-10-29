import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
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
import { rebuildLedgerForBudget, rebuildLedgerForTransactions } from './rebuild';

interface Entry {
  entry_id: string;
  transaction_id: string;
  is_subtransaction: number;
  date: string;
  month: string;
  account_id: string;
  payee_id: string | null;
  payee_name: string | null;
  category_id: string | null;
  category_group_id: string | null;
  amount: number;
  memo: string | null;
  flag_color: string | null;
  transfer_account_id: string | null;
  transfer_pair_key: string | null;
  is_transfer: number;
  is_income: number;
  is_starting_balance: number;
  is_expense: number;
}

describe('the ledger', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  async function entries(): Promise<Entry[]> {
    return db.all<Entry>('SELECT * FROM ledger_entries ORDER BY entry_id');
  }

  async function entry(id: string): Promise<Entry | undefined> {
    return db.get<Entry>('SELECT * FROM ledger_entries WHERE entry_id = ?', [id]);
  }

  async function rebuild(...ids: string[]): Promise<void> {
    await rebuildLedgerForTransactions(db, ids);
  }

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;

    await seedBudget(db);
    await seedAccount(db, { id: 'checking', name: 'Checking' });
    await seedAccount(db, { id: 'savings', name: 'Savings' });
    await seedPayee(db, { id: 'grocer', name: 'Grocer' });
    await seedPayee(db, { id: 'employer', name: 'Employer' });
    await seedPayee(db, { id: 'opening', name: 'Starting Balance' });
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

  describe('a simple transaction', () => {
    it('becomes one entry carrying its own category', async () => {
      await seedTransaction(db, {
        id: 'txn-1',
        accountId: 'checking',
        date: '2026-10-14',
        amount: -42_000,
        payeeId: 'grocer',
        payeeName: 'Grocer',
        categoryId: 'food',
        memo: 'Weekly shop',
        flagColor: 'red',
      });

      await rebuild('txn-1');

      expect(await entries()).toEqual([
        expect.objectContaining({
          entry_id: 'txn-1',
          transaction_id: 'txn-1',
          is_subtransaction: 0,
          date: '2026-10-14',
          month: '2026-10-01',
          account_id: 'checking',
          payee_id: 'grocer',
          payee_name: 'Grocer',
          category_id: 'food',
          category_group_id: 'everyday',
          amount: -42_000,
          memo: 'Weekly shop',
          flag_color: 'red',
          is_expense: 1,
          is_income: 0,
          is_starting_balance: 0,
          is_transfer: 0,
        }),
      ]);
    });

    it('resolves the payee name from the payee record rather than the payload', async () => {
      // The name on the transaction is a snapshot of what the payee was
      // called when the page was written.
      await seedTransaction(db, {
        id: 'txn-1',
        accountId: 'checking',
        payeeId: 'grocer',
        payeeName: 'The Old Name',
        categoryId: 'food',
      });

      await rebuild('txn-1');

      expect((await entry('txn-1'))?.payee_name).toBe('Grocer');
    });

    it('keeps a payee that exists only as a name', async () => {
      await seedTransaction(db, {
        id: 'txn-1',
        accountId: 'checking',
        payeeName: 'Cash',
        categoryId: 'food',
      });

      await rebuild('txn-1');

      expect(await entry('txn-1')).toMatchObject({ payee_id: null, payee_name: 'Cash' });
    });
  });

  describe('a split transaction', () => {
    beforeEach(async () => {
      await seedTransaction(db, {
        id: 'split',
        accountId: 'checking',
        date: '2026-09-03',
        amount: -30_000,
        payeeId: 'grocer',
        payeeName: 'Grocer',
        categoryId: null,
        memo: 'Big trip',
      });
    });

    it('becomes one entry per leg and none for the parent', async () => {
      await seedSubtransaction(db, {
        id: 'leg-a',
        transactionId: 'split',
        amount: -20_000,
        categoryId: 'food',
      });
      await seedSubtransaction(db, {
        id: 'leg-b',
        transactionId: 'split',
        amount: -10_000,
        categoryId: 'fun',
      });

      await rebuild('split');

      // The parent carries the sum; counting it alongside its legs is the
      // double-count this table exists to make impossible.
      const rows = await entries();
      expect(rows.map((row) => row.entry_id)).toEqual(['leg-a', 'leg-b']);
      expect(rows.reduce((total, row) => total + row.amount, 0)).toBe(-30_000);
      expect(rows.every((row) => row.transaction_id === 'split')).toBe(true);
      expect(rows.every((row) => row.is_subtransaction === 1)).toBe(true);
    });

    it("gives each leg the parent's date, account, and flag", async () => {
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'food' });

      await rebuild('split');

      expect(await entry('leg-a')).toMatchObject({
        date: '2026-09-03',
        month: '2026-09-01',
        account_id: 'checking',
      });
    });

    it("inherits the parent's payee where the leg has none", async () => {
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'food' });

      await rebuild('split');

      expect(await entry('leg-a')).toMatchObject({ payee_id: 'grocer', payee_name: 'Grocer' });
    });

    it("takes the leg's own payee where it has one", async () => {
      await seedSubtransaction(db, {
        id: 'leg-a',
        transactionId: 'split',
        categoryId: 'food',
        payeeId: 'employer',
      });

      await rebuild('split');

      expect(await entry('leg-a')).toMatchObject({ payee_id: 'employer', payee_name: 'Employer' });
    });

    it("inherits the parent's memo where the leg has none", async () => {
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'food' });
      await seedSubtransaction(db, {
        id: 'leg-b',
        transactionId: 'split',
        categoryId: 'fun',
        memo: 'The fun part',
      });

      await rebuild('split');

      expect((await entry('leg-a'))?.memo).toBe('Big trip');
      expect((await entry('leg-b'))?.memo).toBe('The fun part');
    });

    it('drops a deleted leg and keeps the rest', async () => {
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'food' });
      await seedSubtransaction(db, {
        id: 'leg-b',
        transactionId: 'split',
        categoryId: 'fun',
        deleted: true,
      });

      await rebuild('split');

      expect((await entries()).map((row) => row.entry_id)).toEqual(['leg-a']);
    });

    it('becomes a simple transaction again when its legs go', async () => {
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'food' });
      await seedSubtransaction(db, { id: 'leg-b', transactionId: 'split', categoryId: 'fun' });
      await rebuild('split');

      // What reconciliation does when YNAB stops sending the legs: they are
      // removed outright, and the parent carries a real category again.
      await db.run('DELETE FROM subtransactions WHERE transaction_id = ?', ['split']);
      await db.run('UPDATE transactions SET category_id = ? WHERE id = ?', ['food', 'split']);
      await rebuild('split');

      const rows = await entries();
      expect(rows.map((row) => row.entry_id)).toEqual(['split']);
      expect(rows[0]).toMatchObject({ is_subtransaction: 0, amount: -30_000, category_id: 'food' });
    });
  });

  describe('classification', () => {
    it('counts Inflow: Ready to Assign as income', async () => {
      await seedTransaction(db, {
        id: 'pay',
        accountId: 'checking',
        amount: 250_000,
        payeeId: 'employer',
        categoryId: 'ready',
      });

      await rebuild('pay');

      expect(await entry('pay')).toMatchObject({
        is_income: 1,
        is_expense: 0,
        is_starting_balance: 0,
      });
    });

    it('counts a Starting Balance as neither income nor expense', async () => {
      // YNAB categorises it to Ready to Assign, so the payee is the only
      // thing that tells it apart from a paycheque.
      await seedTransaction(db, {
        id: 'opening-balance',
        accountId: 'checking',
        amount: 1_000_000,
        payeeId: 'opening',
        categoryId: 'ready',
      });

      await rebuild('opening-balance');

      expect(await entry('opening-balance')).toMatchObject({
        is_starting_balance: 1,
        is_income: 0,
        is_expense: 0,
      });
    });

    it('counts an uncategorised transaction as neither', async () => {
      await seedTransaction(db, { id: 'txn-1', accountId: 'checking', categoryId: null });

      await rebuild('txn-1');

      expect(await entry('txn-1')).toMatchObject({
        is_expense: 0,
        is_income: 0,
        is_starting_balance: 0,
      });
    });

    it("classifies a leg on its own category, not the parent's", async () => {
      await seedTransaction(db, {
        id: 'split',
        accountId: 'checking',
        amount: 100_000,
        payeeId: 'employer',
        categoryId: null,
      });
      await seedSubtransaction(db, {
        id: 'leg-pay',
        transactionId: 'split',
        amount: 150_000,
        categoryId: 'ready',
      });
      await seedSubtransaction(db, {
        id: 'leg-spend',
        transactionId: 'split',
        amount: -50_000,
        categoryId: 'food',
      });

      await rebuild('split');

      expect(await entry('leg-pay')).toMatchObject({ is_income: 1, is_expense: 0 });
      expect(await entry('leg-spend')).toMatchObject({ is_income: 0, is_expense: 1 });
    });
  });

  describe('transfers', () => {
    it('gives both sides the same pair key', async () => {
      await seedTransaction(db, {
        id: 'out',
        accountId: 'checking',
        amount: -75_000,
        transferAccountId: 'savings',
        transferTransactionId: 'in',
      });
      await seedTransaction(db, {
        id: 'in',
        accountId: 'savings',
        amount: 75_000,
        transferAccountId: 'checking',
        transferTransactionId: 'out',
      });

      await rebuild('out', 'in');

      const rows = await entries();
      expect(rows.map((row) => row.is_transfer)).toEqual([1, 1]);
      expect(new Set(rows.map((row) => row.transfer_pair_key)).size).toBe(1);
    });

    it('pairs a transfer out of a split leg with the whole transaction facing it', async () => {
      // The leg's id is what the other side points at, so a key built from
      // transaction ids would give the two sides different answers and leave
      // each of them electing itself.
      await seedTransaction(db, { id: 'split', accountId: 'checking', amount: -75_000 });
      await seedSubtransaction(db, {
        id: 'leg-transfer',
        transactionId: 'split',
        amount: -75_000,
        transferAccountId: 'savings',
        transferTransactionId: 'in',
      });
      await seedTransaction(db, {
        id: 'in',
        accountId: 'savings',
        amount: 75_000,
        transferAccountId: 'checking',
        transferTransactionId: 'leg-transfer',
      });

      await rebuild('split', 'in');

      const keys = (await entries()).map((row) => row.transfer_pair_key);
      expect(keys).toEqual(['in:leg-transfer', 'in:leg-transfer']);
    });

    it('leaves the key empty when the other side is unknown', async () => {
      await seedTransaction(db, {
        id: 'out',
        accountId: 'checking',
        transferAccountId: 'savings',
        transferTransactionId: null,
      });

      await rebuild('out');

      expect(await entry('out')).toMatchObject({ is_transfer: 1, transfer_pair_key: null });
    });
  });

  describe('what produces nothing', () => {
    it('a deleted transaction', async () => {
      await seedTransaction(db, { id: 'txn-1', accountId: 'checking', deleted: true });

      await rebuild('txn-1');

      expect(await entries()).toEqual([]);
    });

    it('a deleted parent, legs and all', async () => {
      await seedTransaction(db, { id: 'split', accountId: 'checking', deleted: true });
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'food' });

      await rebuild('split');

      expect(await entries()).toEqual([]);
    });

    it('a transaction another one claims as its match', async () => {
      await seedTransaction(db, { id: 'imported', accountId: 'checking', amount: -12_000 });
      await seedTransaction(db, {
        id: 'manual',
        accountId: 'checking',
        amount: -12_000,
        matchedTransactionId: 'imported',
      });

      await rebuild('imported', 'manual');

      expect((await entries()).map((row) => row.entry_id)).toEqual(['manual']);
    });

    it('nothing, once the match is itself deleted', async () => {
      await seedTransaction(db, { id: 'imported', accountId: 'checking' });
      await seedTransaction(db, {
        id: 'manual',
        accountId: 'checking',
        matchedTransactionId: 'imported',
        deleted: true,
      });

      await rebuild('imported', 'manual');

      expect((await entries()).map((row) => row.entry_id)).toEqual(['imported']);
    });
  });

  describe('rebuilding', () => {
    beforeEach(async () => {
      await seedTransaction(db, { id: 'txn-1', accountId: 'checking', categoryId: 'food' });
      await seedTransaction(db, { id: 'txn-2', accountId: 'checking', categoryId: 'fun' });
    });

    it('changes nothing when it runs again', async () => {
      await rebuild('txn-1', 'txn-2');
      const first = await entries();

      await rebuild('txn-1', 'txn-2');

      expect(await entries()).toEqual(first);
    });

    it('leaves the transactions it was not asked about alone', async () => {
      await rebuild('txn-1', 'txn-2');

      await db.run('UPDATE transactions SET deleted = 1 WHERE id = ?', ['txn-2']);
      await rebuild('txn-1');

      expect((await entries()).map((row) => row.entry_id)).toEqual(['txn-1', 'txn-2']);
    });

    it('takes a stale entry with it when a transaction is deleted', async () => {
      await rebuild('txn-1', 'txn-2');

      await db.run('UPDATE transactions SET deleted = 1 WHERE id = ?', ['txn-2']);
      await rebuild('txn-2');

      expect((await entries()).map((row) => row.entry_id)).toEqual(['txn-1']);
    });

    it('revisits a transaction that a newly matched one displaces', async () => {
      // Only the matching transaction is in the page. The one it displaces
      // has to be re-derived anyway, or its entry survives as a duplicate.
      await rebuild('txn-1', 'txn-2');
      await db.run('UPDATE transactions SET matched_transaction_id = ? WHERE id = ?', [
        'txn-1',
        'txn-2',
      ]);

      await rebuild('txn-2');

      expect((await entries()).map((row) => row.entry_id)).toEqual(['txn-2']);
    });

    it('accepts an id that is not there', async () => {
      await expect(rebuild('never-synced')).resolves.toBeUndefined();

      expect(await entries()).toEqual([]);
    });

    it('accepts no ids at all', async () => {
      await expect(rebuild()).resolves.toBeUndefined();
    });

    it('goes in chunks past the parameter limit', async () => {
      const ids = Array.from({ length: 950 }, (_, index) => `bulk-${index}`);
      for (const id of ids) {
        await seedTransaction(db, { id, accountId: 'checking', categoryId: 'food' });
      }

      await rebuildLedgerForTransactions(db, ids);

      const row = await db.get<{ n: number }>(
        "SELECT COUNT(*) AS n FROM ledger_entries WHERE entry_id LIKE 'bulk-%'",
      );
      expect(row?.n).toBe(950);
    });
  });

  describe('rebuilding a whole budget', () => {
    it('derives the same entries as rebuilding each transaction', async () => {
      await seedTransaction(db, { id: 'txn-1', accountId: 'checking', categoryId: 'food' });
      await seedTransaction(db, { id: 'split', accountId: 'checking', payeeId: 'grocer' });
      await seedSubtransaction(db, { id: 'leg-a', transactionId: 'split', categoryId: 'fun' });
      await rebuild('txn-1', 'split');
      const incremental = await entries();

      await rebuildLedgerForBudget(db, BUDGET_ID);

      expect(await entries()).toEqual(incremental);
    });

    it('clears entries the raw tables no longer justify', async () => {
      await seedTransaction(db, { id: 'txn-1', accountId: 'checking', categoryId: 'food' });
      await rebuild('txn-1');

      await db.run('UPDATE transactions SET deleted = 1');
      await rebuildLedgerForBudget(db, BUDGET_ID);

      expect(await entries()).toEqual([]);
    });

    it('leaves another budget alone', async () => {
      await seedBudget(db, { id: 'other', name: 'Other' });
      await seedAccount(db, { id: 'other-account', budgetId: 'other' });
      await seedTransaction(db, {
        id: 'other-txn',
        budgetId: 'other',
        accountId: 'other-account',
        categoryId: 'food',
      });
      await rebuild('other-txn');

      await rebuildLedgerForBudget(db, BUDGET_ID);

      expect((await entries()).map((row) => row.entry_id)).toEqual(['other-txn']);
    });
  });

  it('goes when its transaction does', async () => {
    await seedTransaction(db, { id: 'txn-1', accountId: 'checking', categoryId: 'food' });
    await rebuild('txn-1');

    await db.run('DELETE FROM transactions WHERE id = ?', ['txn-1']);

    expect(await entries()).toEqual([]);
  });
});
