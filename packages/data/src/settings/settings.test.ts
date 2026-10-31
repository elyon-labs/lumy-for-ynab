import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import type { DatabaseAdapter } from '../adapters/types';
import { getSetting } from '../read/settings';
import { createHarness, type Harness } from '../testing';
import {
  SETTING_DEFINITIONS,
  SETTING_NAMES,
  Settings,
  settingScope,
  type SettingDefinition,
} from './definitions';
import { setSetting } from './store';

const BUDGET = 'budget-1';
const OTHER_BUDGET = 'budget-2';

/** Writes a value past the typed accessor, as another build of the app might. */
async function store(
  db: DatabaseAdapter,
  definition: SettingDefinition<unknown>,
  json: string,
  scope = '',
): Promise<void> {
  await db.run(
    `INSERT INTO settings (key, scope, value) VALUES (?, ?, ?)
     ON CONFLICT (key, scope) DO UPDATE SET value = excluded.value`,
    [definition.key, scope, json],
  );
}

async function rowCount(db: DatabaseAdapter): Promise<number> {
  const row = await db.get<{ n: number }>('SELECT COUNT(*) AS n FROM settings');

  return row?.n ?? 0;
}

describe('the settings registry', () => {
  it('gives every setting its own key', () => {
    const keys = SETTING_DEFINITIONS.map((definition) => definition.key);

    expect(new Set(keys).size).toBe(keys.length);
  });

  it('gives every setting a default it can decode', () => {
    // A default the decoder refuses would be a setting that cannot round trip
    // its own untouched state.
    for (const name of SETTING_NAMES) {
      const definition = Settings[name] as SettingDefinition<unknown>;

      expect(() => definition.decode(JSON.parse(JSON.stringify(definition.fallback))), name).not.toThrow();
    }
  });

  it('refuses to scope a budget setting to no budget', () => {
    expect(() => settingScope(Settings.spendTrackerOrder)).toThrow(/scoped to a budget/);
    expect(() => settingScope(Settings.spendTrackerOrder, '')).toThrow(/scoped to a budget/);
  });

  it('scopes a global setting to nothing, whatever budget it is handed', () => {
    expect(settingScope(Settings.themePreference, BUDGET)).toBe('');
  });
});

describe('a setting', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
  });

  afterEach(async () => {
    await harness.close();
  });

  it('reads as its default before anything has written it', async () => {
    expect(await getSetting(db, Settings.themePreference)).toBe('dark');
    expect(await getSetting(db, Settings.selectedBudgetId)).toBeNull();
    expect(await getSetting(db, Settings.selectedPeriod)).toEqual({ type: 'thisMonth' });
    expect(await getSetting(db, Settings.hasOnboarded)).toBe(false);
    expect(await getSetting(db, Settings.appReviewEvents)).toBe(0);
    expect(await getSetting(db, Settings.chartOrder)).toEqual([]);
    expect(await getSetting(db, Settings.spendTrackerOrder, BUDGET)).toEqual([]);
  });

  it('reads back what was written', async () => {
    await setSetting(db, Settings.themePreference, 'light');
    await setSetting(db, Settings.selectedBudgetId, BUDGET);
    await setSetting(db, Settings.selectedPeriod, {
      type: 'custom',
      from: '2026-01-01',
      to: '2026-03-31',
    });
    await setSetting(db, Settings.spendTrackerOrder, ['b', 'a'], BUDGET);

    expect(await getSetting(db, Settings.themePreference)).toBe('light');
    expect(await getSetting(db, Settings.selectedBudgetId)).toBe(BUDGET);
    expect(await getSetting(db, Settings.selectedPeriod)).toEqual({
      type: 'custom',
      from: '2026-01-01',
      to: '2026-03-31',
    });
    expect(await getSetting(db, Settings.spendTrackerOrder, BUDGET)).toEqual(['b', 'a']);
  });

  it('holds one row however often it is written', async () => {
    await setSetting(db, Settings.themePreference, 'light');
    await setSetting(db, Settings.themePreference, 'dark');
    await setSetting(db, Settings.themePreference, 'system');

    expect(await rowCount(db)).toBe(1);
    expect(await getSetting(db, Settings.themePreference)).toBe('system');
  });

  it('stores a null the person chose, rather than forgetting the setting', async () => {
    await setSetting(db, Settings.selectedBudgetId, BUDGET);
    await setSetting(db, Settings.selectedBudgetId, null);

    expect(await rowCount(db)).toBe(1);
    expect(await getSetting(db, Settings.selectedBudgetId)).toBeNull();
  });

  it('keeps one budget apart from another', async () => {
    await setSetting(db, Settings.spendTrackerOrder, ['a'], BUDGET);
    await setSetting(db, Settings.spendTrackerOrder, ['b'], OTHER_BUDGET);

    expect(await getSetting(db, Settings.spendTrackerOrder, BUDGET)).toEqual(['a']);
    expect(await getSetting(db, Settings.spendTrackerOrder, OTHER_BUDGET)).toEqual(['b']);
    expect(await rowCount(db)).toBe(2);
  });

  it('reports one change per write, so a screen reading it re-reads once', async () => {
    const before = harness.changes.length;

    await setSetting(db, Settings.hasOnboarded, true);

    expect(harness.changes.slice(before)).toEqual([['settings']]);
  });
});

describe('a stored value another build left behind', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
  });

  afterEach(async () => {
    await harness.close();
  });

  it('reads as the default when the decoder refuses it', async () => {
    await store(db, Settings.themePreference, '"solarized"');

    expect(await getSetting(db, Settings.themePreference)).toBe('dark');
  });

  it('reads as the default when it is not even JSON', async () => {
    await store(db, Settings.chartOrder, 'net-worth,spend');

    expect(await getSetting(db, Settings.chartOrder)).toEqual([]);
  });

  it('is left where it is, so going back to the build that wrote it still works', async () => {
    await store(db, Settings.themePreference, '"solarized"');

    await getSetting(db, Settings.themePreference);

    const row = await db.get<{ value: string }>('SELECT value FROM settings WHERE key = ?', [
      Settings.themePreference.key,
    ]);
    expect(row?.value).toBe('"solarized"');
  });

  it.each([
    ['a period with no type', '{}'],
    ['a custom period with no range', '{"type":"custom"}'],
    ['a custom period with a date in another format', '{"type":"custom","from":"01/01/2026","to":"2026-03-31"}'],
  ])('reads a period back as this month when it is %s', async (_case, json) => {
    await store(db, Settings.selectedPeriod, json);

    expect(await getSetting(db, Settings.selectedPeriod)).toEqual({ type: 'thisMonth' });
  });
});

describe('writing a value the setting could not read back', () => {
  let harness: Harness;
  let db: DatabaseAdapter;

  beforeEach(async () => {
    harness = await createHarness();
    db = harness.db;
  });

  afterEach(async () => {
    await harness.close();
  });

  it('fails at the write rather than silently at the next read', async () => {
    // The type says `from` and `to` are strings, which is not enough: a date
    // in the wrong format would store happily and then read as this month
    // forever, which looks like the period being ignored.
    await expect(
      setSetting(db, Settings.selectedPeriod, {
        type: 'custom',
        from: '01/01/2026',
        to: '2026-03-31',
      }),
    ).rejects.toThrow(/cannot store/);

    expect(await rowCount(db)).toBe(0);
  });
});
