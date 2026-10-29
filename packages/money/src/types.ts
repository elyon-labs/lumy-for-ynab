/**
 * An amount in YNAB milliunits: thousandths of a currency unit.
 *
 * One unit of any currency is 1000 milliunits, whatever that currency's own
 * precision is — $1.00, ¥1, and 1.000 KWD are all 1000. See
 * https://api.ynab.com/#formats.
 *
 * Branded so a bare number cannot be passed where an amount is expected. Every
 * amount in the app is one of these, and none of them is ever a float: money
 * arithmetic that goes through a double accumulates error that shows up as a
 * budget that is off by a cent and stays that way.
 */
export type Milliunits = number & { readonly __brand: 'Milliunits' };

/** How a budget's currency is written, as YNAB reports it. */
export interface CurrencyFormat {
  isoCode: string;
  /** The currency's own precision: 2 for USD, 0 for JPY, 3 for KWD. */
  decimalDigits: number;
  decimalSeparator: string;
  groupSeparator: string;
  currencySymbol: string;
  symbolFirst: boolean;
  displaySymbol: boolean;
}

/**
 * Used until a budget's real format has been synced.
 *
 * It shows no symbol, because a wrong symbol states something false about the
 * amount while a missing one only leaves it unstated.
 */
export const DEFAULT_CURRENCY_FORMAT: CurrencyFormat = {
  isoCode: 'USD',
  decimalDigits: 2,
  decimalSeparator: '.',
  groupSeparator: ',',
  currencySymbol: '',
  symbolFirst: true,
  displaySymbol: false,
};
