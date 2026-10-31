/**
 * The period every report is read through.
 *
 * A period is what the person chose — "this month", "latest 6 months" — and a
 * date range is what that means today. Keeping the choice rather than the
 * range is what lets "this month" still mean this month tomorrow, and it is
 * why the stored setting is a period and the thing a query takes is a range.
 *
 * Resolution is a pure function of the period and the day it is resolved on.
 * Nothing here reads a clock: the caller says what today is, so a test can
 * state a date and the background sync task can resolve a period without a
 * timezone being involved. Dates are `YYYY-MM-DD` throughout, as everywhere
 * else in this engine, which keeps the whole of `time_machine`,
 * `LocalDate`, and `DateTime` out of the question the Flutter app mixed them
 * to answer.
 */

/** Inclusive on both ends, in `YYYY-MM-DD`. */
export interface DateRange {
  readonly from: string;
  readonly to: string;
}

export type PeriodType =
  | 'thisMonth'
  | 'lastMonth'
  | 'last3Months'
  | 'last6Months'
  | 'last12Months'
  | 'thisYear'
  | 'lastYear'
  | 'custom';

export const PERIOD_TYPES: readonly PeriodType[] = [
  'thisMonth',
  'lastMonth',
  'last3Months',
  'last6Months',
  'last12Months',
  'thisYear',
  'lastYear',
  'custom',
];

/**
 * A chosen period, carrying its own range when it has one.
 *
 * One value rather than the Flutter app's pair — a global `chosen_period_type`
 * beside a per-budget `selected_date_range_<budgetId>` — because the two can
 * disagree: a type of `custom` read with no range stored under the selected
 * budget silently became this month. A single union cannot be in that state.
 */
export type Period =
  | { readonly type: Exclude<PeriodType, 'custom'> }
  | { readonly type: 'custom'; readonly from: string; readonly to: string };

/** What a client that has never chosen a period reports. */
export const DEFAULT_PERIOD: Period = { type: 'thisMonth' };

interface YearMonthDay {
  year: number;
  month: number;
  day: number;
}

const DATE = /^(\d{4})-(\d{2})-(\d{2})$/;

export function isDate(value: unknown): value is string {
  return typeof value === 'string' && DATE.test(value);
}

function parse(date: string): YearMonthDay {
  const match = DATE.exec(date);
  if (match === null) throw new Error(`Not a YYYY-MM-DD date: ${date}`);

  return { year: Number(match[1]), month: Number(match[2]), day: Number(match[3]) };
}

function format({ year, month, day }: YearMonthDay): string {
  const pad = (value: number, width: number) => String(value).padStart(width, '0');

  return `${pad(year, 4)}-${pad(month, 2)}-${pad(day, 2)}`;
}

/** The length of a month, by the proleptic Gregorian rules SQLite also uses. */
function daysInMonth(year: number, month: number): number {
  if (month === 2) {
    const leap = (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;

    return leap ? 29 : 28;
  }

  return [4, 6, 9, 11].includes(month) ? 30 : 31;
}

export function firstDayOfMonth(date: string): string {
  return format({ ...parse(date), day: 1 });
}

export function lastDayOfMonth(date: string): string {
  const { year, month } = parse(date);

  return format({ year, month, day: daysInMonth(year, month) });
}

/**
 * Moves a date by whole months, keeping the day of the month where it fits.
 *
 * Every caller here passes the first of a month, so the clamp matters only to
 * a caller that does not.
 */
export function addMonths(date: string, months: number): string {
  const { year, month, day } = parse(date);
  const zeroBased = year * 12 + (month - 1) + months;
  const movedYear = Math.floor(zeroBased / 12);
  const movedMonth = (zeroBased % 12) + 1;

  return format({
    year: movedYear,
    month: movedMonth,
    day: Math.min(day, daysInMonth(movedYear, movedMonth)),
  });
}

function sameMonth(a: string, b: string): boolean {
  return a.slice(0, 7) === b.slice(0, 7);
}

/**
 * Makes a custom range whole months, and never later than today.
 *
 * A custom range is chosen a month at a time, so it starts on the first of its
 * first month and ends on the last of its last — except when that last month
 * is the one in progress, where the range ends today rather than at a date
 * that has not happened. Carried over from the Flutter app, which constrained
 * the stored range the same way on every read.
 */
export function constrainCustomRange(range: DateRange, today: string): DateRange {
  const from = firstDayOfMonth(range.from);
  const to = lastDayOfMonth(range.to);

  if (sameMonth(to, today) && to > today) return { from, to: today };

  return { from, to };
}

/** The dates a period covers on the day it is asked. */
export function resolvePeriod(period: Period, today: string): DateRange {
  const startOfThisMonth = firstDayOfMonth(today);
  const { year } = parse(today);

  switch (period.type) {
    case 'thisMonth':
      return { from: startOfThisMonth, to: today };
    case 'lastMonth': {
      const lastMonth = addMonths(startOfThisMonth, -1);

      return { from: lastMonth, to: lastDayOfMonth(lastMonth) };
    }
    case 'last3Months':
      return { from: addMonths(startOfThisMonth, -2), to: today };
    case 'last6Months':
      return { from: addMonths(startOfThisMonth, -5), to: today };
    case 'last12Months':
      return { from: addMonths(startOfThisMonth, -11), to: today };
    case 'thisYear':
      return { from: format({ year, month: 1, day: 1 }), to: today };
    case 'lastYear':
      return {
        from: format({ year: year - 1, month: 1, day: 1 }),
        to: format({ year: year - 1, month: 12, day: 31 }),
      };
    case 'custom':
      return constrainCustomRange(period, today);
  }
}
