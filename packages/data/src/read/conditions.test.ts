import { describe, expect, it } from 'vitest';

import { compileCondition, conditionForFilter, type LedgerCondition } from './conditions';

describe('the condition compiler', () => {
  function sql(condition: LedgerCondition): string {
    return compileCondition(condition).sql;
  }

  function params(condition: LedgerCondition): readonly unknown[] {
    return compileCondition(condition).params;
  }

  describe('the leaf tests', () => {
    it.each([
      [{ test: 'hasAccountId', ids: ['a'] }, 'account_id IN (?)', ['a']],
      [
        { test: 'hasAccountId', ids: ['a', 'b'] },
        'account_id IN (?, ?)',
        ['a', 'b'],
      ],
      [
        { test: 'hasPayeeId', ids: ['p'] },
        'COALESCE(payee_id IN (?), 0)',
        ['p'],
      ],
      [{ test: 'hasPayeeId', ids: [null] }, 'payee_id IS NULL', []],
      [
        { test: 'hasCategoryId', ids: ['c', null] },
        'COALESCE((category_id IN (?) OR category_id IS NULL), 0)',
        ['c'],
      ],
      [
        { test: 'hasCategoryGroupId', ids: ['g'] },
        'COALESCE(category_group_id IN (?), 0)',
        ['g'],
      ],
      [
        { test: 'hasFlagColor', colors: ['red'] },
        'COALESCE(flag_color IN (?), 0)',
        ['red'],
      ],
      [
        { test: 'hasMemoKeyword', keyword: 'rent' },
        "COALESCE(memo LIKE ? ESCAPE '\\', 0)",
        ['%rent%'],
      ],
      [{ test: 'isIncome' }, 'is_income = 1', []],
      [{ test: 'isExpense' }, 'is_expense = 1', []],
      [{ test: 'isInflow' }, 'amount > 0', []],
      [{ test: 'isOutflow' }, 'amount < 0', []],
      [{ test: 'isTransfer' }, 'is_transfer = 1', []],
      [{ test: 'isStartingBalance' }, 'is_starting_balance = 1', []],
      [{ test: 'dateRange', from: '2026-01-01' }, 'date >= ?', ['2026-01-01']],
      [{ test: 'dateRange', to: '2026-12-31' }, 'date <= ?', ['2026-12-31']],
      [
        { test: 'dateRange', from: '2026-01-01', to: '2026-12-31' },
        '(date >= ? AND date <= ?)',
        ['2026-01-01', '2026-12-31'],
      ],
    ] satisfies [LedgerCondition, string, unknown[]][])(
      'compiles %o',
      (condition, expected, expectedParams) => {
        expect(sql(condition)).toBe(expected);
        expect(params(condition)).toEqual(expectedParams);
      },
    );
  });

  describe('composition', () => {
    it('ands a list', () => {
      expect(
        sql({ test: 'all', of: [{ test: 'isExpense' }, { test: 'isOutflow' }] }),
      ).toBe('(is_expense = 1 AND amount < 0)');
    });

    it('ors a list', () => {
      expect(sql({ test: 'any', of: [{ test: 'isIncome' }, { test: 'isInflow' }] })).toBe(
        '(is_income = 1 OR amount > 0)',
      );
    });

    it('nests to any depth, keeping the parameters in the order they appear', () => {
      const condition: LedgerCondition = {
        test: 'all',
        of: [
          { test: 'dateRange', from: '2026-01-01' },
          {
            test: 'any',
            of: [
              { test: 'hasCategoryId', ids: ['food'] },
              { test: 'not', of: { test: 'hasMemoKeyword', keyword: 'refund' } },
            ],
          },
        ],
      };

      expect(sql(condition)).toBe(
        "(date >= ? AND (COALESCE(category_id IN (?), 0) OR NOT COALESCE(memo LIKE ? ESCAPE '\\', 0)))",
      );
      expect(params(condition)).toEqual(['2026-01-01', 'food', '%refund%']);
    });

    it('drops a pointless wrapper rather than parenthesising one branch', () => {
      expect(sql({ test: 'all', of: [{ test: 'isExpense' }] })).toBe('is_expense = 1');
    });
  });

  describe('the empty cases', () => {
    it('matches everything for an empty `all`, which is what no filter means', () => {
      expect(sql({ test: 'all', of: [] })).toBe('1');
    });

    it('matches nothing for an empty `any`, which is what nothing chosen means', () => {
      expect(sql({ test: 'any', of: [] })).toBe('0');
    });

    it('matches nothing for an empty id list', () => {
      expect(sql({ test: 'hasAccountId', ids: [] })).toBe('0');
      expect(sql({ test: 'hasFlagColor', colors: [] })).toBe('0');
    });

    it('matches everything for a date range with neither end', () => {
      expect(sql({ test: 'dateRange' })).toBe('1');
    });
  });

  describe('a memo keyword', () => {
    it('is bound, never interpolated', () => {
      const compiled = compileCondition({
        test: 'hasMemoKeyword',
        keyword: "'; DROP TABLE ledger_entries; --",
      });

      expect(compiled.sql).not.toContain('DROP');
      // The underscore is escaped because `LIKE` reads it as a wildcard, which
      // is the only thing that happens to any of it.
      expect(compiled.params).toEqual(["%'; DROP TABLE ledger\\_entries; --%"]);
    });

    it('escapes the wildcards, so a literal % is a literal %', () => {
      expect(params({ test: 'hasMemoKeyword', keyword: '50%_off' })).toEqual([
        '%50\\%\\_off%',
      ]);
    });

    it('escapes the escape character itself', () => {
      expect(params({ test: 'hasMemoKeyword', keyword: 'a\\b' })).toEqual(['%a\\\\b%']);
    });
  });

  describe('a filter', () => {
    it('becomes an `all` of the fields it carries', () => {
      expect(
        conditionForFilter({ from: '2026-01-01', accountIds: ['checking'] }),
      ).toEqual({
        test: 'all',
        of: [
          { test: 'dateRange', from: '2026-01-01', to: undefined },
          { test: 'hasAccountId', ids: ['checking'] },
        ],
      });
    });

    it('is an empty `all` when it carries nothing, so it filters nothing', () => {
      expect(sql(conditionForFilter({}))).toBe('1');
    });

    it('reads its classifications as any of them', () => {
      expect(sql(conditionForFilter({ classifications: ['income', 'inflow'] }))).toBe(
        '(is_income = 1 OR amount > 0)',
      );
    });

    it('distinguishes an empty choice from an absent one', () => {
      expect(sql(conditionForFilter({ accountIds: [] }))).toBe('0');
      expect(sql(conditionForFilter({}))).toBe('1');
    });
  });
});
