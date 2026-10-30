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
import { deleteWhereIn, flag, upsert } from './upsert';

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
 */

export async function writeBudgets(tx: Queryable, budgets: readonly Budget[]): Promise<void> {
  await upsert(tx, {
    table: 'budgets',
    conflict: ['id'],
    rows: budgets.map((budget) => ({
      id: budget.id,
      name: budget.name,
      first_month: budget.firstMonth,
      last_month: budget.lastMonth,
      last_modified_on: budget.lastModifiedOn,
    })),
  });

  await upsert(tx, {
    table: 'currency_formats',
    conflict: ['budget_id'],
    // A budget YNAB returns without a currency format gets no row rather than
    // a row of defaults: the formatter falls back on its own, and a stored
    // guess would be indistinguishable from the real thing.
    rows: budgets.flatMap((budget) =>
      budget.currencyFormat === null
        ? []
        : [
            {
              budget_id: budget.id,
              iso_code: budget.currencyFormat.isoCode,
              decimal_digits: budget.currencyFormat.decimalDigits,
              decimal_separator: budget.currencyFormat.decimalSeparator,
              symbol_first: flag(budget.currencyFormat.symbolFirst),
              group_separator: budget.currencyFormat.groupSeparator,
              currency_symbol: budget.currencyFormat.currencySymbol,
              display_symbol: flag(budget.currencyFormat.displaySymbol),
              example_format: budget.currencyFormat.exampleFormat,
            },
          ],
    ),
  });
}

export async function writeAccounts(
  tx: Queryable,
  budgetId: string,
  accounts: readonly Account[],
): Promise<void> {
  await upsert(tx, {
    table: 'accounts',
    conflict: ['id'],
    rows: accounts.map((account) => ({
      id: account.id,
      budget_id: budgetId,
      name: account.name,
      type: account.type,
      on_budget: flag(account.onBudget),
      closed: flag(account.closed),
      deleted: flag(account.deleted),
      balance: account.balance,
    })),
  });

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
    rows: accounts.flatMap((account) =>
      account.debtMonths.map((debtMonth) => ({
        account_id: account.id,
        month: debtMonth.month,
        budget_id: budgetId,
        interest_rate: debtMonth.interestRate,
        minimum_payment: debtMonth.minimumPayment,
        escrow_amount: debtMonth.escrowAmount,
      })),
    ),
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

  await upsert(tx, {
    table: 'payees',
    conflict: ['id'],
    rows: payees.map((payee) => ({
      id: payee.id,
      budget_id: budgetId,
      name: payee.name,
      deleted: flag(payee.deleted),
    })),
  });

  await rebuildLedgerForReferences(tx, budgetId, { payeeIds: renamed });
}

/** What a category was called, and which group it was in, before this page. */
async function changedCategoryResolutions(
  tx: Queryable,
  categories: readonly { id: string; name: string; categoryGroupId: string }[],
): Promise<readonly string[]> {
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

/**
 * Writes the categories payload, whose nesting is also its ordering.
 *
 * YNAB sends no sort field for groups or categories: the array position is the
 * only statement it makes about the budget's order, so it is captured as the
 * page is written or it is lost. That is why this resource is always fetched
 * whole — see `supportsDelta`.
 */
export async function writeCategories(
  tx: Queryable,
  budgetId: string,
  groups: readonly CategoryGroup[],
): Promise<void> {
  const categories = groups.flatMap((group) =>
    group.categories.map((category, index) => ({ ...category, sortOrder: index })),
  );
  const changed = await changedCategoryResolutions(tx, categories);

  await upsert(tx, {
    table: 'category_groups',
    conflict: ['id'],
    rows: groups.map((group, index) => ({
      id: group.id,
      budget_id: budgetId,
      name: group.name,
      hidden: flag(group.hidden),
      deleted: flag(group.deleted),
      sort_order: index,
    })),
  });

  await upsert(tx, {
    table: 'categories',
    conflict: ['id'],
    rows: categories.map((category) => ({
      id: category.id,
      budget_id: budgetId,
      category_group_id: category.categoryGroupId,
      name: category.name,
      hidden: flag(category.hidden),
      deleted: flag(category.deleted),
      sort_order: category.sortOrder,
      target_type: category.target.type,
      target_needs_whole_amount:
        category.target.needsWholeAmount === null ? null : flag(category.target.needsWholeAmount),
      target_day: category.target.day,
      target_cadence: category.target.cadence,
      target_cadence_frequency: category.target.cadenceFrequency,
      target_creation_month: category.target.creationMonth,
      target_balance: category.target.balance,
      target_month: category.target.month,
      target_percentage_complete: category.target.percentageComplete,
      target_months_to_budget: category.target.monthsToBudget,
      target_under_funded: category.target.underFunded,
      target_overall_funded: category.target.overallFunded,
      target_overall_left: category.target.overallLeft,
    })),
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
    rows: months.map((month) => ({
      budget_id: budgetId,
      month: month.month,
      note: month.note,
      income: month.income,
      budgeted: month.budgeted,
      activity: month.activity,
      to_be_budgeted: month.toBeBudgeted,
      age_of_money: month.ageOfMoney,
      deleted: flag(month.deleted),
    })),
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
    rows: month.categories.map((category) => ({
      category_id: category.id,
      month: month.month,
      budget_id: budgetId,
      budgeted: category.budgeted,
      activity: category.activity,
      balance: category.balance,
    })),
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
    rows: transactions.map((transaction) => ({
      id: transaction.id,
      budget_id: budgetId,
      date: transaction.date,
      account_id: transaction.accountId,
      amount: transaction.amount,
      payee_id: transaction.payeeId,
      payee_name: transaction.payeeName,
      category_id: transaction.categoryId,
      category_name: transaction.categoryName,
      memo: transaction.memo,
      flag_color: transaction.flagColor,
      cleared: transaction.cleared,
      approved: flag(transaction.approved),
      transfer_account_id: transaction.transferAccountId,
      transfer_transaction_id: transaction.transferTransactionId,
      matched_transaction_id: transaction.matchedTransactionId,
      import_id: transaction.importId,
      deleted: flag(transaction.deleted),
    })),
  });

  await deleteWhereIn(tx, 'subtransactions', 'transaction_id', ids);

  await upsert(tx, {
    table: 'subtransactions',
    conflict: ['id'],
    rows: transactions.flatMap((transaction) =>
      transaction.subtransactions.map((leg) => ({
        id: leg.id,
        transaction_id: transaction.id,
        budget_id: budgetId,
        amount: leg.amount,
        payee_id: leg.payeeId,
        payee_name: leg.payeeName,
        category_id: leg.categoryId,
        category_name: leg.categoryName,
        memo: leg.memo,
        transfer_account_id: leg.transferAccountId,
        transfer_transaction_id: leg.transferTransactionId,
        deleted: flag(leg.deleted),
      })),
    ),
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
    rows: scheduled.map((transaction) => ({
      id: transaction.id,
      budget_id: budgetId,
      date_first: transaction.dateFirst,
      date_next: transaction.dateNext,
      frequency: transaction.frequency,
      account_id: transaction.accountId,
      account_name: transaction.accountName,
      amount: transaction.amount,
      payee_id: transaction.payeeId,
      payee_name: transaction.payeeName,
      category_id: transaction.categoryId,
      category_name: transaction.categoryName,
      memo: transaction.memo,
      flag_color: transaction.flagColor,
      flag_name: transaction.flagName,
      transfer_account_id: transaction.transferAccountId,
      deleted: flag(transaction.deleted),
    })),
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
    rows: scheduled.flatMap((transaction) =>
      transaction.subtransactions.map((leg) => ({
        id: leg.id,
        scheduled_transaction_id: transaction.id,
        budget_id: budgetId,
        amount: leg.amount,
        payee_id: leg.payeeId,
        category_id: leg.categoryId,
        memo: leg.memo,
        transfer_account_id: leg.transferAccountId,
        deleted: flag(leg.deleted),
      })),
    ),
  });
}
