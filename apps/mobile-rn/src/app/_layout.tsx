import { Stack } from 'expo-router';

export default function RootLayout() {
  // The navigation shell replaces this. Until then the header would only show
  // a route filename.
  return <Stack screenOptions={{ headerShown: false }} />;
}
