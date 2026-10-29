/**
 * One forward step of the schema.
 *
 * Migrations are numbered from 1 with no gaps, and are never edited once
 * released: a database that has applied one cannot un-apply it, so changing
 * what it means changes what a device already did. Corrections arrive as the
 * next number.
 */
export interface Migration {
  readonly id: number;
  /** What it does, for the log and for anyone reading the list. */
  readonly name: string;
  readonly statements: readonly string[];
}
