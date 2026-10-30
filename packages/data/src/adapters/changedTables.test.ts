import { describe, expect, it } from 'vitest';

import { ChangedTables, writtenTable } from './changedTables';

describe('writtenTable', () => {
  it.each([
    ['INSERT INTO transactions (id) VALUES (?)', 'transactions'],
    ['insert or replace into payees (id) values (?)', 'payees'],
    ['REPLACE INTO accounts (id) VALUES (?)', 'accounts'],
    ['UPDATE categories SET name = ?', 'categories'],
    ['update or rollback months set budgeted = ?', 'months'],
    ['DELETE FROM subtransactions WHERE transaction_id = ?', 'subtransactions'],
    ['DROP TABLE IF EXISTS ledger_entries', 'ledger_entries'],
    ['CREATE TABLE IF NOT EXISTS budgets (id TEXT)', 'budgets'],
    ['ALTER TABLE accounts ADD COLUMN note TEXT', 'accounts'],
    ['  \n INSERT INTO "transactions" (id) VALUES (?)', 'transactions'],
    ['INSERT INTO main.transactions (id) VALUES (?)', 'transactions'],
  ])('reads the table out of %o', (sql, expected) => {
    expect(writtenTable(sql)).toBe(expected);
  });

  it.each([
    [
      'a statement that leads with a CTE, as the ledger derivation does',
      'WITH given(id) AS (VALUES (?)), scope(id) AS (SELECT id FROM given) DELETE FROM ledger_entries WHERE transaction_id IN (SELECT id FROM scope)',
      'ledger_entries',
    ],
    [
      'an insert fed by a CTE',
      'WITH leaves AS (SELECT id FROM transactions) INSERT INTO ledger_entries (entry_id) SELECT id FROM leaves',
      'ledger_entries',
    ],
    [
      'an upsert, whose DO UPDATE is not a second target',
      'INSERT INTO payees (id, name) VALUES (?, ?) ON CONFLICT (id) DO UPDATE SET name = excluded.name',
      'payees',
    ],
  ])('reports %s', (_description, sql, table) => {
    expect(writtenTable(sql)).toBe(table);
  });

  it.each([
    'SELECT * FROM transactions',
    'PRAGMA foreign_keys = ON',
    'CREATE INDEX idx_txn ON transactions (date)',
    'BEGIN IMMEDIATE',
  ])('reports no write for %o', (sql) => {
    expect(writtenTable(sql)).toBeNull();
  });
});

describe('ChangedTables', () => {
  it('collects each table once, sorted', () => {
    const changed = new ChangedTables();
    changed.record('INSERT INTO transactions (id) VALUES (?)');
    changed.record('INSERT INTO transactions (id) VALUES (?)');
    changed.record('DELETE FROM accounts');

    expect(changed.drain()).toEqual(['accounts', 'transactions']);
  });

  it('empties when drained, so a second commit does not repeat the first', () => {
    const changed = new ChangedTables();
    changed.record('UPDATE categories SET name = ?');

    expect(changed.drain()).toEqual(['categories']);
    expect(changed.drain()).toEqual([]);
  });
});
