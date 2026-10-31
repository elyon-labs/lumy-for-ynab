/**
 * Which catalog to render in.
 *
 * Pure, and in its own module so a test can reach it without loading
 * `expo-localization` — which is a native module and has nothing to say
 * outside an app.
 */

export const DEFAULT_LANGUAGE = 'en';

/**
 * The device's language, if there is a catalog for it.
 *
 * There is one, so this is always English today. It reads the locale list
 * anyway, in the order the device ranked it, so that adding a catalog is
 * adding a file.
 */
export function resolveLanguage(
  locales: readonly { languageCode: string | null }[],
  available: readonly string[] = [DEFAULT_LANGUAGE],
): string {
  for (const locale of locales) {
    if (locale.languageCode !== null && available.includes(locale.languageCode)) {
      return locale.languageCode;
    }
  }

  return DEFAULT_LANGUAGE;
}
