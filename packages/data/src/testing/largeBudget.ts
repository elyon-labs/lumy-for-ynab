import type { DatabaseAdapter, SqlValue } from '../adapters/types';
import { rebuildLedgerForBudget } from '../ledger';
import { BUDGET_ID } from './fixtures';

/**
 * A budget the size of a real one, for the performance suite.
 *
 * The point of this engine is that a number comes back in milliseconds from a
 * budget with years of history in it, so the budgets in the plan are measured
 * against a fixture of that size rather than against the handful of rows a
 * correctness test needs. Generated rather than committed: fifty thousand rows
 * of SQL in the repository would be slower to read than to write.
 *
 * The shape matters as much as the count. Spend is spread over three years,
 * eight accounts, forty categories in six groups, and two hundred payees, so a
 * grouped aggregate has a realistic number of groups to build and an index has
 * a realistic number of distinct keys to seek through.
 */

export interface LargeBudgetShape {
  months: number;
  accounts: number;
  groups: number;
  categoriesPerGroup: number;
  payees: number;
  /** Transactions with no legs. One ledger entry each. */
  simpleTransactions: number;
  /** Transactions with two legs. Two ledger entries each. */
  splitTransactions: number;
}

export const LARGE_BUDGET: LargeBudgetShape = {
  months: 36,
  accounts: 8,
  groups: 6,
  categoriesPerGroup: 7,
  payees: 200,
  simpleTransactions: 40_000,
  splitTransactions: 5_000,
};

export interface LargeBudget {
  budgetId: string;
  /** What the fixture actually produced, which is what a bound is held to. */
  entries: number;
  categoryIds: readonly string[];
  categoryGroupIds: readonly string[];
  accountIds: readonly string[];
  payeeIds: readonly string[];
  /** YYYY-MM-01. */
  firstMonth: string;
  lastMonth: string;
  /** YYYY-MM-DD. */
  firstDate: string;
  lastDate: string;
}

/** The parameter budget one statement stays inside, as `upsert` uses. */
const ROWS_PER_STATEMENT = 40;

async function insertAll(
  db: DatabaseAdapter,
  table: string,
  columns: readonly string[],
  rows: readonly SqlValue[][],
): Promise<void> {
  const tuple = `(${columns.map(() => '?').join(', ')})`;

  await db.transaction(async (tx) => {
    for (let start = 0; start < rows.length; start += ROWS_PER_STATEMENT) {
      const batch = rows.slice(start, start + ROWS_PER_STATEMENT);
      await tx.run(
        `INSERT INTO ${table} (${columns.join(', ')}) VALUES ${batch.map(() => tuple).join(', ')}`,
        batch.flat(),
      );
    }
  });
}

/**
 * A deterministic pseudo-random sequence.
 *
 * Seeded, so a measurement is comparable between runs and a failure can be
 * reproduced. `Math.random` would make the fixture a different shape each time
 * and a regression indistinguishable from luck.
 */
function sequence(seed: number): () => number {
  let state = seed;

  return () => {
    state = (state * 1_103_515_245 + 12_345) & 0x7f_ff_ff_ff;

    return state / 0x80_00_00_00;
  };
}

function monthOf(index: number): string {
  const year = 2024 + Math.floor(index / 12);
  const month = String((index % 12) + 1).padStart(2, '0');

  return `${year}-${month}-01`;
}

export async function seedLargeBudget(
  db: DatabaseAdapter,
  shape: LargeBudgetShape = LARGE_BUDGET,
): Promise<LargeBudget> {
  const next = sequence(20_261_029);

  await db.run('INSERT INTO budgets (id, name, first_month, last_month) VALUES (?, ?, ?, ?)', [
    BUDGET_ID,
    'Large Budget',
    monthOf(0),
    monthOf(shape.months - 1),
  ]);

  const accountIds = Array.from({ length: shape.accounts }, (_, index) => `account-${index}`);
  await insertAll(
    db,
    'accounts',
    ['id', 'budget_id', 'name', 'type', 'on_budget', 'closed', 'deleted', 'balance'],
    accountIds.map((id, index) => [
      id,
      BUDGET_ID,
      `Account ${index}`,
      index % 4 === 3 ? 'creditCard' : 'checking',
      1,
      0,
      0,
      index % 4 === 3 ? -50_000 * (index + 1) : 400_000 * (index + 1),
    ]),
  );

  const payeeIds = Array.from({ length: shape.payees }, (_, index) => `payee-${index}`);
  await insertAll(
    db,
    'payees',
    ['id', 'budget_id', 'name', 'deleted'],
    payeeIds.map((id, index) => [id, BUDGET_ID, `Payee ${index}`, 0]),
  );

  const categoryGroupIds = Array.from({ length: shape.groups }, (_, index) => `group-${index}`);
  await insertAll(
    db,
    'category_groups',
    ['id', 'budget_id', 'name', 'hidden', 'deleted', 'sort_order'],
    categoryGroupIds.map((id, index) => [id, BUDGET_ID, `Group ${index}`, 0, 0, index]),
  );

  const categoryIds: string[] = [];
  const categoryRows: SqlValue[][] = [];
  categoryGroupIds.forEach((groupId, groupIndex) => {
    for (let index = 0; index < shape.categoriesPerGroup; index += 1) {
      const id = `category-${groupIndex}-${index}`;
      categoryIds.push(id);
      categoryRows.push([id, BUDGET_ID, groupId, `Category ${groupIndex}.${index}`, 0, 0, index]);
    }
  });
  // One category is the inflow category, so income classifies as income.
  const incomeCategoryId = 'category-inflow';
  categoryIds.push(incomeCategoryId);
  categoryRows.push([
    incomeCategoryId,
    BUDGET_ID,
    categoryGroupIds[0],
    'Inflow: Ready to Assign',
    0,
    0,
    99,
  ]);

  await insertAll(
    db,
    'categories',
    ['id', 'budget_id', 'category_group_id', 'name', 'hidden', 'deleted', 'sort_order'],
    categoryRows,
  );

  const spendCategoryIds = categoryIds.filter((id) => id !== incomeCategoryId);

  const transactionColumns = [
    'id',
    'budget_id',
    'date',
    'account_id',
    'amount',
    'payee_id',
    'payee_name',
    'category_id',
    'category_name',
    'memo',
    'flag_color',
    'cleared',
    'approved',
    'transfer_account_id',
    'transfer_transaction_id',
    'matched_transaction_id',
    'import_id',
    'deleted',
  ];
  const flags = [null, 'red', 'orange', 'blue'];

  function date(): string {
    const monthIndex = Math.floor(next() * shape.months);
    const day = 1 + Math.floor(next() * 28);

    return `${monthOf(monthIndex).slice(0, 8)}${String(day).padStart(2, '0')}`;
  }

  const transactions: SqlValue[][] = [];
  for (let index = 0; index < shape.simpleTransactions; index += 1) {
    // Every twentieth transaction is income, which is roughly a budget's shape.
    const isIncome = index % 20 === 0;

    transactions.push([
      `tx-${index}`,
      BUDGET_ID,
      date(),
      accountIds[Math.floor(next() * accountIds.length)],
      isIncome ? 250_000 : -(100 + Math.floor(next() * 20_000)),
      payeeIds[Math.floor(next() * payeeIds.length)],
      null,
      isIncome ? incomeCategoryId : spendCategoryIds[Math.floor(next() * spendCategoryIds.length)],
      null,
      index % 7 === 0 ? `Memo for ${index}` : null,
      flags[Math.floor(next() * flags.length)],
      'cleared',
      1,
      null,
      null,
      null,
      null,
      0,
    ]);
  }

  const splitColumns = [
    'id',
    'transaction_id',
    'budget_id',
    'amount',
    'payee_id',
    'payee_name',
    'category_id',
    'category_name',
    'memo',
    'transfer_account_id',
    'transfer_transaction_id',
    'deleted',
  ];
  const legs: SqlValue[][] = [];
  for (let index = 0; index < shape.splitTransactions; index += 1) {
    const id = `split-${index}`;
    const first = -(100 + Math.floor(next() * 10_000));
    const second = -(100 + Math.floor(next() * 10_000));

    transactions.push([
      id,
      BUDGET_ID,
      date(),
      accountIds[Math.floor(next() * accountIds.length)],
      first + second,
      payeeIds[Math.floor(next() * payeeIds.length)],
      null,
      null,
      null,
      null,
      flags[Math.floor(next() * flags.length)],
      'cleared',
      1,
      null,
      null,
      null,
      null,
      0,
    ]);

    legs.push(
      [
        `${id}-a`,
        id,
        BUDGET_ID,
        first,
        null,
        null,
        spendCategoryIds[Math.floor(next() * spendCategoryIds.length)],
        null,
        null,
        null,
        null,
        0,
      ],
      [
        `${id}-b`,
        id,
        BUDGET_ID,
        second,
        null,
        null,
        spendCategoryIds[Math.floor(next() * spendCategoryIds.length)],
        null,
        null,
        null,
        null,
        0,
      ],
    );
  }

  await insertAll(db, 'transactions', transactionColumns, transactions);
  await insertAll(db, 'subtransactions', splitColumns, legs);

  await db.transaction((tx) => rebuildLedgerForBudget(tx, BUDGET_ID));

  const counted = await db.get<{ total: number }>(
    'SELECT COUNT(*) AS total FROM ledger_entries WHERE budget_id = ?',
    [BUDGET_ID],
  );

  // Analysed, as a device would be after a sync, so the query plans the suite
  // measures are the plans a real database picks.
  await db.run('ANALYZE');

  return {
    budgetId: BUDGET_ID,
    entries: counted?.total ?? 0,
    categoryIds,
    categoryGroupIds,
    accountIds,
    payeeIds,
    firstMonth: monthOf(0),
    lastMonth: monthOf(shape.months - 1),
    firstDate: `${monthOf(0).slice(0, 8)}01`,
    lastDate: `${monthOf(shape.months - 1).slice(0, 8)}28`,
  };
}
