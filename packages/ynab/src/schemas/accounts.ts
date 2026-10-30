import { z } from 'zod';

import { amount, deleted, response, serverKnowledge } from './common';

/**
 * YNAB's per-month loan figures.
 *
 * Three objects keyed by month, which flatten into one list of rows because
 * they share that key exactly. A month present in one and absent from another
 * leaves the other value null.
 */
const periodicValues = z.record(z.string(), amount.nullable()).nullish();

function debtMonths(
  interestRates: Record<string, number | null> | null | undefined,
  minimumPayments: Record<string, number | null> | null | undefined,
  escrowAmounts: Record<string, number | null> | null | undefined,
): { month: string; interestRate: number | null; minimumPayment: number | null; escrowAmount: number | null }[] {
  const months = new Set([
    ...Object.keys(interestRates ?? {}),
    ...Object.keys(minimumPayments ?? {}),
    ...Object.keys(escrowAmounts ?? {}),
  ]);

  return [...months].sort().map((month) => ({
    month,
    interestRate: interestRates?.[month] ?? null,
    minimumPayment: minimumPayments?.[month] ?? null,
    escrowAmount: escrowAmounts?.[month] ?? null,
  }));
}

export const accountSchema = z
  .object({
    id: z.string(),
    name: z.string(),
    type: z.string(),
    on_budget: z.boolean(),
    closed: z.boolean(),
    balance: amount,
    deleted,
    debt_interest_rates: periodicValues,
    debt_minimum_payments: periodicValues,
    debt_escrow_amounts: periodicValues,
  })
  .transform((raw) => ({
    id: raw.id,
    name: raw.name,
    // Not an enum: a type YNAB adds later should land in the database as the
    // string it sent rather than fail the page that carried it.
    type: raw.type,
    onBudget: raw.on_budget,
    closed: raw.closed,
    balance: raw.balance,
    deleted: raw.deleted,
    debtMonths: debtMonths(
      raw.debt_interest_rates,
      raw.debt_minimum_payments,
      raw.debt_escrow_amounts,
    ),
  }));

export const accountsResponseSchema = response(
  z.object({ accounts: z.array(accountSchema), server_knowledge: serverKnowledge }),
);

export type Account = z.output<typeof accountSchema>;
