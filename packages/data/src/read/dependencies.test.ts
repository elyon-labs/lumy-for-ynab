import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { BUDGET_ID, createHarness, type Harness } from '../testing';
import {
  savingsRateStatement,
  sumByStatement,
  totalsStatement,
  type Grouping,
} from './aggregates';
import {
  accountBalancesStatement,
  netWorthStatement,
  totalBalanceStatement,
} from './balances';
import type { CompiledStatement } from './conditions';
import {
  READ_DEPENDENCY_TABLES,
  READ_NAMES,
  READ_TABLES,
  readsAffectedBy,
  type ReadName,
} from './dependencies';
import { ledgerEntryPageStatement, transactionPageStatement } from './listings';

/**
 * The declarations in `dependencies.ts` are only worth anything if they are
 * true, and the thing that makes them untrue is a join added to a query by
 * someone who never looked at them. So the tables each statement actually
 * names are read back out of the statement and compared.
 *
 * The real table names come from the schema, which is what separates them from
 * the CTE names the statements are full of — `page`, `rolled`, `month_spine`.
 */

const GROUPINGS: Grouping[] = ['month', 'category', 'categoryGroup', 'payee', 'account'];

/** Every identifier the statement reads from, narrowed to real tables. */
function tablesNamedIn(statement: CompiledStatement, schemaTables: Set<string>): string[] {
  const named = new Set<string>();
  const pattern = /\b(?:from|join)\s+([a-z_][a-z0-9_]*)/gi;

  for (const match of statement.sql.matchAll(pattern)) {
    const candidate = match[1].toLowerCase();
    if (schemaTables.has(candidate)) named.add(candidate);
  }

  return [...named].sort();
}

describe('read dependencies', () => {
  let harness: Harness;
  let db: DatabaseAdapter;
  let schemaTables: Set<string>;

  beforeAll(async () => {
    harness = await createHarness();
    db = harness.db;

    const rows = await db.all<{ name: string }>(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
    );
    schemaTables = new Set(rows.map((row) => row.name));
  });

  afterAll(async () => {
    await harness.close();
  });

  /**
   * The statements behind each declaration.
   *
   * `sumBy` is every grouping together, which is what its declaration claims;
   * `daysBuffer` and `targetHealth` compose or build their statements from a
   * prior read and are checked by their parts below.
   */
  function statementsFor(name: ReadName): CompiledStatement[] {
    const options = { budgetId: BUDGET_ID, limit: 50 };
    const range = { budgetId: BUDGET_ID, from: '2026-01-01', to: '2026-12-01' };

    switch (name) {
      case 'listLedgerEntries':
        return [ledgerEntryPageStatement(options)];
      case 'listTransactions':
        return [transactionPageStatement(options)];
      case 'sumBy':
        return GROUPINGS.map((by) => sumByStatement({ budgetId: BUDGET_ID, by }));
      case 'totals':
        return [totalsStatement({ budgetId: BUDGET_ID })];
      case 'savingsRateByMonth':
        return [savingsRateStatement(range)];
      case 'accountBalancesOverTime':
        return [accountBalancesStatement(range)];
      case 'totalBalanceOverTime':
        return [totalBalanceStatement(range)];
      case 'netWorthOverTime':
        return [netWorthStatement(range)];
      default:
        return [];
    }
  }

  it.each(READ_NAMES.filter((name) => statementsFor(name).length > 0))(
    '%s declares exactly the tables its statement reads',
    (name) => {
      const named = new Set(
        statementsFor(name).flatMap((statement) => tablesNamedIn(statement, schemaTables)),
      );

      expect([...named].sort()).toEqual([...READ_TABLES[name]].sort());
    },
  );

  it('declares the days buffer as the union of the reads it is built from', () => {
    const parts = new Set([
      ...READ_TABLES.totals,
      ...READ_TABLES.totalBalanceOverTime,
    ]);

    expect([...READ_TABLES.daysBuffer].sort()).toEqual([...parts].sort());
  });

  it('declares target health against the two tables it reads', () => {
    // Its aggregate is built from a window per category, so there is no single
    // statement to read back; what it touches is the categories it reads the
    // targets from and the entries it sums.
    expect([...READ_TABLES.targetHealth].sort()).toEqual(['categories', 'ledger_entries']);
  });

  it('names only tables the schema has', () => {
    for (const table of READ_DEPENDENCY_TABLES) {
      expect(schemaTables.has(table), table).toBe(true);
    }
  });

  describe('what a write makes stale', () => {
    it('is every read over the ledger, when the ledger changes', () => {
      expect(readsAffectedBy(['ledger_entries'])).toEqual([...READ_NAMES].sort());
    });

    it('is the reads that resolve a name, when a payee is renamed', () => {
      expect(readsAffectedBy(['payees'])).toEqual(['sumBy']);
    });

    it('is nothing, for a table no read depends on', () => {
      expect(readsAffectedBy(['server_knowledge', 'schema_migrations'])).toEqual([]);
    });

    it('is the union, for a write that touched several tables', () => {
      expect(readsAffectedBy(['accounts', 'categories'])).toEqual([
        'accountBalancesOverTime',
        'daysBuffer',
        'listLedgerEntries',
        'listTransactions',
        'netWorthOverTime',
        'sumBy',
        'targetHealth',
        'totalBalanceOverTime',
      ]);
    });
  });
});
