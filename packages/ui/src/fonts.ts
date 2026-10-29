import { useFonts } from 'expo-font';

/**
 * Outfit, in the four weights the type scale uses.
 *
 * The files ship with this package rather than with the app, because the
 * package is what decides the app has a typeface at all. They are loaded from
 * local assets rather than fetched, so the first frame is never a fallback
 * face.
 */
export const FontAssets = {
  Outfit: require('../assets/fonts/Outfit-Regular.ttf') as number,
  'Outfit-Medium': require('../assets/fonts/Outfit-Medium.ttf') as number,
  'Outfit-SemiBold': require('../assets/fonts/Outfit-SemiBold.ttf') as number,
  'Outfit-Bold': require('../assets/fonts/Outfit-Bold.ttf') as number,
} as const;

/**
 * Loads the typeface. The app holds the splash screen until this reports true.
 */
export function useAppFonts(): [boolean, Error | null] {
  return useFonts(FontAssets);
}
