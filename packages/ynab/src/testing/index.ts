/**
 * The test-only entry.
 *
 * Fixtures are modelled on YNAB's documented response shapes rather than
 * captured from a live account — they are hand-written, and they include the
 * fields YNAB sends that this package deliberately ignores, so a schema that
 * is too strict fails here rather than on a device. Where a payload exercises
 * a correctness rule, the fixture is named for the rule.
 */
import accounts from './fixtures/accounts.json' with { type: 'json' };
import budgets from './fixtures/budgets.json' with { type: 'json' };
import categories from './fixtures/categories.json' with { type: 'json' };
import month from './fixtures/month.json' with { type: 'json' };
import payees from './fixtures/payees.json' with { type: 'json' };
import scheduledTransactions from './fixtures/scheduledTransactions.json' with { type: 'json' };
import transactionsDeltaPage from './fixtures/transactionsDeltaPage.json' with { type: 'json' };
import transactionsFirstPage from './fixtures/transactionsFirstPage.json' with { type: 'json' };

export const fixtures = {
  accounts,
  budgets,
  categories,
  month,
  payees,
  scheduledTransactions,
  /** A full fetch: a simple transaction, a two-leg split, and an opening balance. */
  transactionsFirstPage,
  /**
   * The page that follows it.
   *
   * It drops a subtransaction by omission rather than by marking it deleted,
   * and it marks a transaction deleted. Those are the two shapes the Flutter
   * writer got wrong, so they are the two a sync test has to be able to reach
   * for.
   */
  transactionsDeltaPage,
} as const;

export * from './stubFetch';
