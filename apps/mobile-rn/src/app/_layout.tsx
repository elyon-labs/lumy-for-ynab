import { Stack } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { ThemeProvider, useAppFonts } from '@lumy/ui';

import { DatabaseProvider } from '@/data';

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
      {/* The stored theme preference arrives with the settings store, so this
          follows the device until then. */}
      <ThemeProvider>
        <DatabaseProvider>
          <Stack screenOptions={{ headerShown: false }} />
        </DatabaseProvider>
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
