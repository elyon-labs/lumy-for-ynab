import { z } from 'zod';

import { deleted, optionalId, response, serverKnowledge } from './common';

export const payeeSchema = z
  .object({
    id: z.string(),
    name: z.string(),
    transfer_account_id: optionalId,
    deleted,
  })
  .transform((raw) => ({
    id: raw.id,
    name: raw.name,
    transferAccountId: raw.transfer_account_id,
    deleted: raw.deleted,
  }));

export const payeesResponseSchema = response(
  z.object({ payees: z.array(payeeSchema), server_knowledge: serverKnowledge }),
);

export type Payee = z.output<typeof payeeSchema>;
