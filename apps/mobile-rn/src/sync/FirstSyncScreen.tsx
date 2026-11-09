import { FontSize, Spacing } from '@lumy/theme';
import { Button, Card, Icon, ProgressBar, Screen, Text } from '@lumy/ui';
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { ScrollView, StyleSheet, View } from 'react-native';

import { useSignOut } from '@/auth';
import { useSelectedBudget } from '@/settings';

import { useSyncProgress } from './SyncProvider';
import { useRepairBudget, useSyncBudget } from './queries';

/**
 * The first sync of a budget, which gates the shell.
 *
 * The redirect chain's fifth condition sends someone here and takes them off
 * it: the last resource's commit advances `server_knowledge`, the adapter
 * announces it, `hasSyncedData` re-reads, and the chain answers `app`. There
 * is no navigation in this screen and no success handler — the same way the
 * connect-YNAB screen has none.
 *
 * What it does have is the way out. A gate that only offered "try again" would
 * lock someone out of Settings over a revoked YNAB grant or a budget the token
 * has lost access to, so repairing, choosing another budget, and signing out
 * are all reachable from here. Nothing below the gate has to tolerate a budget
 * with nothing in it, and nobody is stranded in front of it.
 */
export function FirstSyncScreen() {
  const { t } = useTranslation();
  const progress = useSyncProgress();
  const sync = useSyncBudget();
  // Destructured because it is the dependency: `mutate` is stable, where the
  // mutation object is a new one on every state change — depending on that
  // would start a second sync the moment the first reported anything.
  const { mutate: startSync } = sync;
  const repair = useRepairBudget();
  const { selectBudget } = useSelectedBudget();
  const signOut = useSignOut();

  // Started on arrival, because this screen is the sync. `mutate` is stable,
  // so a re-render while it runs does not start a second one.
  useEffect(() => {
    startSync();
  }, [startSync]);

  if (progress.status === 'failed') {
    return (
      <Screen title={t('sync.firstRunTitle')}>
        <ScrollView contentContainerStyle={styles.body}>
          <View style={styles.hero}>
            <Icon name="warning-outline" tone="negative" size={FontSize.display} />
            <Text variant="heading" weight="semibold" style={styles.centered}>
              {t('sync.failedTitle')}
            </Text>
            <Text tone="muted" style={styles.centered}>
              {t('sync.failedMessage')}
            </Text>
            {progress.error !== null ? (
              <Text variant="caption" tone="faint" style={styles.centered}>
                {progress.error.message}
              </Text>
            ) : null}
          </View>

          <Button label={t('common.retry')} onPress={() => startSync()} />

          {/* The three ways out, in the order someone would try them: ask for
              the budget again from scratch, pick a different one, or leave. */}
          <Button
            label={t('sync.repair')}
            variant="secondary"
            onPress={() => repair.mutate()}
          />
          <Button
            label={t('settings.changeBudget')}
            variant="secondary"
            onPress={() => void selectBudget(null)}
          />
          <Button
            label={t('auth.account.signOut')}
            variant="ghost"
            disabled={signOut.isPending}
            onPress={() => signOut.mutate()}
          />
        </ScrollView>
      </Screen>
    );
  }

  return (
    <Screen title={t('sync.firstRunTitle')}>
      <ScrollView contentContainerStyle={styles.body}>
        <View style={styles.hero}>
          <Icon name="cloud-download-outline" tone="primary" size={FontSize.display} />
          <Text variant="heading" weight="semibold" style={styles.centered}>
            {t('sync.firstRunHeading')}
          </Text>
          <Text tone="muted" style={styles.centered}>
            {t('sync.firstRunExplainer')}
          </Text>
        </View>

        <Card>
          <ProgressBar
            progress={progress.fraction}
            accessibilityLabel={t('sync.progressLabel')}
          />
          <Text variant="caption" tone="muted">
            {progress.resource === null
              ? t('sync.starting')
              : t(`sync.resources.${progress.resource}`)}
          </Text>
        </Card>

        {/* Reachable while the sync runs rather than only after it fails. A
            first sync of a long-lived budget takes minutes, and someone who
            picked the wrong budget should not have to wait it out. Leaving
            mid-sync is safe: every chunk has already committed, and the pages
            still arriving are upserts by id. */}
        <Button
          label={t('settings.changeBudget')}
          variant="ghost"
          onPress={() => void selectBudget(null)}
        />
      </ScrollView>
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: {
    flexGrow: 1,
    justifyContent: 'center',
    paddingHorizontal: Spacing.edge,
    paddingBottom: Spacing.loose,
    gap: Spacing.snug,
  },
  hero: { alignItems: 'center', gap: Spacing.snug, paddingBottom: Spacing.loose },
  centered: { textAlign: 'center' },
});
