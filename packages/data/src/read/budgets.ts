import type { Queryable } from '../adapters/types';
import type { CompiledStatement } from './conditions';

/**
 * The budgets this client has stored.
 *
 * The picker reads this rather than YNAB directly. `syncBudgetList` fetches
 * the list and writes it, so the table is already the record of what the token
 * can see — and reading it means the picker renders from what is known before
 * the network answers, and still renders at all when the network does not.
 * Choosing a budget is also the one step of onboarding someone may have to
 * repeat on a train.
 *
 * Bounded by the account's own budget list, which YNAB returns whole and which
 * is a handful: this is the only read whose size is set by YNAB rather than by
 * the budget's structure, and YNAB offers no delta for it for the same reason.
 */

export interface BudgetSummary {
  id: string;
  name: string;
  /** The currency's ISO code, or null for a budget YNAB sent no format for. */
  isoCode: string | null;
  lastModifiedOn: string | null;
}

/**
 * Most recently used first.
 *
 * Someone with several budgets almost always wants the one they were last in,
 * and `last_modified_on` is the only ordering YNAB gives that reflects that.
 * It has been seen absent, which sorts to the end rather than to the top —
 * hence the null test ahead of the timestamp — and name breaks the tie so the
 * list does not reorder itself between renders.
 */
export function budgetListStatement(): CompiledStatement {
  return {
    sql: `SELECT budgets.id AS id,
            budgets.name AS name,
            currency_formats.iso_code AS iso_code,
            budgets.last_modified_on AS last_modified_on
          FROM budgets
          LEFT JOIN currency_formats ON currency_formats.budget_id = budgets.id
          ORDER BY budgets.last_modified_on IS NULL,
                   budgets.last_modified_on DESC,
                   budgets.name`,
    params: [],
  };
}

export async function listBudgets(db: Queryable): Promise<BudgetSummary[]> {
  const statement = budgetListStatement();
  const rows = await db.all<{
    id: string;
    name: string;
    iso_code: string | null;
    last_modified_on: string | null;
  }>(statement.sql, statement.params);

  return rows.map((row) => ({
    id: row.id,
    name: row.name,
    isoCode: row.iso_code,
    lastModifiedOn: row.last_modified_on,
  }));
}
