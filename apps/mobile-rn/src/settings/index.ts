/**
 * The settings store's React side.
 *
 * The store itself — the registry, the codecs, the period model, and the
 * accessors — is `@lumy/data`, so the background sync task can read the
 * selected budget and period without any of this. What is here is only what
 * needs a component tree: one hook over the live query, and the two selection
 * contexts whose values lead every query key.
 */
export * from './AppThemeProvider';
export * from './SelectedBudgetProvider';
export * from './SelectedPeriodProvider';
export * from './today';
export * from './useSetting';
