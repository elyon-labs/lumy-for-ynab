import { z } from 'zod';

import { amount, deleted, isoMonth, optionalText, response, serverKnowledge } from './common';
import { categorySchema } from './categories';

const monthFields = {
  month: isoMonth,
  note: optionalText,
  income: amount,
  budgeted: amount,
  activity: amount,
  to_be_budgeted: amount,
  age_of_money: z.number().int().nullish(),
  deleted,
};

function toMonth(raw: {
  month: string;
  note: string | null;
  income: number;
  budgeted: number;
  activity: number;
  to_be_budgeted: number;
  age_of_money?: number | null;
  deleted: boolean;
}) {
  return {
    month: raw.month,
    note: raw.note,
    income: raw.income,
    budgeted: raw.budgeted,
    activity: raw.activity,
    toBeBudgeted: raw.to_be_budgeted,
    ageOfMoney: raw.age_of_money ?? null,
    deleted: raw.deleted,
  };
}

export const monthSchema = z.object(monthFields).transform(toMonth);

/**
 * One month with its categories.
 *
 * The month-scoped endpoint is the only place per-month category figures come
 * from — the categories endpoint reports whichever month is current — so this
 * is what fills `category_months` for any month the budget tab navigates to.
 */
export const singleMonthSchema = z
  .object({ ...monthFields, categories: z.array(categorySchema) })
  .transform((raw) => ({ ...toMonth(raw), categories: raw.categories }));

export const monthsResponseSchema = response(
  z.object({ months: z.array(monthSchema), server_knowledge: serverKnowledge }),
);

export const monthResponseSchema = response(z.object({ month: singleMonthSchema }));

export type Month = z.output<typeof monthSchema>;
export type SingleMonth = z.output<typeof singleMonthSchema>;
