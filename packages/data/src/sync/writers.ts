import type {
  Account,
  Budget,
  CategoryGroup,
  Month,
  Payee,
  ScheduledTransaction,
  SingleMonth,
  Transaction,
} from '@lumy/ynab';

import type { Queryable, SqlValue } from '../adapters/types';
import { rebuildLedgerForReferences, rebuildLedgerForTransactions } from '../ledger';
import {
  accountDebtMonthRows,
  accountRows,
  budgetRows,
  categoryGroupRows,
  categoryMonthRows,
  categoryRows,
  currencyFormatRows,
  monthRows,
  payeeRows,
  scheduledSubtransactionRows,
  scheduledTransactionRows,
  subtransactionRows,
  transactionRows,
} from './rows';
import { deleteWhereIn, upsert } from './upsert';

/**
 * Writing a YNAB payload into the raw tables.
 *
 * Every function here takes the `Queryable` of the transaction it must commit
 * with, writes by id, and — where the payload carries a set of children —
 * reconciles that set rather than upserting what arrived. The second part is
 * the duplicate-transaction fix: YNAB does not reliably report a removed
 * subtransaction as deleted, it simply stops sending it, so upserting what is
 * in the payload leaves the others behind forever, counted and visible.
 *
 * The writers that change what the ledger derived also rebuild it, in the same
 * transaction, so a derived row and the raw row it came from can never
 * disagree.
 *
 * The payload-to-row mapping lives in `rows.ts`, which the snapshot verifier
 * reads from too.
 */

export async function writeBudgets(tx: Queryable, budgets: readonly Budget[]): Promise<void> {
  await upsert(tx, { table: 'budgets', conflict: ['id'], rows: budgetRows(budgets) });
  await upsert(tx, {
    table: 'currency_formats',
    conflict: ['budget_id'],
    rows: currencyFormatRows(budgets),
  });
}

export async function writeAccounts(
  tx: Queryable,
  budgetId: string,
  accounts: readonly Account[],
): Promise<void> {
  await upsert(tx, { table: 'accounts', conflict: ['id'], rows: accountRows(budgetId, accounts) });

  // YNAB sends an account's loan maps whole, so the months it did not mention
  // are months the account no longer has figures for.
  await deleteWhereIn(
    tx,
    'account_debt_months',
    'account_id',
    accounts.map((account) => account.id),
  );

  await upsert(tx, {
    table: 'account_debt_months',
    conflict: ['account_id', 'month'],
    rows: accountDebtMonthRows(budgetId, accounts),
  });
}

/**
 * The names a payee is known by before this page, for the ids it carries.
 *
 * A payee the client has not seen is reported as a change, because the
 * entries that referenced it by id resolved their name from the transaction
 * row instead and that fallback may have said something else.
 */
async function changedPayeeNames(
  tx: Queryable,
  payees: readonly Payee[],
): Promise<readonly string[]> {
  if (payees.length === 0) return [];

  const rows = await tx.all<{ id: string; name: string }>(
    `SELECT id, name FROM payees WHERE id IN (${payees.map(() => '?').join(', ')})`,
    payees.map((payee) => payee.id) as SqlValue[],
  );
  const known = new Map(rows.map((row) => [row.id, row.name]));

  return payees.filter((payee) => known.get(payee.id) !== payee.name).map((payee) => payee.id);
}

export async function writePayees(
  tx: Queryable,
  budgetId: string,
  payees: readonly Payee[],
): Promise<void> {
  const renamed = await changedPayeeNames(tx, payees);

  await upsert(tx, { table: 'payees', conflict: ['id'], rows: payeeRows(budgetId, payees) });

  await rebuildLedgerForReferences(tx, budgetId, { payeeIds: renamed });
}

/** What a category was called, and which group it was in, before this page. */
async function changedCategoryResolutions(
  tx: Queryable,
  groups: readonly CategoryGroup[],
): Promise<readonly string[]> {
  const categories = groups.flatMap((group) => group.categories);
  if (categories.length === 0) return [];

  const rows = await tx.all<{ id: string; name: string; category_group_id: string }>(
    `SELECT id, name, category_group_id FROM categories WHERE id IN (${categories
      .map(() => '?')
      .join(', ')})`,
    categories.map((category) => category.id) as SqlValue[],
  );
  const known = new Map(rows.map((row) => [row.id, row]));

  return categories
    .filter((category) => {
      const before = known.get(category.id);

      return (
        before === undefined ||
        before.name !== category.name ||
        before.category_group_id !== category.categoryGroupId
      );
    })
    .map((category) => category.id);
}

export async function writeCategories(
  tx: Queryable,
  budgetId: string,
  groups: readonly CategoryGroup[],
): Promise<void> {
  const changed = await changedCategoryResolutions(tx, groups);

  await upsert(tx, {
    table: 'category_groups',
    conflict: ['id'],
    rows: categoryGroupRows(budgetId, groups),
  });

  await upsert(tx, {
    table: 'categories',
    conflict: ['id'],
    rows: categoryRows(budgetId, groups),
  });

  await rebuildLedgerForReferences(tx, budgetId, { categoryIds: changed });
}

export async function writeMonths(
  tx: Queryable,
  budgetId: string,
  months: readonly Month[],
): Promise<void> {
  await upsert(tx, {
    table: 'months',
    conflict: ['budget_id', 'month'],
    rows: monthRows(budgetId, months),
  });
}

/**
 * Writes one month's detail: the summary, and every category's figures for it.
 *
 * The categories endpoint reports only whichever month YNAB considers current,
 * so this is the sole source of per-month category figures and therefore the
 * only writer of `category_months`. Those rows are reconciled for the month
 * rather than upserted, because the payload describes the month completely.
 */
export async function writeMonthDetail(
  tx: Queryable,
  budgetId: string,
  month: SingleMonth,
): Promise<void> {
  await writeMonths(tx, budgetId, [month]);

  await tx.run('DELETE FROM category_months WHERE budget_id = ? AND month = ?', [
    budgetId,
    month.month,
  ]);

  await upsert(tx, {
    table: 'category_months',
    conflict: ['category_id', 'month'],
    rows: categoryMonthRows(budgetId, month),
  });
}

/**
 * Writes a page of transactions, reconciles each parent's legs, and re-derives
 * the ledger for everything the page touched.
 *
 * The legs are deleted per parent and reinserted from the payload. A parent
 * that arrived without legs therefore loses the ones it had, which is correct
 * both for a split reduced back to a simple transaction and for a simple
 * transaction that never had any: YNAB's transaction payload always carries
 * the full set, and silence means the set is empty.
 */
export async function writeTransactions(
  tx: Queryable,
  budgetId: string,
  transactions: readonly Transaction[],
): Promise<void> {
  const ids = transactions.map((transaction) => transaction.id);

  await upsert(tx, {
    table: 'transactions',
    conflict: ['id'],
    rows: transactionRows(budgetId, transactions),
  });

  await deleteWhereIn(tx, 'subtransactions', 'transaction_id', ids);

  await upsert(tx, {
    table: 'subtransactions',
    conflict: ['id'],
    rows: subtransactionRows(budgetId, transactions),
  });

  await rebuildLedgerForTransactions(tx, ids);
}

/**
 * Writes a page of scheduled transactions and reconciles their legs.
 *
 * No ledger work: nothing has happened yet, so a scheduled transaction is not
 * a spendable leaf. The recurring screens read these tables directly.
 */
export async function writeScheduledTransactions(
  tx: Queryable,
  budgetId: string,
  scheduled: readonly ScheduledTransaction[],
): Promise<void> {
  await upsert(tx, {
    table: 'scheduled_transactions',
    conflict: ['id'],
    rows: scheduledTransactionRows(budgetId, scheduled),
  });

  await deleteWhereIn(
    tx,
    'scheduled_subtransactions',
    'scheduled_transaction_id',
    scheduled.map((transaction) => transaction.id),
  );

  await upsert(tx, {
    table: 'scheduled_subtransactions',
    conflict: ['id'],
    rows: scheduledSubtransactionRows(budgetId, scheduled),
  });
}
