import { z } from 'zod';

import { isoMonth, optionalText, response } from './common';

/**
 * How a budget's amounts are written.
 *
 * The field names are flattened to the shape `@lumy/money` takes, so nothing
 * downstream has to know YNAB calls it `symbol_first`.
 */
export const currencyFormatSchema = z
  .object({
    iso_code: z.string(),
    decimal_digits: z.number().int().min(0),
    decimal_separator: z.string(),
    group_separator: z.string(),
    currency_symbol: z.string(),
    symbol_first: z.boolean(),
    display_symbol: z.boolean(),
    example_format: z.string().optional(),
  })
  .transform((raw) => ({
    isoCode: raw.iso_code,
    decimalDigits: raw.decimal_digits,
    decimalSeparator: raw.decimal_separator,
    groupSeparator: raw.group_separator,
    currencySymbol: raw.currency_symbol,
    symbolFirst: raw.symbol_first,
    displaySymbol: raw.display_symbol,
  }));

export const budgetSchema = z
  .object({
    id: z.string(),
    name: z.string(),
    first_month: isoMonth.nullish(),
    last_month: isoMonth.nullish(),
    last_modified_on: optionalText,
    currency_format: currencyFormatSchema.nullish(),
  })
  .transform((raw) => ({
    id: raw.id,
    name: raw.name,
    firstMonth: raw.first_month ?? null,
    lastMonth: raw.last_month ?? null,
    lastModifiedOn: raw.last_modified_on,
    currencyFormat: raw.currency_format ?? null,
  }));

/**
 * The budget list.
 *
 * Alone among the synced resources it carries no `server_knowledge`: YNAB
 * offers no delta for it, so it is fetched whole each time.
 */
export const budgetsResponseSchema = response(z.object({ budgets: z.array(budgetSchema) }));

export type Budget = z.output<typeof budgetSchema>;
