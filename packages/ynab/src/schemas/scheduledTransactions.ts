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

export const scheduledSubtransactionSchema = z
  .object({
    id: z.string(),
    scheduled_transaction_id: z.string(),
    amount,
    memo: optionalText,
    payee_id: optionalId,
    category_id: optionalId,
    transfer_account_id: optionalId,
    deleted,
  })
  .transform((raw) => ({
    id: raw.id,
    scheduledTransactionId: raw.scheduled_transaction_id,
    amount: raw.amount,
    memo: raw.memo,
    payeeId: raw.payee_id,
    categoryId: raw.category_id,
    transferAccountId: raw.transfer_account_id,
    deleted: raw.deleted,
  }));

export const scheduledTransactionSchema = z
  .object({
    id: z.string(),
    date_first: isoDate,
    date_next: isoDate,
    frequency: z.string(),
    amount,
    memo: optionalText,
    flag_color: flagColor,
    flag_name: optionalText,
    account_id: z.string(),
    account_name: z.string(),
    payee_id: optionalId,
    payee_name: optionalText,
    category_id: optionalId,
    category_name: optionalText,
    transfer_account_id: optionalId,
    deleted,
    subtransactions: z.array(scheduledSubtransactionSchema).default([]),
  })
  .transform((raw) => ({
    id: raw.id,
    dateFirst: raw.date_first,
    dateNext: raw.date_next,
    frequency: raw.frequency,
    amount: raw.amount,
    memo: raw.memo,
    flagColor: raw.flag_color,
    flagName: raw.flag_name,
    accountId: raw.account_id,
    accountName: raw.account_name,
    payeeId: raw.payee_id,
    payeeName: raw.payee_name,
    categoryId: raw.category_id,
    categoryName: raw.category_name,
    transferAccountId: raw.transfer_account_id,
    deleted: raw.deleted,
    subtransactions: raw.subtransactions,
  }));

export const scheduledTransactionsResponseSchema = response(
  z.object({
    scheduled_transactions: z.array(scheduledTransactionSchema),
    server_knowledge: serverKnowledge,
  }),
);

export type ScheduledTransaction = z.output<typeof scheduledTransactionSchema>;
export type ScheduledSubtransaction = z.output<typeof scheduledSubtransactionSchema>;
