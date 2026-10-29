import { StyleSheet, Text, useColorScheme, View } from 'react-native';

import { Colors, FontSize, LineHeight, Spacing } from '@lumy/theme';

/**
 * A placeholder so the skeleton runs, and the first consumer of the tokens.
 *
 * It reads the scheme straight from the device because the theme provider and
 * the stored theme preference arrive with the UI package. The navigation shell
 * replaces this screen.
 */
export default function Index() {
  const colors = Colors[useColorScheme() === 'dark' ? 'dark' : 'light'];

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <Text style={[styles.title, { color: colors.text }]}>Lumy</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: Spacing.edge,
  },
  title: {
    fontSize: FontSize.heading,
    lineHeight: LineHeight.heading,
  },
});
