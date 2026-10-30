import { milliunits, type Milliunits } from '@lumy/money';
import type {
  Account,
  Budget,
  Category,
  CategoryGroup,
  Month,
  Payee,
  ScheduledSubtransaction,
  ScheduledTransaction,
  SingleMonth,
  Subtransaction,
  Transaction,
} from '@lumy/ynab';

import { BUDGET_ID } from './fixtures';

/**
 * YNAB entities as the client hands them over, built from the few fields a
 * test is about.
 *
 * These are the parsed shapes rather than wire payloads: `packages/ynab` owns
 * the parse and tests it against its own fixtures, so repeating raw JSON here
 * would only assert that the schemas still work. What the sync engine's tests
 * are about is what it does with an entity once it has one.
 */

function amount(value: number): Milliunits {
  return milliunits(value);
}

export function aBudget(budget: Partial<Budget> = {}): Budget {
  return {
    id: BUDGET_ID,
    name: 'Test Budget',
    firstMonth: '2024-01-01',
    lastMonth: '2026-12-01',
    lastModifiedOn: '2026-10-29T00:00:00Z',
    currencyFormat: {
      isoCode: 'USD',
      decimalDigits: 2,
      decimalSeparator: '.',
      groupSeparator: ',',
      currencySymbol: '$',
      symbolFirst: true,
      displaySymbol: true,
      exampleFormat: '123,456.78',
    },
    ...budget,
  };
}

export function anAccount(id: string, account: Partial<Account> = {}): Account {
  return {
    id,
    name: id,
    type: 'checking',
    onBudget: true,
    closed: false,
    balance: amount(0),
    deleted: false,
    debtMonths: [],
    ...account,
  };
}

export function aPayee(id: string, name: string, payee: Partial<Payee> = {}): Payee {
  return { id, name, transferAccountId: null, deleted: false, ...payee };
}

export interface CategoryDraft
  extends Partial<Omit<Category, 'budgeted' | 'activity' | 'balance'>> {
  budgeted?: number;
  activity?: number;
  balance?: number;
}

export function aCategory(
  id: string,
  name: string,
  categoryGroupId: string,
  category: CategoryDraft = {},
): Category {
  return {
    id,
    name,
    categoryGroupId,
    hidden: false,
    deleted: false,
    target: {
      type: null,
      needsWholeAmount: null,
      day: null,
      cadence: null,
      cadenceFrequency: null,
      creationMonth: null,
      balance: null,
      month: null,
      percentageComplete: null,
      monthsToBudget: null,
      underFunded: null,
      overallFunded: null,
      overallLeft: null,
    },
    ...category,
    budgeted: amount(category.budgeted ?? 0),
    activity: amount(category.activity ?? 0),
    balance: amount(category.balance ?? 0),
  };
}

export function aCategoryGroup(
  id: string,
  name: string,
  categories: readonly Category[],
  group: Partial<CategoryGroup> = {},
): CategoryGroup {
  return { id, name, hidden: false, deleted: false, categories: [...categories], ...group };
}

export function aMonth(month: string, overrides: Partial<Month> = {}): Month {
  return {
    month,
    note: null,
    income: amount(0),
    budgeted: amount(0),
    activity: amount(0),
    toBeBudgeted: amount(0),
    ageOfMoney: null,
    deleted: false,
    ...overrides,
  };
}

export function aMonthDetail(
  month: string,
  categories: readonly Category[],
  overrides: Partial<Month> = {},
): SingleMonth {
  return { ...aMonth(month, overrides), categories: [...categories] };
}

export interface SubtransactionDraft extends Partial<Omit<Subtransaction, 'amount'>> {
  id: string;
  amount?: number;
}

export interface TransactionDraft extends Partial<Omit<Transaction, 'amount' | 'subtransactions'>> {
  id: string;
  amount?: number;
  subtransactions?: readonly SubtransactionDraft[];
}

export function aTransaction(draft: TransactionDraft): Transaction {
  return {
    date: '2026-10-01',
    accountId: 'checking',
    payeeId: null,
    payeeName: null,
    categoryId: null,
    categoryName: null,
    memo: null,
    cleared: 'cleared',
    approved: true,
    flagColor: null,
    transferAccountId: null,
    transferTransactionId: null,
    matchedTransactionId: null,
    importId: null,
    deleted: false,
    ...draft,
    amount: amount(draft.amount ?? -10_000),
    subtransactions: (draft.subtransactions ?? []).map((leg) => ({
      transactionId: draft.id,
      payeeId: null,
      payeeName: null,
      categoryId: null,
      categoryName: null,
      memo: null,
      transferAccountId: null,
      transferTransactionId: null,
      deleted: false,
      ...leg,
      amount: amount(leg.amount ?? -5_000),
    })),
  };
}

export interface ScheduledSubtransactionDraft
  extends Partial<Omit<ScheduledSubtransaction, 'amount'>> {
  id: string;
  amount?: number;
}

export interface ScheduledTransactionDraft
  extends Partial<Omit<ScheduledTransaction, 'amount' | 'subtransactions'>> {
  id: string;
  amount?: number;
  subtransactions?: readonly ScheduledSubtransactionDraft[];
}

export function aScheduledTransaction(draft: ScheduledTransactionDraft): ScheduledTransaction {
  return {
    dateFirst: '2026-11-01',
    dateNext: '2026-11-01',
    frequency: 'monthly',
    accountId: 'checking',
    accountName: 'Checking',
    payeeId: null,
    payeeName: null,
    categoryId: null,
    categoryName: null,
    memo: null,
    flagColor: null,
    flagName: null,
    transferAccountId: null,
    deleted: false,
    ...draft,
    amount: amount(draft.amount ?? -10_000),
    subtransactions: (draft.subtransactions ?? []).map((leg) => ({
      scheduledTransactionId: draft.id,
      payeeId: null,
      categoryId: null,
      memo: null,
      transferAccountId: null,
      deleted: false,
      ...leg,
      amount: amount(leg.amount ?? -5_000),
    })),
  };
}
