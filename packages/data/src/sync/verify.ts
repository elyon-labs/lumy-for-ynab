import type { YnabClient } from '@lumy/ynab';

import type { DatabaseAdapter, Queryable, Row, SqlValue } from '../adapters/types';
import { deriveLedgerInto } from '../ledger';
import {
  accountDebtMonthRows,
  accountRows,
  budgetRows,
  categoryGroupRows,
  categoryRows,
  currencyFormatRows,
  monthRows,
  payeeRows,
  scheduledSubtransactionRows,
  scheduledTransactionRows,
  subtransactionRows,
  transactionRows,
} from './rows';

/**
 * Checking that what is stored is what YNAB holds.
 *
 * The Flutter app's accuracy failures were only ever observed as "duplicates
 * sometimes happen" — a report nobody could act on, because there was no way
 * to ask the client whether it had diverged. This makes that a condition: a
 * full non-delta snapshot is fetched and diffed against the raw tables, and
 * the derived ledger is checked against the raw tables it came from.
 *
 * Two checks, because they fail for different reasons. A snapshot diff catches
 * a write that never landed, a row that should have gone, and a field that has
 * drifted. A ledger check catches a derivation that was skipped — the entries
 * for a transaction the engine never revisited — and needs no network at all.
 */

export type DivergenceKind =
  /** YNAB has it; the client does not. */
  | 'missing'
  /** The client has it; YNAB does not. This is the stale-row class. */
  | 'unexpected'
  /** Both have it, and a stored column disagrees. */
  | 'different';

export interface Divergence {
  /** The table the row belongs to, which is the entity in the app's terms. */
  entity: string;
  /** The row's key, with a composite key joined by `:`. */
  id: string;
  kind: DivergenceKind;
  /** Which columns disagree. Only set for `different`. */
  columns?: readonly string[];
}

export interface EntityCount {
  local: number;
  remote: number;
}

export interface VerificationReport {
  budgetId: string;
  checkedAt: string;
  /** Rows compared per entity, so a clean report still says what it looked at. */
  counts: Readonly<Record<string, EntityCount>>;
  divergences: readonly Divergence[];
  /** True when nothing diverged, which is the question the debug screen asks. */
  consistent: boolean;
}

/**
 * How many divergences one entity may report.
 *
 * A client that has never synced diverges on every row it does not have, and
 * a list of fifty thousand of those says nothing the count does not. The cap
 * keeps the report readable and the memory bounded.
 */
export const MAX_DIVERGENCES_PER_ENTITY = 50;

interface TableCheck {
  entity: string;
  key: readonly string[];
  expected: readonly Row[];
  /** The column that narrows the table to one budget. */
  scope: string;
}

/** `undefined` and `null` both mean "no value", and SQLite only has the one. */
function normalise(value: SqlValue | undefined): SqlValue {
  return value ?? null;
}

function keyOf(row: Row, key: readonly string[]): string {
  return key.map((column) => String(normalise(row[column]))).join(':');
}

async function diffTable(
  db: Queryable,
  budgetId: string,
  check: TableCheck,
): Promise<{ divergences: Divergence[]; counts: EntityCount }> {
  const local = await db.all<Row>(`SELECT * FROM ${check.entity} WHERE ${check.scope} = ?`, [
    budgetId,
  ]);

  const expected = new Map(check.expected.map((row) => [keyOf(row, check.key), row]));
  const stored = new Map(local.map((row) => [keyOf(row, check.key), row]));
  const divergences: Divergence[] = [];

  function report(divergence: Divergence): void {
    if (divergences.length < MAX_DIVERGENCES_PER_ENTITY) divergences.push(divergence);
  }

  for (const [id, row] of expected) {
    const found = stored.get(id);
    if (found === undefined) {
      report({ entity: check.entity, id, kind: 'missing' });
      continue;
    }

    // Only the columns the writer sets. A column the snapshot does not
    // describe is not a divergence, it is something the client derives.
    const columns = Object.keys(row).filter(
      (column) => normalise(found[column]) !== normalise(row[column]),
    );
    if (columns.length > 0) {
      report({ entity: check.entity, id, kind: 'different', columns });
    }
  }

  for (const id of stored.keys()) {
    if (!expected.has(id)) report({ entity: check.entity, id, kind: 'unexpected' });
  }

  return { divergences, counts: { local: stored.size, remote: expected.size } };
}

/**
 * The table the ledger check derives into.
 *
 * Temporary, so it exists for the connection and disappears with it rather
 * than needing a migration or a cleanup that a thrown error could skip.
 */
const LEDGER_CHECK_TABLE = 'ledger_check';

export interface LedgerCheck {
  divergences: readonly Divergence[];
  /** Entries stored for the budget. */
  stored: number;
  /** Entries the derivation produced from the raw rows as they now stand. */
  derived: number;
}

/**
 * Checks `ledger_entries` against deriving it again from the raw tables.
 *
 * Needs no network: the question is whether the derived table still says what
 * the rows it came from imply, which is what a missed rebuild breaks. Both
 * directions are reported, because an entry that should have gone and an entry
 * that was never written are different failures, and an id on both sides is
 * the same leaf carrying different numbers.
 *
 * It runs in one transaction so that a sync committing alongside it cannot be
 * read as a divergence. The temporary table it derives into belongs to the
 * connection, so nothing watches it and nothing has to migrate it.
 */
export async function verifyLedger(db: DatabaseAdapter, budgetId: string): Promise<LedgerCheck> {
  const columns = await db.all<{ name: string }>(
    "SELECT name FROM pragma_table_info('ledger_entries')",
  );
  const selection = columns.map((column) => column.name).join(', ');

  return db.transaction(async (tx) => {
    await tx.run(`DROP TABLE IF EXISTS ${LEDGER_CHECK_TABLE}`);
    await tx.run(
      `CREATE TEMP TABLE ${LEDGER_CHECK_TABLE} AS SELECT ${selection} FROM ledger_entries WHERE 0`,
    );

    try {
      await deriveLedgerInto(tx, LEDGER_CHECK_TABLE, budgetId);

      const stale = await tx.all<{ entry_id: string }>(
        `SELECT entry_id FROM (
           SELECT ${selection} FROM ledger_entries WHERE budget_id = ?
           EXCEPT SELECT ${selection} FROM ${LEDGER_CHECK_TABLE}
         ) LIMIT ?`,
        [budgetId, MAX_DIVERGENCES_PER_ENTITY],
      );
      const absent = await tx.all<{ entry_id: string }>(
        `SELECT entry_id FROM (
           SELECT ${selection} FROM ${LEDGER_CHECK_TABLE}
           EXCEPT SELECT ${selection} FROM ledger_entries WHERE budget_id = ?
         ) LIMIT ?`,
        [budgetId, MAX_DIVERGENCES_PER_ENTITY],
      );

      const staleIds = new Set(stale.map((row) => row.entry_id));
      const absentIds = new Set(absent.map((row) => row.entry_id));

      const divergences: Divergence[] = [
        ...[...staleIds]
          .filter((id) => absentIds.has(id))
          .map((id): Divergence => ({ entity: 'ledger_entries', id, kind: 'different' })),
        ...[...staleIds]
          .filter((id) => !absentIds.has(id))
          .map((id): Divergence => ({ entity: 'ledger_entries', id, kind: 'unexpected' })),
        ...[...absentIds]
          .filter((id) => !staleIds.has(id))
          .map((id): Divergence => ({ entity: 'ledger_entries', id, kind: 'missing' })),
      ];

      const counted = await tx.get<{ stored: number; derived: number }>(
        `SELECT
           (SELECT COUNT(*) FROM ledger_entries WHERE budget_id = ?) AS stored,
           (SELECT COUNT(*) FROM ${LEDGER_CHECK_TABLE}) AS derived`,
        [budgetId],
      );

      return { divergences, stored: counted?.stored ?? 0, derived: counted?.derived ?? 0 };
    } finally {
      await tx.run(`DROP TABLE IF EXISTS ${LEDGER_CHECK_TABLE}`);
    }
  });
}

export interface VerifyOptions {
  db: DatabaseAdapter;
  client: YnabClient;
  budgetId: string;
  now?: () => Date;
}

/**
 * Fetches a full snapshot and reports where the client disagrees with it.
 *
 * Seven requests, none of them delta: the budget list, and each synced
 * resource whole. `category_months` is not covered, because it is filled a
 * month at a time and verifying it would cost one request per month of the
 * budget's history.
 *
 * Read-only. Nothing here repairs what it finds — that is `repairBudget`,
 * which the caller runs once it knows what it is choosing to discard.
 */
export async function verifyAgainstSnapshot(
  options: VerifyOptions,
): Promise<VerificationReport> {
  const { db, client, budgetId } = options;
  const checkedAt = (options.now ?? (() => new Date()))().toISOString();

  const budgets = await client.getBudgets();
  const mine = budgets.filter((budget) => budget.id === budgetId);
  const accounts = await client.getAccounts({ budgetId });
  const payees = await client.getPayees({ budgetId });
  const categories = await client.getCategories({ budgetId });
  const months = await client.getMonths({ budgetId });
  const transactions = await client.getTransactions({ budgetId });
  const scheduled = await client.getScheduledTransactions({ budgetId });

  const checks: TableCheck[] = [
    { entity: 'budgets', key: ['id'], expected: budgetRows(mine), scope: 'id' },
    {
      entity: 'currency_formats',
      key: ['budget_id'],
      expected: currencyFormatRows(mine),
      scope: 'budget_id',
    },
    {
      entity: 'accounts',
      key: ['id'],
      expected: accountRows(budgetId, accounts.entities),
      scope: 'budget_id',
    },
    {
      entity: 'account_debt_months',
      key: ['account_id', 'month'],
      expected: accountDebtMonthRows(budgetId, accounts.entities),
      scope: 'budget_id',
    },
    {
      entity: 'payees',
      key: ['id'],
      expected: payeeRows(budgetId, payees.entities),
      scope: 'budget_id',
    },
    {
      entity: 'category_groups',
      key: ['id'],
      expected: categoryGroupRows(budgetId, categories.entities),
      scope: 'budget_id',
    },
    {
      entity: 'categories',
      key: ['id'],
      expected: categoryRows(budgetId, categories.entities),
      scope: 'budget_id',
    },
    {
      entity: 'months',
      key: ['budget_id', 'month'],
      expected: monthRows(budgetId, months.entities),
      scope: 'budget_id',
    },
    {
      entity: 'transactions',
      key: ['id'],
      expected: transactionRows(budgetId, transactions.entities),
      scope: 'budget_id',
    },
    {
      entity: 'subtransactions',
      key: ['id'],
      expected: subtransactionRows(budgetId, transactions.entities),
      scope: 'budget_id',
    },
    {
      entity: 'scheduled_transactions',
      key: ['id'],
      expected: scheduledTransactionRows(budgetId, scheduled.entities),
      scope: 'budget_id',
    },
    {
      entity: 'scheduled_subtransactions',
      key: ['id'],
      expected: scheduledSubtransactionRows(budgetId, scheduled.entities),
      scope: 'budget_id',
    },
  ];

  const divergences: Divergence[] = [];
  const counts: Record<string, EntityCount> = {};

  for (const check of checks) {
    const result = await diffTable(db, budgetId, check);
    divergences.push(...result.divergences);
    counts[check.entity] = result.counts;
  }

  const ledger = await verifyLedger(db, budgetId);
  divergences.push(...ledger.divergences);
  // The ledger is derived rather than fetched, so what it is held to is the
  // derivation's own output rather than anything YNAB said.
  counts.ledger_entries = { local: ledger.stored, remote: ledger.derived };

  return {
    budgetId,
    checkedAt,
    counts,
    divergences,
    consistent: divergences.length === 0,
  };
}
