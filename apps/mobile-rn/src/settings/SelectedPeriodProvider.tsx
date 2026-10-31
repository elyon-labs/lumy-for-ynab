import { Settings, resolvePeriod, type DateRange, type Period } from '@lumy/data';
import { createContext, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';

import { millisecondsUntilTomorrow, today } from './today';
import { useSetting } from './useSetting';

/**
 * The period every report is read through, and the dates it means today.
 *
 * The stored value is the choice — "this month", "latest 6 months" — and the
 * range is what resolving it against today produces. Screens take the range,
 * because that is what a query needs; the picker takes the period, because
 * that is what the person chose.
 */

export interface SelectedPeriod {
  period: Period;
  /** What `period` covers today, inclusive on both ends. */
  range: DateRange;
  /** False until the stored choice has been read. */
  isLoaded: boolean;
  setPeriod: (period: Period) => Promise<void>;
}

const SelectedPeriodContext = createContext<SelectedPeriod | null>(null);

/**
 * The current date, re-read when it changes.
 *
 * Every period but last month and last year ends at today, so the resolved
 * range is wrong from midnight until something re-renders. One timer to the
 * next midnight fixes that; the Flutter app used a pulse every minute, which
 * recomputed the whole period 1,439 times a day to catch the once it moved.
 */
function useToday(): string {
  const [date, setDate] = useState(() => today());

  useEffect(() => {
    const timer = setTimeout(() => setDate(today()), millisecondsUntilTomorrow());

    return () => clearTimeout(timer);
    // Scheduling the next midnight is what the last one leads to, so the
    // effect re-runs on the date it just set.
  }, [date]);

  return date;
}

export function SelectedPeriodProvider({ children }: { children: ReactNode }) {
  const { value: period, isLoaded, setValue: setPeriod } = useSetting(Settings.selectedPeriod);
  const date = useToday();

  const selected = useMemo<SelectedPeriod>(
    () => ({ period, range: resolvePeriod(period, date), isLoaded, setPeriod }),
    [period, date, isLoaded, setPeriod],
  );

  return (
    <SelectedPeriodContext.Provider value={selected}>{children}</SelectedPeriodContext.Provider>
  );
}

export function useSelectedPeriod(): SelectedPeriod {
  const value = useContext(SelectedPeriodContext);
  if (!value) {
    throw new Error('useSelectedPeriod must be called inside a SelectedPeriodProvider.');
  }

  return value;
}
