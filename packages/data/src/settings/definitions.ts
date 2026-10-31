import { DEFAULT_PERIOD, PERIOD_TYPES, isDate, type Period } from './period';

/**
 * Every setting the app has, with its key, its scope, its default, and the
 * decoder that says what a stored value is allowed to be.
 *
 * This is the whole of what `lib/persistence/settings.dart` was: 630 lines of
 * `rx_shared_preferences` streams, one pair of methods per setting, each
 * re-stating the key, the default, and the parse. A setting here is a value in
 * a table, and everything that reads or writes one goes through `getSetting`
 * and `setSetting`.
 *
 * Budget scoping is part of the definition rather than something a call site
 * builds. The Flutter app interpolated the budget id into the preference key
 * at every use — `spend_tracker_order_2_$budgetId` — and so had to remember,
 * per call, to do nothing when no budget was selected. Here the scope is
 * declared once and the accessor's type will not let a budget-scoped setting
 * be read without one.
 */

export type SettingScope = 'global' | 'budget';

export interface SettingDefinition<T> {
  /** The `settings.key` column. Stable: it is what a device already stored. */
  readonly key: string;
  readonly scope: SettingScope;
  /** What a setting that has never been written reads as. */
  readonly fallback: T;
  /**
   * Turns a parsed JSON value into the setting's type.
   *
   * Throws on anything it does not recognise, which `getSetting` reads as the
   * fallback. A stored value that no longer decodes is what another build of
   * the app left behind, and someone who updates should see the default rather
   * than a crash on launch.
   */
  readonly decode: (raw: unknown) => T;
}

export interface GlobalSetting<T> extends SettingDefinition<T> {
  readonly scope: 'global';
}

export interface BudgetSetting<T> extends SettingDefinition<T> {
  readonly scope: 'budget';
}

function globalSetting<T>(
  key: string,
  fallback: T,
  decode: (raw: unknown) => T,
): GlobalSetting<T> {
  return { key, scope: 'global', fallback, decode };
}

function budgetSetting<T>(
  key: string,
  fallback: T,
  decode: (raw: unknown) => T,
): BudgetSetting<T> {
  return { key, scope: 'budget', fallback, decode };
}

function reject(raw: unknown): never {
  throw new Error(`Not a value this setting can hold: ${JSON.stringify(raw) ?? 'undefined'}`);
}

const asString = (raw: unknown): string => (typeof raw === 'string' ? raw : reject(raw));

const asNullableString = (raw: unknown): string | null => (raw === null ? null : asString(raw));

const asBoolean = (raw: unknown): boolean => (typeof raw === 'boolean' ? raw : reject(raw));

const asCount = (raw: unknown): number =>
  typeof raw === 'number' && Number.isInteger(raw) && raw >= 0 ? raw : reject(raw);

const asStringList = (raw: unknown): string[] =>
  Array.isArray(raw) && raw.every((item) => typeof item === 'string') ? [...raw] : reject(raw);

/** An enum, which is the shape most of these settings are. */
function asOneOf<T extends string>(allowed: readonly T[]): (raw: unknown) => T {
  return (raw) => (allowed.includes(raw as T) ? (raw as T) : reject(raw));
}

const asPeriodType = asOneOf(PERIOD_TYPES);

/**
 * A chosen period, with its range when it is custom.
 *
 * The range is validated here rather than where it is resolved, so a stored
 * `custom` can never be read as a period with no dates in it.
 */
function asPeriod(raw: unknown): Period {
  if (typeof raw !== 'object' || raw === null) reject(raw);

  const { type, from, to } = raw as Record<string, unknown>;
  const periodType = asPeriodType(type);

  if (periodType !== 'custom') return { type: periodType };
  if (!isDate(from) || !isDate(to)) reject(raw);

  return { type: 'custom', from, to };
}

export type ThemePreference = 'system' | 'light' | 'dark';

export const THEME_PREFERENCES: readonly ThemePreference[] = ['system', 'light', 'dark'];

export type RecurringTransactionsSort = 'amountAsc' | 'amountDesc' | 'nameAsc' | 'nameDesc';

export const RECURRING_TRANSACTIONS_SORTS: readonly RecurringTransactionsSort[] = [
  'amountAsc',
  'amountDesc',
  'nameAsc',
  'nameDesc',
];

export type SpendTrackerOrderStrategy = 'manual' | 'alphabetical' | 'created';

export const SPEND_TRACKER_ORDER_STRATEGIES: readonly SpendTrackerOrderStrategy[] = [
  'manual',
  'alphabetical',
  'created',
];

/**
 * The settings, by name.
 *
 * Keys are the strings in the table and do not change. Where one differs from
 * the Flutter preference key it is because nothing migrates: the RN app reads
 * its own store, so the keys are free to say what they mean.
 */
export const Settings = {
  /**
   * Dark by default, as in the Flutter app, whose `watchThemeMode` fell back
   * to `ThemeMode.dark`. `system` is resolved against the device by
   * `ThemeProvider`, not here.
   */
  themePreference: globalSetting<ThemePreference>(
    'theme_preference',
    'dark',
    asOneOf(THEME_PREFERENCES),
  ),

  /** Null until the person picks one, which they do on first run. */
  selectedBudgetId: globalSetting<string | null>('selected_budget_id', null, asNullableString),

  /**
   * The period every report is read through, carrying its own range when it is
   * custom. Global rather than per budget: it is a lens on data rather than
   * part of it, and switching budget should not forget it.
   */
  selectedPeriod: globalSetting<Period>('selected_period', DEFAULT_PERIOD, asPeriod),

  /** Chart ids the person turned off. A chart not listed here is shown. */
  hiddenChartIds: globalSetting<string[]>('hidden_chart_ids', [], asStringList),

  /**
   * Chart ids in the order the person arranged them.
   *
   * A partial order: ids listed here lead, and a chart the list does not
   * mention keeps its place behind them. That is what lets a chart added by a
   * later release appear without the stored order having to be rewritten.
   */
  chartOrder: globalSetting<string[]>('chart_order', [], asStringList),

  recurringTransactionsSort: globalSetting<RecurringTransactionsSort>(
    'recurring_transactions_sort',
    'amountDesc',
    asOneOf(RECURRING_TRANSACTIONS_SORTS),
  ),

  /** The release whose what's-new has already been shown. */
  lastWhatsNewVersion: globalSetting<string | null>(
    'last_whats_new_version',
    null,
    asNullableString,
  ),

  /** How many things worth being asked about a review have happened. */
  appReviewEvents: globalSetting<number>('app_review_events', 0, asCount),

  /**
   * When the review prompt was last shown, ISO-8601.
   *
   * A date string rather than the Flutter app's epoch milliseconds, so every
   * time in this database is written and compared the same way.
   */
  lastAppReviewRequest: globalSetting<string | null>(
    'last_app_review_request',
    null,
    asNullableString,
  ),

  hasOnboarded: globalSetting<boolean>('has_onboarded', false, asBoolean),

  /** Spend tracker ids in the order they were dragged into. */
  spendTrackerOrder: budgetSetting<string[]>('spend_tracker_order', [], asStringList),

  spendTrackerOrderStrategy: budgetSetting<SpendTrackerOrderStrategy>(
    'spend_tracker_order_strategy',
    'manual',
    asOneOf(SPEND_TRACKER_ORDER_STRATEGIES),
  ),
} as const;

export type SettingName = keyof typeof Settings;

export const SETTING_NAMES = Object.keys(Settings) as SettingName[];

/** Every definition, for the tests that hold the registry to its own rules. */
export const SETTING_DEFINITIONS: readonly SettingDefinition<unknown>[] = SETTING_NAMES.map(
  (name) => Settings[name] as SettingDefinition<unknown>,
);

/**
 * The `settings.scope` a definition reads and writes under.
 *
 * `''` for a global setting, the budget id for a budget-scoped one. Throwing
 * on a missing budget rather than falling back to `''` is deliberate: the two
 * would otherwise share a row, so one budget's spend tracker order would be
 * read as another's.
 */
export function settingScope(
  definition: SettingDefinition<unknown>,
  budgetId?: string | null,
): string {
  if (definition.scope === 'global') return '';
  if (budgetId === undefined || budgetId === null || budgetId === '') {
    throw new Error(`${definition.key} is scoped to a budget, and none was given.`);
  }

  return budgetId;
}
