import type { Queryable } from '../adapters/types';
import {
  settingScope,
  type BudgetSetting,
  type GlobalSetting,
  type SettingDefinition,
} from '../settings/definitions';
import type { CompiledStatement } from './conditions';

/**
 * Reading a setting.
 *
 * It lives in the read API rather than beside the registry because every read
 * in this package does: this is where the no-unbounded-reads rule is enforced
 * and where a read declares the tables it depends on, which is what makes a
 * screen showing a setting re-read it when the setting is written. The writer
 * is in `src/settings/`, with the sync engine's writers and the ledger's.
 *
 * Nothing about it needs React, which is the point. The background sync task
 * reads the selected budget and the selected period through exactly this
 * function, with no provider and no renderer anywhere near it.
 */

/** One row by its key and scope, which is the primary key. */
export function settingStatement(key: string, scope: string): CompiledStatement {
  return {
    sql: 'SELECT value FROM settings WHERE key = ? AND scope = ?',
    params: [key, scope],
  };
}

export function getSetting<T>(db: Queryable, definition: GlobalSetting<T>): Promise<T>;
export function getSetting<T>(
  db: Queryable,
  definition: BudgetSetting<T>,
  budgetId: string,
): Promise<T>;
/**
 * The setting's value, or its default.
 *
 * Three things read as the default, and deliberately all three: no row, a
 * value that is not valid JSON, and a value the setting's decoder refuses. A
 * settings row is written by some build of the app and read by another, so a
 * value that has stopped meaning anything is a thing that happens — and a
 * person who updates the app should see the default rather than a launch that
 * throws. The row is left as it is, so the value survives going back.
 */
export async function getSetting<T>(
  db: Queryable,
  definition: SettingDefinition<T>,
  budgetId?: string,
): Promise<T> {
  const scope = settingScope(definition, budgetId);
  const statement = settingStatement(definition.key, scope);
  const row = await db.get<{ value: string }>(statement.sql, statement.params);

  if (row === undefined) return definition.fallback;

  try {
    return definition.decode(JSON.parse(row.value));
  } catch {
    return definition.fallback;
  }
}
