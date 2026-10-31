import { Stack } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { useAppFonts } from '@lumy/ui';

import { DatabaseProvider } from '@/data';
import { AppThemeProvider, SelectedBudgetProvider, SelectedPeriodProvider } from '@/settings';

// Held until the typeface is ready, so the first frame is never a fallback
// face that reflows the moment Outfit loads.
void SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [fontsLoaded, fontError] = useAppFonts();

  useEffect(() => {
    // A missing font is not worth stranding the app behind a splash screen
    // forever; the system face is a usable fallback.
    if (fontsLoaded || fontError) {
      void SplashScreen.hideAsync();
    }
  }, [fontsLoaded, fontError]);

  if (!fontsLoaded && !fontError) {
    return null;
  }

  return (
    <SafeAreaProvider>
      {/* Everything that reads a setting is inside the database, because that
          is where the settings are. Each of these renders its default until
          the first read lands, so nothing below waits on a guard. */}
      <DatabaseProvider>
        <AppThemeProvider>
          <SelectedBudgetProvider>
            <SelectedPeriodProvider>
              <Stack screenOptions={{ headerShown: false }} />
            </SelectedPeriodProvider>
          </SelectedBudgetProvider>
        </AppThemeProvider>
      </DatabaseProvider>
    </SafeAreaProvider>
  );
}
