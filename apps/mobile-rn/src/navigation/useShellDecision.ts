import { useAuth, useYnabAuth } from '@/auth';
import { useDatabaseState } from '@/data';
import { useSelectedBudget } from '@/settings';

import { shellDecision, type ShellDecision } from './shellDecision';

/**
 * The redirect decision, read from the providers it depends on.
 *
 * All this does is narrow four provider states to the four values the decision
 * is made from, so that the decision itself stays testable without a renderer.
 */
export function useShellDecision(): ShellDecision {
  const database = useDatabaseState();
  const { state: account } = useAuth();
  const { state: ynab } = useYnabAuth();
  const { budgetId, isLoaded } = useSelectedBudget();

  return shellDecision({
    database: database.status,
    account: account.status,
    ynab: ynab.status,
    // `isLoaded` is the whole reason the setting's own null is not enough: an
    // unread setting reads as its default, and this one's default is null.
    selectedBudgetId: isLoaded ? budgetId : undefined,
  });
}
