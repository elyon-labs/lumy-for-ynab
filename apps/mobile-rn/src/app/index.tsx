import { StyleSheet, View } from 'react-native';

import { DEFAULT_CURRENCY_FORMAT, milliunits } from '@lumy/money';
import { Spacing } from '@lumy/theme';
import { Card, ListRow, Money, Screen, SectionHeader, Text } from '@lumy/ui';

import { useDatabase } from '@/data/useDatabase';

/**
 * A placeholder so the skeleton runs, standing in until the navigation shell
 * replaces it. It renders an amount because that is the one thing worth
 * checking on a device before the data layer exists.
 */
export default function Index() {
  const { sqliteVersion, schema, tables, error } = useDatabase();

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
        <SectionHeader title="Database" />
        <Card flush>
          <ListRow
            title="SQLite"
            accessory={<Text tone="muted">{sqliteVersion ?? 'opening'}</Text>}
          />
          <ListRow
            title="Schema"
            accessory={<Text tone="muted">{schema === null ? 'opening' : String(schema)}</Text>}
          />
          <ListRow
            title="Tables"
            accessory={<Text tone="muted">{tables === null ? 'opening' : String(tables)}</Text>}
          />
          {error === null ? null : <ListRow title="Error" subtitle={error.message} destructive />}
        </Card>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { flex: 1, paddingHorizontal: Spacing.edge, gap: Spacing.snug },
});
