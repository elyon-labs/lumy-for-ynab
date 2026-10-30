import { z } from 'zod';

import { amount, deleted, isoMonth, optionalText, response, serverKnowledge } from './common';

/**
 * A category, with the figures for whichever month the request was scoped to.
 *
 * `budgeted`, `activity`, and `balance` belong to that month, not to the
 * category, which is why they land in `category_months` rather than on the
 * category row. YNAB still calls the target fields goals on the wire; they
 * keep the product's name here.
 */
export const categorySchema = z
  .object({
    id: z.string(),
    category_group_id: z.string(),
    name: z.string(),
    hidden: z.boolean(),
    deleted,
    budgeted: amount,
    activity: amount,
    balance: amount,
    goal_type: optionalText,
    goal_needs_whole_amount: z.boolean().nullish(),
    goal_day: z.number().int().nullish(),
    goal_cadence: z.number().int().nullish(),
    goal_cadence_frequency: z.number().int().nullish(),
    goal_creation_month: isoMonth.nullish(),
    goal_target: amount.nullish(),
    goal_target_month: isoMonth.nullish(),
    goal_percentage_complete: z.number().int().nullish(),
    goal_months_to_budget: z.number().int().nullish(),
    goal_under_funded: amount.nullish(),
    goal_overall_funded: amount.nullish(),
    goal_overall_left: amount.nullish(),
  })
  .transform((raw) => ({
    id: raw.id,
    categoryGroupId: raw.category_group_id,
    name: raw.name,
    hidden: raw.hidden,
    deleted: raw.deleted,
    budgeted: raw.budgeted,
    activity: raw.activity,
    balance: raw.balance,
    target: {
      type: raw.goal_type,
      needsWholeAmount: raw.goal_needs_whole_amount ?? null,
      day: raw.goal_day ?? null,
      cadence: raw.goal_cadence ?? null,
      cadenceFrequency: raw.goal_cadence_frequency ?? null,
      creationMonth: raw.goal_creation_month ?? null,
      balance: raw.goal_target ?? null,
      month: raw.goal_target_month ?? null,
      percentageComplete: raw.goal_percentage_complete ?? null,
      monthsToBudget: raw.goal_months_to_budget ?? null,
      underFunded: raw.goal_under_funded ?? null,
      overallFunded: raw.goal_overall_funded ?? null,
      overallLeft: raw.goal_overall_left ?? null,
    },
  }));

export const categoryGroupSchema = z
  .object({
    id: z.string(),
    name: z.string(),
    hidden: z.boolean(),
    deleted,
    categories: z.array(categorySchema),
  })
  .transform((raw) => ({
    id: raw.id,
    name: raw.name,
    hidden: raw.hidden,
    deleted: raw.deleted,
    categories: raw.categories,
  }));

/**
 * The categories response.
 *
 * Groups and their categories arrive nested, and the nesting is also the only
 * statement YNAB makes about their order — it sends no sort field — so the
 * array position is the ordering and has to be captured as the page is
 * written.
 */
export const categoriesResponseSchema = response(
  z.object({
    category_groups: z.array(categoryGroupSchema),
    server_knowledge: serverKnowledge,
  }),
);

export type Category = z.output<typeof categorySchema>;
export type CategoryGroup = z.output<typeof categoryGroupSchema>;
