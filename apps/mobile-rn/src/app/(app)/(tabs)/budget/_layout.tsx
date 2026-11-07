import { Stack } from 'expo-router';

/**
 * The tab's own stack, so pushing a detail screen keeps the tab bar and each
 * tab remembers where it was. This is what the Flutter app's
 * `StatefulShellBranch` per tab provided.
 */
export default function TabStack() {
  return <Stack screenOptions={{ headerShown: false }} />;
}
