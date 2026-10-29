import { StyleSheet, Text, View } from 'react-native';

/**
 * A placeholder so the skeleton runs.
 *
 * Deliberately styled with local values: `@lumy/theme` and `@lumy/ui` do not
 * exist yet, and this screen is replaced by the navigation shell before any
 * real UI lands.
 */
export default function Index() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Lumy</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 24,
  },
});
