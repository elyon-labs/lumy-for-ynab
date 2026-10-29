import { StyleSheet, View } from 'react-native';

import { Spacing } from '@lumy/theme';
import { Card, Screen, SectionHeader, Text } from '@lumy/ui';

/**
 * A placeholder so the skeleton runs, and the first consumer of the UI
 * package. The navigation shell replaces it.
 */
export default function Index() {
  return (
    <Screen title="Lumy">
      <View style={styles.body}>
        <SectionHeader title="Getting started" />
        <Card>
          <Text weight="semibold">Nothing here yet</Text>
          <Text tone="muted">
            The budget, reports, and settings tabs arrive with the navigation shell.
          </Text>
        </Card>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge },
});
