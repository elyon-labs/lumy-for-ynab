import { getLocales } from 'expo-localization';
import { createInstance } from 'i18next';
import { initReactI18next } from 'react-i18next';

import { en } from './en';
import { DEFAULT_LANGUAGE, resolveLanguage } from './language';

/**
 * Translation, from the first screen that has copy on it.
 *
 * English is the only catalog, and will be for a while. It is here anyway
 * because retrofitting it is the expensive direction: every string written
 * without it is a string someone has to find again, and the Flutter app's
 * hardcoded copy is exactly that bill left unpaid.
 *
 * `en` is typed `as const`, so `t` only accepts keys the catalog has and a
 * renamed key fails `pnpm typecheck` rather than rendering its own name.
 */

declare module 'i18next' {
  interface CustomTypeOptions {
    defaultNS: 'translation';
    resources: { translation: typeof en };
  }
}

/**
 * Our own instance rather than the module-level default.
 *
 * `initReactI18next` makes it the one `useTranslation` reads, and having a
 * named instance means nothing in the app depends on import order to find a
 * configured translator.
 */
export const i18n = createInstance();

export function initI18n(): void {
  if (i18n.isInitialized) return;

  void i18n.use(initReactI18next).init({
    resources: { en: { translation: en } },
    lng: resolveLanguage(getLocales()),
    fallbackLng: DEFAULT_LANGUAGE,
    // React Native has no `Intl` plural rules to interpolate against in every
    // engine, and nothing here escapes into HTML.
    interpolation: { escapeValue: false },
    returnNull: false,
  });
}

export { en } from './en';
export type { Catalog } from './en';
export * from './language';
