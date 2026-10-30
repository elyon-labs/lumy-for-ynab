import type { Queryable, SqlValue } from '../adapters/types';

/**
 * Deriving `ledger_entries` from the raw YNAB tables.
 *
 * The derivation is SQL rather than TypeScript so that a delta page never
 * marshals its rows out to JavaScript and back to decide what they mean. It
 * is also stated once: the classification rules below appear in exactly one
 * statement, so there is no second implementation to drift from the first.
 *
 * Entries are always deleted and re-derived, never patched. A rebuild for a
 * set of transaction ids is therefore idempotent, and the derived table
 * cannot drift from the raw tables because nothing ever edits it in place.
 */

/**
 * The resolved payee name.
 *
 * `payees` is authoritative when the payee has been synced; the name YNAB
 * attached to the transaction is the fallback, which is what carries payees
 * that exist only as a name on a row.
 */
const PAYEE_NAME = 'COALESCE(p.name, l.payee_name)';

/** The resolved category name, on the same footing as the payee's. */
const CATEGORY_NAME = 'COALESCE(c.name, l.category_name)';

/**
 * Classification, applied once here rather than recomputed on every read.
 *
 * `IS` instead of `=` throughout: a leaf with no payee or no category must
 * compare false, not null, and `=` against a null yields null, which would
 * then fall through as if the question had not been asked.
 *
 * These match the predicates in the Flutter app's `BaseTransactionX`, minus
 * its `!isSplit` guards. Those guards exist there because a parent carries
 * the sum of its legs and would double-count; here a parent produces no entry
 * at all, so the guard has nothing left to do. One consequence: a split leg
 * categorised to `Inflow: Ready to Assign` counts as income here where the
 * Flutter app skipped it.
 */
const IS_STARTING_BALANCE = `${PAYEE_NAME} IS 'Starting Balance'`;
const IS_INCOME = `(${CATEGORY_NAME} IS 'Inflow: Ready to Assign' AND ${PAYEE_NAME} IS NOT 'Starting Balance')`;
const IS_EXPENSE = `(l.category_id IS NOT NULL AND ${CATEGORY_NAME} IS NOT 'Inflow: Ready to Assign' AND ${PAYEE_NAME} IS NOT 'Starting Balance')`;
const IS_TRANSFER = 'l.transfer_account_id IS NOT NULL';

/**
 * The key both sides of a transfer share.
 *
 * The two ids sorted, so each side computes the same string. They are entry
 * ids rather than transaction ids because a transfer out of one leg of a
 * split pairs that leg's id with the whole transaction on the other side —
 * sorting the transaction ids would give the two sides different answers and
 * leave each electing itself.
 */
const TRANSFER_PAIR_KEY = `
  CASE
    WHEN l.transfer_transaction_id IS NULL THEN NULL
    WHEN l.entry_id < l.transfer_transaction_id
      THEN l.entry_id || ':' || l.transfer_transaction_id
    ELSE l.transfer_transaction_id || ':' || l.entry_id
  END`;

/**
 * Every leaf the transactions in `scope` produce.
 *
 * A transaction is live when it is not deleted and nothing else claims it as
 * a match: YNAB reports a matched import from both sides, and counting both
 * is how one purchase becomes two. It is a split when it still has a live
 * leg, which is also how a split reduced back to a simple transaction sorts
 * itself out — reconciliation removes the legs, and the parent becomes the
 * leaf.
 */
const LEAVES = `
  live AS (
    SELECT t.*
    FROM transactions t
    WHERE t.id IN (SELECT id FROM scope)
      AND t.deleted = 0
      AND NOT EXISTS (
        SELECT 1 FROM transactions m
        WHERE m.matched_transaction_id = t.id AND m.deleted = 0
      )
  ),
  leaves AS (
    SELECT
      t.id AS entry_id, 0 AS is_subtransaction, t.id AS transaction_id, t.budget_id,
      t.date, t.account_id, t.flag_color,
      t.payee_id, t.payee_name, t.category_id, t.category_name,
      t.amount, t.memo, t.transfer_account_id, t.transfer_transaction_id
    FROM live t
    WHERE NOT EXISTS (
      SELECT 1 FROM subtransactions s WHERE s.transaction_id = t.id AND s.deleted = 0
    )

    UNION ALL

    SELECT
      s.id, 1, t.id, s.budget_id,
      t.date, t.account_id, t.flag_color,
      -- A leg overrides the parent's payee only when it carries one of its
      -- own; taking the id and the name separately could pair the leg's id
      -- with the parent's name.
      CASE WHEN s.payee_id IS NOT NULL OR s.payee_name IS NOT NULL
        THEN s.payee_id ELSE t.payee_id END,
      CASE WHEN s.payee_id IS NOT NULL OR s.payee_name IS NOT NULL
        THEN s.payee_name ELSE t.payee_name END,
      s.category_id, s.category_name,
      s.amount,
      -- The parent's memo where the leg has none, so a split that describes
      -- itself once does not lose that on the way in.
      COALESCE(s.memo, t.memo),
      s.transfer_account_id, s.transfer_transaction_id
    FROM live t
    JOIN subtransactions s ON s.transaction_id = t.id AND s.deleted = 0
  )`;

/**
 * The derivation, as one `INSERT ... SELECT` into whichever table is named.
 *
 * The target is a parameter only so the verifier can derive into a table of
 * its own and compare: there is one derivation, and both the rebuild and the
 * check run this statement.
 */
function insertInto(table: string): string {
  return `
  INSERT INTO ${table} (
    entry_id, budget_id, transaction_id, is_subtransaction,
    date, month, account_id,
    payee_id, payee_name, category_id, category_group_id,
    amount, memo, flag_color,
    transfer_account_id, transfer_pair_key,
    is_transfer, is_income, is_starting_balance, is_expense
  )
  SELECT
    l.entry_id, l.budget_id, l.transaction_id, l.is_subtransaction,
    l.date, substr(l.date, 1, 7) || '-01', l.account_id,
    l.payee_id, ${PAYEE_NAME}, l.category_id, c.category_group_id,
    l.amount, l.memo, l.flag_color,
    l.transfer_account_id, ${TRANSFER_PAIR_KEY},
    ${IS_TRANSFER}, ${IS_INCOME}, ${IS_STARTING_BALANCE}, ${IS_EXPENSE}
  FROM leaves l
  LEFT JOIN payees p ON p.id = l.payee_id
  LEFT JOIN categories c ON c.id = l.category_id`;
}

const INSERT = insertInto('ledger_entries');

/**
 * The transactions a rebuild has to cover, given the ones that changed.
 *
 * One id wider than what was handed in. A transaction stops producing entries
 * when something else claims it as a match, and the page that establishes
 * that contains the claimant, not the transaction it displaces — so following
 * `matched_transaction_id` is what keeps the displaced one from surviving as
 * a duplicate. The reverse needs nothing: whether a transaction is claimed is
 * read from the claimant's row at derivation time, so a claimant that has not
 * changed is already accounted for.
 *
 * The one case this cannot see is a match being broken, where the id to
 * revisit is in the row's previous value rather than its current one. YNAB
 * returns both transactions when a match changes, so the freed side arrives
 * in the same page.
 */
const SCOPE_FROM_IDS = `
  scope(id) AS (
    SELECT id FROM given
    UNION
    SELECT matched_transaction_id FROM transactions
    WHERE id IN (SELECT id FROM given) AND matched_transaction_id IS NOT NULL
  )`;

function givenIds(ids: readonly string[]): string {
  return `given(id) AS (VALUES ${ids.map(() => '(?)').join(', ')})`;
}

/**
 * The most ids to rebuild in one statement.
 *
 * Each id is a bound parameter, and SQLite's limit on those is the thing
 * being stayed well clear of. The sync engine already writes in pages
 * smaller than this, so it costs nothing in practice.
 */
export const REBUILD_CHUNK = 400;

/**
 * Re-derives the ledger entries for the given transactions.
 *
 * Must run inside the same transaction as the raw writes it follows, so that
 * the ledger and the rows it was derived from commit together or not at all.
 * Ids that no longer exist, or that belong to a deleted transaction, are
 * accepted: their entries go and nothing replaces them.
 */
export async function rebuildLedgerForTransactions(
  tx: Queryable,
  transactionIds: readonly string[],
): Promise<void> {
  for (let start = 0; start < transactionIds.length; start += REBUILD_CHUNK) {
    const chunk = transactionIds.slice(start, start + REBUILD_CHUNK);
    const params = chunk as readonly SqlValue[];
    const scope = `WITH ${givenIds(chunk)}, ${SCOPE_FROM_IDS}`;

    await tx.run(
      `${scope} DELETE FROM ledger_entries WHERE transaction_id IN (SELECT id FROM scope)`,
      params,
    );
    await tx.run(`${scope}, ${LEAVES} ${INSERT}`, params);
  }
}

/**
 * Re-derives every ledger entry in a budget.
 *
 * The first sync's last step, and what repair runs. Same derivation as the
 * incremental path — there is only one — with the scope widened to the whole
 * budget.
 */
export async function rebuildLedgerForBudget(tx: Queryable, budgetId: string): Promise<void> {
  await tx.run('DELETE FROM ledger_entries WHERE budget_id = ?', [budgetId]);
  await deriveLedgerInto(tx, 'ledger_entries', budgetId);
}

/**
 * Derives a budget's entries into the named table, which must have the same
 * columns as `ledger_entries`.
 *
 * What the verifier derives into, so that what it compares the stored table
 * against is this statement's output rather than a second opinion about what
 * the rules are.
 */
export async function deriveLedgerInto(
  tx: Queryable,
  table: string,
  budgetId: string,
): Promise<void> {
  const scope = 'WITH scope(id) AS (SELECT id FROM transactions WHERE budget_id = ?)';

  await tx.run(`${scope}, ${LEAVES} ${insertInto(table)}`, [budgetId]);
}

/**
 * Re-derives the entries that resolved against a payee or category that has
 * since been renamed, or moved to another group.
 *
 * An entry caches its resolved payee name, its category's group, and the
 * classification read from those names, so a rename in the `payees` or
 * `categories` payload leaves entries holding what was true when they were
 * derived. Renaming a category to or from `Inflow: Ready to Assign`, or a
 * payee to or from `Starting Balance`, changes the classification itself —
 * so this is an accuracy question and not only a display one.
 *
 * Scoped to the entries that actually reference the changed ids. Nothing
 * indexes `ledger_entries` by payee or category alone, so this scans the
 * budget's entries; it runs only when a name or a group has genuinely
 * changed, which a steady-state sync almost never reports.
 */
export async function rebuildLedgerForReferences(
  tx: Queryable,
  budgetId: string,
  references: { payeeIds?: readonly string[]; categoryIds?: readonly string[] },
): Promise<void> {
  const payeeIds = references.payeeIds ?? [];
  const categoryIds = references.categoryIds ?? [];
  if (payeeIds.length === 0 && categoryIds.length === 0) return;

  const tests: string[] = [];
  const params: SqlValue[] = [budgetId];
  if (payeeIds.length > 0) {
    tests.push(`payee_id IN (${payeeIds.map(() => '?').join(', ')})`);
    params.push(...payeeIds);
  }
  if (categoryIds.length > 0) {
    tests.push(`category_id IN (${categoryIds.map(() => '?').join(', ')})`);
    params.push(...categoryIds);
  }

  const rows = await tx.all<{ transaction_id: string }>(
    `SELECT DISTINCT transaction_id FROM ledger_entries
     WHERE budget_id = ? AND (${tests.join(' OR ')})`,
    params,
  );

  await rebuildLedgerForTransactions(
    tx,
    rows.map((row) => row.transaction_id),
  );
}
