import { StyleSheet, View } from 'react-native';

import { DEFAULT_CURRENCY_FORMAT, milliunits } from '@lumy/money';
import { Spacing } from '@lumy/theme';
import { Card, ListRow, Money, Screen, SectionHeader, Text } from '@lumy/ui';

/**
 * A placeholder so the skeleton runs, standing in until the navigation shell
 * replaces it. It renders an amount because that is the one thing worth
 * checking on a device before the data layer exists.
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

        <Card flush>
          <ListRow
            title="Inflow"
            accessory={
              <Money amount={milliunits(1_234_560)} format={DEFAULT_CURRENCY_FORMAT} colorBySign />
            }
          />
          <ListRow
            title="Outflow"
            accessory={
              <Money amount={milliunits(-98_700)} format={DEFAULT_CURRENCY_FORMAT} colorBySign />
            }
          />
        </Card>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
