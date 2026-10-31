import { z } from 'zod';

import { response } from './common';

/**
 * Who the token belongs to.
 *
 * The only field YNAB returns is the id, and the only thing the app does with
 * it is pair the YNAB account with the Supabase one in the `users` table — so
 * the same person signing in on another device is recognised as themselves.
 */
export const userSchema = z.object({ id: z.string() });

export const userResponseSchema = response(z.object({ user: userSchema }));

export type YnabUser = z.output<typeof userSchema>;
