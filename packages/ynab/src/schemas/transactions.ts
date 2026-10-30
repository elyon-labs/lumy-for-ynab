import { z } from 'zod';

import {
  amount,
  deleted,
  flagColor,
  isoDate,
  optionalId,
  optionalText,
  response,
  serverKnowledge,
} from './common';

/**
 * One leg of a split.
 *
 * Carries its own category and amount, and may carry its own payee. The
 * parent's payload is the only place these appear — YNAB has no endpoint for
 * them — which is why a leg that goes away is simply absent from the next
 * page rather than returned as deleted. Reconciliation of the set, not
 * upserting of what arrived, is what keeps that from leaving a stale row.
 */
export const subtransactionSchema = z
  .object({
    id: z.string(),
    transaction_id: z.string(),
    amount,
    memo: optionalText,
    payee_id: optionalId,
    payee_name: optionalText,
    category_id: optionalId,
    category_name: optionalText,
    transfer_account_id: optionalId,
    transfer_transaction_id: optionalId,
    deleted,
  })
  .transform((raw) => ({
    id: raw.id,
    transactionId: raw.transaction_id,
    amount: raw.amount,
    memo: raw.memo,
    payeeId: raw.payee_id,
    payeeName: raw.payee_name,
    categoryId: raw.category_id,
    categoryName: raw.category_name,
    transferAccountId: raw.transfer_account_id,
    transferTransactionId: raw.transfer_transaction_id,
    deleted: raw.deleted,
  }));

export const transactionSchema = z
  .object({
    id: z.string(),
    date: isoDate,
    amount,
    memo: optionalText,
    cleared: z.string(),
    approved: z.boolean(),
    flag_color: flagColor,
    account_id: z.string(),
    payee_id: optionalId,
    payee_name: optionalText,
    category_id: optionalId,
    category_name: optionalText,
    transfer_account_id: optionalId,
    transfer_transaction_id: optionalId,
    matched_transaction_id: optionalId,
    import_id: optionalId,
    deleted,
    // Absent on a simple transaction in some payloads rather than empty.
    subtransactions: z.array(subtransactionSchema).default([]),
  })
  .transform((raw) => ({
    id: raw.id,
    date: raw.date,
    amount: raw.amount,
    memo: raw.memo,
    cleared: raw.cleared,
    approved: raw.approved,
    flagColor: raw.flag_color,
    accountId: raw.account_id,
    payeeId: raw.payee_id,
    payeeName: raw.payee_name,
    categoryId: raw.category_id,
    categoryName: raw.category_name,
    transferAccountId: raw.transfer_account_id,
    transferTransactionId: raw.transfer_transaction_id,
    matchedTransactionId: raw.matched_transaction_id,
    importId: raw.import_id,
    deleted: raw.deleted,
    subtransactions: raw.subtransactions,
  }));

export const transactionsResponseSchema = response(
  z.object({ transactions: z.array(transactionSchema), server_knowledge: serverKnowledge }),
);

/** What `POST /budgets/{id}/transactions` returns. */
export const createTransactionResponseSchema = response(
  z.object({
    transaction: transactionSchema,
    server_knowledge: serverKnowledge,
  }),
);

export type Transaction = z.output<typeof transactionSchema>;
export type Subtransaction = z.output<typeof subtransactionSchema>;
