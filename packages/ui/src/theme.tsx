import { createContext, useContext, useMemo, type ReactNode } from 'react';
import { useColorScheme } from 'react-native';

import { ChartColors, Colors, type ChartPalette, type ColorScheme, type Palette } from '@lumy/theme';

/** What the person chose, which is not necessarily a scheme. */
export type ThemePreference = ColorScheme | 'system';

export interface ThemeValue {
  scheme: ColorScheme;
  colors: Palette;
  charts: ChartPalette;
}

const ThemeContext = createContext<ThemeValue | null>(null);

export function useTheme(): ThemeValue {
  const value = useContext(ThemeContext);
  if (!value) {
    throw new Error('useTheme must be called inside a ThemeProvider.');
  }
  return value;
}

/** The palette alone, which is all most components need. */
export function useColors(): Palette {
  return useTheme().colors;
}

export function useChartColors(): ChartPalette {
  return useTheme().charts;
}

export interface ThemeProviderProps {
  /**
   * Defaults to following the device. The stored preference is owned by the
   * app, so it is passed in rather than read here — this package has no
   * storage of its own.
   */
  preference?: ThemePreference;
  children: ReactNode;
}

export function ThemeProvider({ preference = 'system', children }: ThemeProviderProps) {
  // Re-renders when the phone switches scheme, so `system` follows it live
  // rather than at the next launch.
  const deviceScheme = useColorScheme();

  const value = useMemo<ThemeValue>(() => {
    const scheme: ColorScheme =
      preference === 'system' ? (deviceScheme === 'dark' ? 'dark' : 'light') : preference;

    return { scheme, colors: Colors[scheme], charts: ChartColors[scheme] };
  }, [deviceScheme, preference]);

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}
