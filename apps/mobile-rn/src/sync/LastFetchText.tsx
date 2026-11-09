import { Text, type TextProps } from '@lumy/ui';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { now } from '@/settings';

import { describeLastFetch, type LastFetchDescription } from './lastFetch';

/**
 * How long ago a fetch was, in words.
 *
 * The one place the catalog keys for those words are chosen, so the headline
 * and the per-resource rows cannot drift apart. Which band an instant falls in
 * is `describeLastFetch`, which is pure and tested; this maps the band to a
 * string.
 */

/** How often the elapsed time is recomputed while the text is on screen. */
const TICK_MS = 30_000;

export interface LastFetchTextProps extends Pick<TextProps, 'variant' | 'tone'> {
  /** The instant as `server_knowledge.synced_at` recorded it. */
  syncedAt: string | null;
}

export function LastFetchText({ syncedAt, ...text }: LastFetchTextProps) {
  const { t } = useTranslation();
  const [at, setAt] = useState(now);

  // Re-read the clock rather than the row: the row has not changed, the
  // distance from it has. Without this, "2 minutes ago" is what the screen
  // says for as long as it is open.
  useEffect(() => {
    const timer = setInterval(() => setAt(now()), TICK_MS);

    return () => clearInterval(timer);
  }, []);

  return <Text {...text}>{lastFetchLabel(describeLastFetch(syncedAt, at), t)}</Text>;
}

type Translate = ReturnType<typeof useTranslation>['t'];

function lastFetchLabel(description: LastFetchDescription, t: Translate): string {
  switch (description.kind) {
    case 'never':
      return t('sync.lastFetch.never');
    case 'unknown':
      return t('sync.lastFetch.unknown');
    case 'justNow':
      return t('sync.lastFetch.justNow');
    case 'minutes':
      return t('sync.lastFetch.minutes', { count: description.value });
    case 'hours':
      return t('sync.lastFetch.hours', { count: description.value });
    case 'days':
      return t('sync.lastFetch.days', { count: description.value });
  }
}
