import { StyleSheet, View } from 'react-native';

import { useColors } from './theme';

export interface DividerProps {
  /** Indents the rule to line up with a row's text rather than its edge. */
  inset?: number;
}

export function Divider({ inset = 0 }: DividerProps) {
  const colors = useColors();

  return <View style={[styles.divider, { backgroundColor: colors.border, marginLeft: inset }]} />;
}

const styles = StyleSheet.create({
  divider: { height: StyleSheet.hairlineWidth },
});
