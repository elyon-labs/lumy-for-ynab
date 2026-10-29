import type { Queryable, SqlValue } from '../adapters/types';

/**
 * Rows to write a test against.
 *
 * Every helper takes the few fields the test is about and fills the rest with
 * something valid, so a test reads as the one thing it is asserting rather
 * than as a column list. They write the raw tables directly: the sync engine
 * is what these will later be used to test, so they must not go through it.
 */

export const BUDGET_ID = 'budget-1';

function insert(table: string, values: Record<string, SqlValue>): [string, SqlValue[]] {
  const columns = Object.keys(values);
  const placeholders = columns.map(() => '?').join(', ');

  return [
    `INSERT INTO ${table} (${columns.join(', ')}) VALUES (${placeholders})`,
    Object.values(values),
  ];
}

async function write(db: Queryable, table: string, values: Record<string, SqlValue>): Promise<void> {
  const [sql, params] = insert(table, values);
  await db.run(sql, params);
}

export interface BudgetFixture {
  id?: string;
  name?: string;
}

export async function seedBudget(db: Queryable, budget: BudgetFixture = {}): Promise<string> {
  const id = budget.id ?? BUDGET_ID;

  await write(db, 'budgets', {
    id,
    name: budget.name ?? 'Test Budget',
    first_month: '2024-01-01',
    last_month: '2026-12-01',
    last_modified_on: '2026-10-29T00:00:00Z',
  });

  return id;
}

export interface AccountFixture {
  id: string;
  budgetId?: string;
  name?: string;
  type?: string;
  balance?: number;
  onBudget?: boolean;
  closed?: boolean;
  deleted?: boolean;
}

export async function seedAccount(db: Queryable, account: AccountFixture): Promise<string> {
  await write(db, 'accounts', {
    id: account.id,
    budget_id: account.budgetId ?? BUDGET_ID,
    name: account.name ?? account.id,
    type: account.type ?? 'checking',
    on_budget: Number(account.onBudget ?? true),
    closed: Number(account.closed ?? false),
    deleted: Number(account.deleted ?? false),
    balance: account.balance ?? 0,
  });

  return account.id;
}

export interface PayeeFixture {
  id: string;
  budgetId?: string;
  name?: string;
  deleted?: boolean;
}

export async function seedPayee(db: Queryable, payee: PayeeFixture): Promise<string> {
  await write(db, 'payees', {
    id: payee.id,
    budget_id: payee.budgetId ?? BUDGET_ID,
    name: payee.name ?? payee.id,
    deleted: Number(payee.deleted ?? false),
  });

  return payee.id;
}

export interface CategoryGroupFixture {
  id: string;
  budgetId?: string;
  name?: string;
  sortOrder?: number;
  hidden?: boolean;
  deleted?: boolean;
}

export async function seedCategoryGroup(
  db: Queryable,
  group: CategoryGroupFixture,
): Promise<string> {
  await write(db, 'category_groups', {
    id: group.id,
    budget_id: group.budgetId ?? BUDGET_ID,
    name: group.name ?? group.id,
    hidden: Number(group.hidden ?? false),
    deleted: Number(group.deleted ?? false),
    sort_order: group.sortOrder ?? 0,
  });

  return group.id;
}

export interface CategoryFixture {
  id: string;
  categoryGroupId: string;
  budgetId?: string;
  name?: string;
  sortOrder?: number;
  hidden?: boolean;
  deleted?: boolean;
}

export async function seedCategory(db: Queryable, category: CategoryFixture): Promise<string> {
  await write(db, 'categories', {
    id: category.id,
    budget_id: category.budgetId ?? BUDGET_ID,
    category_group_id: category.categoryGroupId,
    name: category.name ?? category.id,
    hidden: Number(category.hidden ?? false),
    deleted: Number(category.deleted ?? false),
    sort_order: category.sortOrder ?? 0,
  });

  return category.id;
}

export interface TransactionFixture {
  id: string;
  accountId: string;
  budgetId?: string;
  /** YYYY-MM-DD. */
  date?: string;
  amount?: number;
  payeeId?: string | null;
  payeeName?: string | null;
  categoryId?: string | null;
  memo?: string | null;
  flagColor?: string | null;
  transferAccountId?: string | null;
  transferTransactionId?: string | null;
  matchedTransactionId?: string | null;
  deleted?: boolean;
}

export async function seedTransaction(
  db: Queryable,
  transaction: TransactionFixture,
): Promise<string> {
  await write(db, 'transactions', {
    id: transaction.id,
    budget_id: transaction.budgetId ?? BUDGET_ID,
    date: transaction.date ?? '2026-10-01',
    account_id: transaction.accountId,
    amount: transaction.amount ?? -10_000,
    payee_id: transaction.payeeId ?? null,
    payee_name: transaction.payeeName ?? null,
    category_id: transaction.categoryId ?? null,
    category_name: null,
    memo: transaction.memo ?? null,
    flag_color: transaction.flagColor ?? null,
    cleared: 'cleared',
    approved: 1,
    transfer_account_id: transaction.transferAccountId ?? null,
    transfer_transaction_id: transaction.transferTransactionId ?? null,
    matched_transaction_id: transaction.matchedTransactionId ?? null,
    import_id: null,
    deleted: Number(transaction.deleted ?? false),
  });

  return transaction.id;
}

export interface SubtransactionFixture {
  id: string;
  transactionId: string;
  budgetId?: string;
  amount?: number;
  payeeId?: string | null;
  categoryId?: string | null;
  memo?: string | null;
  deleted?: boolean;
}

export async function seedSubtransaction(
  db: Queryable,
  subtransaction: SubtransactionFixture,
): Promise<string> {
  await write(db, 'subtransactions', {
    id: subtransaction.id,
    transaction_id: subtransaction.transactionId,
    budget_id: subtransaction.budgetId ?? BUDGET_ID,
    amount: subtransaction.amount ?? -5_000,
    payee_id: subtransaction.payeeId ?? null,
    payee_name: null,
    category_id: subtransaction.categoryId ?? null,
    category_name: null,
    memo: subtransaction.memo ?? null,
    transfer_account_id: null,
    transfer_transaction_id: null,
    deleted: Number(subtransaction.deleted ?? false),
  });

  return subtransaction.id;
}

export interface CategoryMonthFixture {
  categoryId: string;
  /** YYYY-MM-01. */
  month: string;
  budgetId?: string;
  budgeted?: number;
  activity?: number;
  balance?: number;
}

export async function seedCategoryMonth(
  db: Queryable,
  categoryMonth: CategoryMonthFixture,
): Promise<void> {
  await write(db, 'category_months', {
    category_id: categoryMonth.categoryId,
    month: categoryMonth.month,
    budget_id: categoryMonth.budgetId ?? BUDGET_ID,
    budgeted: categoryMonth.budgeted ?? 0,
    activity: categoryMonth.activity ?? 0,
    balance: categoryMonth.balance ?? 0,
  });
}
