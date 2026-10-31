import {
  getSetting,
  setSetting,
  settingScope,
  type BudgetSetting,
  type DatabaseAdapter,
  type GlobalSetting,
  type Queryable,
  type SettingDefinition,
} from '@lumy/data';
import { useCallback } from 'react';

import { useDatabaseState, useLiveQuery } from '@/data';

/**
 * One setting, read live and written back.
 *
 * The read goes through `useLiveQuery`, so a write to the settings table
 * invalidates it like any other read and every screen showing the setting
 * follows. Nothing here subscribes to anything: this is the same invalidation
 * path the ledger uses, which is what replaces the Flutter app's 630 lines of
 * `rx_shared_preferences` streams.
 */

export interface SettingState<T> {
  /**
   * The stored value, or the setting's default.
   *
   * The default is also what an unwritten setting reads as, so the only window
   * in which this is not the stored value is the first read — which is why a
   * screen can render straight away instead of waiting.
   */
  value: T;
  /** False until the first read lands, for a screen that wants to wait. */
  isLoaded: boolean;
  setValue: (value: T) => Promise<void>;
}

export function useSetting<T>(definition: GlobalSetting<T>): SettingState<T>;
export function useSetting<T>(
  definition: BudgetSetting<T>,
  budgetId: string,
): SettingState<T>;
export function useSetting<T>(
  definition: SettingDefinition<T>,
  budgetId?: string,
): SettingState<T> {
  const state = useDatabaseState();
  const scope = settingScope(definition, budgetId);

  // `getSetting` and `setSetting` are typed so that a budget-scoped setting
  // cannot be reached without a budget. The scope is already resolved here, so
  // the branch is what hands each overload the arguments it asks for.
  const read = useCallback(
    (db: Queryable): Promise<T> =>
      definition.scope === 'global'
        ? getSetting(db, definition as GlobalSetting<T>)
        : getSetting(db, definition as BudgetSetting<T>, scope),
    [definition, scope],
  );

  const query = useLiveQuery('getSetting', scope, [definition.key], (db: DatabaseAdapter) =>
    read(db),
  );

  const setValue = useCallback(
    async (value: T): Promise<void> => {
      if (state.status !== 'ready') {
        throw new Error(`Cannot write ${definition.key}: the database is ${state.status}.`);
      }

      const db = state.database.adapter;
      await (definition.scope === 'global'
        ? setSetting(db, definition as GlobalSetting<T>, value)
        : setSetting(db, definition as BudgetSetting<T>, value, scope));
    },
    [definition, scope, state],
  );

  return {
    value: query.data === undefined ? definition.fallback : query.data,
    isLoaded: query.data !== undefined,
    setValue,
  };
}
