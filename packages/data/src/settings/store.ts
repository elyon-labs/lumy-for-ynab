import type { Queryable } from '../adapters/types';
import {
  settingScope,
  type BudgetSetting,
  type GlobalSetting,
  type SettingDefinition,
} from './definitions';

/**
 * Writing a setting.
 *
 * One statement, so a write is one committed transaction and therefore one
 * change notification — which is what makes every screen reading that setting
 * re-read it. Writes are upserts by the primary key, so setting a value twice
 * leaves one row, exactly as the sync engine's writers do.
 */

export function setSetting<T>(
  db: Queryable,
  definition: GlobalSetting<T>,
  value: T,
): Promise<void>;
export function setSetting<T>(
  db: Queryable,
  definition: BudgetSetting<T>,
  value: T,
  budgetId: string,
): Promise<void>;
/**
 * Stores a value, refusing one the setting could not read back.
 *
 * The round trip through the setting's own decoder is the guard. Types stop
 * most of what could go wrong, but not all of it: a custom period's dates are
 * strings whatever is in them, and a range written with a date the decoder
 * refuses would store happily and then read as this month forever. Failing at
 * the write puts the error where the mistake is.
 */
export async function setSetting<T>(
  db: Queryable,
  definition: SettingDefinition<T>,
  value: T,
  budgetId?: string,
): Promise<void> {
  const scope = settingScope(definition, budgetId);
  const encoded = JSON.stringify(value);

  try {
    definition.decode(JSON.parse(encoded));
  } catch (cause) {
    throw new Error(`${definition.key} cannot store ${encoded}.`, { cause });
  }

  await db.run(
    `INSERT INTO settings (key, scope, value) VALUES (?, ?, ?)
     ON CONFLICT (key, scope) DO UPDATE SET value = excluded.value`,
    [definition.key, scope, encoded],
  );
}
