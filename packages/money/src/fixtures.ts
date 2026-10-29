import type { CurrencyFormat } from './types';

/**
 * Real formats YNAB returns, chosen for the ways they differ.
 *
 * Between them they cover a symbol before and after the amount, a hidden
 * symbol, separators that are swapped relative to English, a separator that is
 * a space, a currency with no fractional part at all, and one finer than two
 * places.
 */
export const USD: CurrencyFormat = {
  isoCode: 'USD',
  decimalDigits: 2,
  decimalSeparator: '.',
  groupSeparator: ',',
  currencySymbol: '$',
  symbolFirst: true,
  displaySymbol: true,
};

export const EUR_DE: CurrencyFormat = {
  isoCode: 'EUR',
  decimalDigits: 2,
  decimalSeparator: ',',
  groupSeparator: '.',
  currencySymbol: '€',
  symbolFirst: false,
  displaySymbol: true,
};

/** Separators are a space and a comma, which trips naive string replacement. */
export const SEK: CurrencyFormat = {
  isoCode: 'SEK',
  decimalDigits: 2,
  decimalSeparator: ',',
  groupSeparator: ' ',
  currencySymbol: 'kr',
  symbolFirst: false,
  displaySymbol: true,
};

/** No fractional part: a milliunit amount of 1000 is one whole yen. */
export const JPY: CurrencyFormat = {
  isoCode: 'JPY',
  decimalDigits: 0,
  decimalSeparator: '.',
  groupSeparator: ',',
  currencySymbol: '¥',
  symbolFirst: true,
  displaySymbol: true,
};

/** Three decimal places, so minor units and milliunits coincide. */
export const KWD: CurrencyFormat = {
  isoCode: 'KWD',
  decimalDigits: 3,
  decimalSeparator: '.',
  groupSeparator: ',',
  currencySymbol: 'KD',
  symbolFirst: true,
  displaySymbol: true,
};

export const NO_SYMBOL: CurrencyFormat = {
  isoCode: 'USD',
  decimalDigits: 2,
  decimalSeparator: '.',
  groupSeparator: ',',
  currencySymbol: '$',
  symbolFirst: true,
  displaySymbol: false,
};

export const ALL_FORMATS = [USD, EUR_DE, SEK, JPY, KWD, NO_SYMBOL] as const;
