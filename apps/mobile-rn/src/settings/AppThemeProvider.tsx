import { Settings } from '@lumy/data';
import { ThemeProvider } from '@lumy/ui';
import type { ReactNode } from 'react';

import { useSetting } from './useSetting';

/**
 * Hands `packages/ui` the stored theme preference.
 *
 * The preference is a prop on `ThemeProvider` rather than something that
 * package reads, because storage belongs to the app; this is the one module
 * that joins the two. `system` is resolved against the device inside the
 * provider, so it follows the phone live.
 *
 * Before the first read lands the preference is the setting's own default,
 * which is also what an unwritten setting reads as — so the app never renders
 * a theme nobody chose and then flips out of it.
 */
export function AppThemeProvider({ children }: { children: ReactNode }) {
  const { value } = useSetting(Settings.themePreference);

  return <ThemeProvider preference={value}>{children}</ThemeProvider>;
}
