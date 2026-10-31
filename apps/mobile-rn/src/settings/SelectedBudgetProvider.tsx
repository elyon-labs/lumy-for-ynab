import { Settings } from '@lumy/data';
import { createContext, useContext, useMemo, type ReactNode } from 'react';

import { useSetting } from './useSetting';

/**
 * Which budget everything else is about.
 *
 * It is one value in one place because it is the first element of almost every
 * query key: changing it refetches declaratively, since a different budget is
 * a different key. The Flutter app read `selected_budget_id` from preferences
 * at each call site and composed the per-budget preference keys by
 * interpolating it, which is why so many of its settings had a
 * `runIfBudgetIsSelected` wrapper.
 */

export interface SelectedBudget {
  /** Null until the person has chosen one, which they do on first run. */
  budgetId: string | null;
  /** False until the stored choice has been read. */
  isLoaded: boolean;
  selectBudget: (budgetId: string | null) => Promise<void>;
}

const SelectedBudgetContext = createContext<SelectedBudget | null>(null);

export function SelectedBudgetProvider({ children }: { children: ReactNode }) {
  const { value, isLoaded, setValue } = useSetting(Settings.selectedBudgetId);

  const selected = useMemo<SelectedBudget>(
    () => ({ budgetId: value, isLoaded, selectBudget: setValue }),
    [value, isLoaded, setValue],
  );

  return (
    <SelectedBudgetContext.Provider value={selected}>{children}</SelectedBudgetContext.Provider>
  );
}

export function useSelectedBudget(): SelectedBudget {
  const value = useContext(SelectedBudgetContext);
  if (!value) {
    throw new Error('useSelectedBudget must be called inside a SelectedBudgetProvider.');
  }

  return value;
}

/**
 * The selected budget, for a screen that only renders once there is one.
 *
 * Throws rather than returning null, for the same reason `useDatabase` does:
 * every screen inside the navigation shell is reached only after a budget has
 * been chosen, so a null check at each of them would be dead code that still
 * has to be read.
 */
export function useBudgetId(): string {
  const { budgetId } = useSelectedBudget();
  if (budgetId === null) {
    throw new Error('No budget is selected; render this below a budget guard.');
  }

  return budgetId;
}
