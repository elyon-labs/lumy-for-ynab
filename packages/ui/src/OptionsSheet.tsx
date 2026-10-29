import { View } from 'react-native';

import { BottomSheet } from './BottomSheet';
import { Divider } from './Divider';
import { ListRow } from './ListRow';

export interface SheetOption {
  label: string;
  onSelect: () => void;
  destructive?: boolean;
  disabled?: boolean;
}

export interface OptionsSheetProps {
  title?: string;
  options: readonly SheetOption[];
  onDismiss: () => void;
  dismissLabel?: string;
}

/**
 * A sheet of actions.
 *
 * Selecting one dismisses the sheet before running it, so an action that
 * navigates does not leave a sheet behind on the screen it came from.
 */
export function OptionsSheet({ title, options, onDismiss, dismissLabel }: OptionsSheetProps) {
  return (
    <BottomSheet title={title} onDismiss={onDismiss} dismissLabel={dismissLabel}>
      <View>
        {options.map((option, index) => (
          <View key={option.label}>
            {index > 0 ? <Divider /> : null}
            <ListRow
              title={option.label}
              destructive={option.destructive}
              disabled={option.disabled}
              onPress={() => {
                onDismiss();
                option.onSelect();
              }}
            />
          </View>
        ))}
      </View>
    </BottomSheet>
  );
}
