import type { Migration } from './types';

/**
 * Every migration, in order.
 *
 * The schema itself arrives with the YNAB entity tables; this list exists
 * first so the runner that applies it, and the harness that tests against it,
 * are in place before there is anything to apply.
 */
export const MIGRATIONS: readonly Migration[] = [];

export type { Migration } from './types';
