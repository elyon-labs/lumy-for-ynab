import {
  formatCompact,
  formatMilliunits,
  isOutflow,
  type CurrencyFormat,
  type Milliunits,
} from '@lumy/money';

import { Text, type TextProps, type TextTone } from './Text';

export interface MoneyProps extends Omit<TextProps, 'children' | 'tabular'> {
  amount: Milliunits;
  format: CurrencyFormat;
  /**
   * Colours outflow red and inflow green.
   *
   * Off by default: a list where every row is already an expense reads as a
   * wall of red, and the colour says nothing the column position does not.
   * Worth turning on where both directions appear together.
   */
  colorBySign?: boolean;
  signDisplay?: 'auto' | 'always' | 'never';
  hideDecimals?: boolean;
  /** Shortens to a K/M/B figure, for a chart label or a stat tile. */
  compact?: boolean;
  /** The step between surrounding labels, which sets a compact figure's precision. */
  interval?: Milliunits;
}

/**
 * An amount, written the way the budget's currency is written.
 *
 * Every amount on screen goes through this, so the questions of how a negative
 * is shown and whether a sign is coloured are answered once.
 */
export function Money({
  amount,
  format,
  colorBySign = false,
  signDisplay,
  hideDecimals,
  compact = false,
  interval,
  tone,
  ...rest
}: MoneyProps) {
  const signTone: TextTone = isOutflow(amount) ? 'negative' : 'positive';

  const text = compact
    ? formatCompact(amount, format, { interval, signDisplay })
    : formatMilliunits(amount, format, { signDisplay, hideDecimals });

  return (
    <Text tabular tone={tone ?? (colorBySign ? signTone : 'default')} {...rest}>
      {text}
    </Text>
  );
}
