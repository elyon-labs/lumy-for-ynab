import type {
  Account,
  Budget,
  Category,
  CategoryGroup,
  Month,
  Payee,
  ScheduledTransaction,
  SingleMonth,
  Transaction,
} from '@lumy/ynab';

import type { Row } from '../adapters/types';

/**
 * A YNAB entity as a row of the table that holds it.
 *
 * One definition per table, shared by the writer that stores a payload and the
 * verifier that diffs a snapshot against what is stored. Two mappings of the
 * same entity would mean a verifier that agrees with a writer's mistake, or
 * reports a divergence that is only its own disagreement.
 */

/** SQLite has no boolean type; the schema stores these as 0 and 1. */
export function flag(value: boolean): number {
  return value ? 1 : 0;
}

export function budgetRows(budgets: readonly Budget[]): Row[] {
  return budgets.map((budget) => ({
    id: budget.id,
    name: budget.name,
    first_month: budget.firstMonth,
    last_month: budget.lastMonth,
    last_modified_on: budget.lastModifiedOn,
  }));
}

export function currencyFormatRows(budgets: readonly Budget[]): Row[] {
  // A budget YNAB returns without a currency format gets no row rather than a
  // row of defaults: the formatter falls back on its own, and a stored guess
  // would be indistinguishable from the real thing.
  return budgets.flatMap((budget) =>
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
  );
}

export function accountRows(budgetId: string, accounts: readonly Account[]): Row[] {
  return accounts.map((account) => ({
    id: account.id,
    budget_id: budgetId,
    name: account.name,
    type: account.type,
    on_budget: flag(account.onBudget),
    closed: flag(account.closed),
    deleted: flag(account.deleted),
    balance: account.balance,
  }));
}

export function accountDebtMonthRows(budgetId: string, accounts: readonly Account[]): Row[] {
  return accounts.flatMap((account) =>
    account.debtMonths.map((debtMonth) => ({
      account_id: account.id,
      month: debtMonth.month,
      budget_id: budgetId,
      interest_rate: debtMonth.interestRate,
      minimum_payment: debtMonth.minimumPayment,
      escrow_amount: debtMonth.escrowAmount,
    })),
  );
}

export function payeeRows(budgetId: string, payees: readonly Payee[]): Row[] {
  return payees.map((payee) => ({
    id: payee.id,
    budget_id: budgetId,
    name: payee.name,
    deleted: flag(payee.deleted),
  }));
}

export function categoryGroupRows(budgetId: string, groups: readonly CategoryGroup[]): Row[] {
  return groups.map((group, index) => ({
    id: group.id,
    budget_id: budgetId,
    name: group.name,
    hidden: flag(group.hidden),
    deleted: flag(group.deleted),
    sort_order: index,
  }));
}

/**
 * The categories of a payload, whose nesting is also their ordering.
 *
 * YNAB sends no sort field for groups or categories: the array position is the
 * only statement it makes about the budget's order, so it is captured as the
 * page is read or it is lost. That is why the resource is always fetched whole
 * — see `supportsDelta`.
 */
export function categoryRows(budgetId: string, groups: readonly CategoryGroup[]): Row[] {
  return groups.flatMap((group) =>
    group.categories.map((category, index) => ({
      id: category.id,
      budget_id: budgetId,
      category_group_id: category.categoryGroupId,
      name: category.name,
      hidden: flag(category.hidden),
      deleted: flag(category.deleted),
      sort_order: index,
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
  );
}

export function monthRows(budgetId: string, months: readonly Month[]): Row[] {
  return months.map((month) => ({
    budget_id: budgetId,
    month: month.month,
    note: month.note,
    income: month.income,
    budgeted: month.budgeted,
    activity: month.activity,
    to_be_budgeted: month.toBeBudgeted,
    age_of_money: month.ageOfMoney,
    deleted: flag(month.deleted),
  }));
}

export function categoryMonthRows(budgetId: string, month: SingleMonth): Row[] {
  return month.categories.map((category: Category) => ({
    category_id: category.id,
    month: month.month,
    budget_id: budgetId,
    budgeted: category.budgeted,
    activity: category.activity,
    balance: category.balance,
  }));
}

export function transactionRows(budgetId: string, transactions: readonly Transaction[]): Row[] {
  return transactions.map((transaction) => ({
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
  }));
}

export function subtransactionRows(
  budgetId: string,
  transactions: readonly Transaction[],
): Row[] {
  return transactions.flatMap((transaction) =>
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
  );
}

export function scheduledTransactionRows(
  budgetId: string,
  scheduled: readonly ScheduledTransaction[],
): Row[] {
  return scheduled.map((transaction) => ({
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
  }));
}

export function scheduledSubtransactionRows(
  budgetId: string,
  scheduled: readonly ScheduledTransaction[],
): Row[] {
  return scheduled.flatMap((transaction) =>
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
  );
}
