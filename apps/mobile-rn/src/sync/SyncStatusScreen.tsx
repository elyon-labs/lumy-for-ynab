import { Spacing } from '@lumy/theme';
import {
  Button,
  Card,
  Dialog,
  Divider,
  ListRow,
  ProgressBar,
  Screen,
  SectionHeader,
  Skeleton,
  Text,
} from '@lumy/ui';
import { router, useLocalSearchParams } from 'expo-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { RefreshControl, ScrollView, StyleSheet } from 'react-native';

import { LastFetchText } from './LastFetchText';
import { useDeleteAllSyncedData, useRefresh, useRepairBudget, useSyncStatus } from './queries';
import { useSyncProgress } from './SyncProvider';

/**
 * What Lumy has fetched, and the three things that can be done about it.
 *
 * Reached from the Settings tab, and also by a confirmed email change — the
 * allow-listed Supabase redirect is
 * `com.brandontrautmann.lumy://settings/sync-status?email-change-confirmed=true`,
 * so this screen is where that link lands and `email-change-confirmed` is what
 * it says when it does. The URL cannot be changed from code: it is configured
 * in the Supabase project, and a path this screen did not answer to would come
 * back as an error.
 *
 * Nothing here invalidates a query. Every action writes to the database and
 * the one subscriber does the rest, so the figures below re-read themselves.
 */
export function SyncStatusScreen() {
  const { t } = useTranslation();
  const status = useSyncStatus();
  const progress = useSyncProgress();
  const refresh = useRefresh();
  const repair = useRepairBudget();
  const deleteAll = useDeleteAllSyncedData();
  const params = useLocalSearchParams<{ 'email-change-confirmed'?: string }>();
  const [confirming, setConfirming] = useState<'none' | 'repair' | 'delete'>('none');

  const syncing = progress.status === 'running';
  const busy = syncing || deleteAll.isPending;

  return (
    <Screen title={t('sync.statusTitle')} dismiss="back" onDismiss={() => router.back()}>
      <ScrollView
        contentContainerStyle={styles.body}
        refreshControl={
          <RefreshControl refreshing={refresh.isRefreshing} onRefresh={refresh.refresh} />
        }
      >
        {params['email-change-confirmed'] === 'true' ? (
          <Card>
            <Text tone="positive">{t('sync.emailChangeConfirmed')}</Text>
          </Card>
        ) : null}

        <Card>
          {status.data === undefined ? (
            <Skeleton height={20} width="60%" />
          ) : (
            <LastFetchText syncedAt={status.data.lastFetchedAt} />
          )}
          {syncing ? (
            <ProgressBar
              progress={progress.fraction}
              accessibilityLabel={t('sync.progressLabel')}
            />
          ) : null}
        </Card>

        <Button
          label={t('sync.syncNow')}
          onPress={refresh.refresh}
          loading={syncing}
          disabled={busy}
        />

        <SectionHeader title={t('sync.resourcesTitle')} />
        <Card flush>
          {status.data?.resources.map((resource) => (
            <ListRow
              key={resource.resource}
              title={t(`sync.resources.${resource.resource}`)}
              accessory={<LastFetchText syncedAt={resource.syncedAt} variant="caption" tone="muted" />}
            />
          ))}

          {status.data !== undefined && status.data.monthDetail.months > 0 ? (
            <>
              <Divider />
              {/* One row for all of it, because this resource has a knowledge
                  row per month and listing them would grow with the budget's
                  history rather than with its structure. */}
              <ListRow
                title={t('sync.monthDetail')}
                subtitle={t('sync.monthDetailCount', { count: status.data.monthDetail.months })}
                accessory={
                  <LastFetchText
                    syncedAt={status.data.monthDetail.syncedAt}
                    variant="caption"
                    tone="muted"
                  />
                }
              />
            </>
          ) : null}
        </Card>

        <SectionHeader title={t('sync.maintenanceTitle')} />
        <Card flush>
          <ListRow
            title={t('sync.repair')}
            subtitle={t('sync.repairExplainer')}
            onPress={() => setConfirming('repair')}
            disabled={busy}
            chevron
          />
          <ListRow
            title={t('sync.deleteAll')}
            subtitle={t('sync.deleteAllExplainer')}
            onPress={() => setConfirming('delete')}
            disabled={busy}
            destructive
            chevron
          />
        </Card>
      </ScrollView>

      {confirming === 'repair' ? (
        <Dialog
          title={t('sync.repairConfirmTitle')}
          message={t('sync.repairConfirmMessage')}
          confirmLabel={t('sync.repair')}
          cancelLabel={t('common.cancel')}
          confirming={syncing}
          onConfirm={() => {
            setConfirming('none');
            repair.mutate();
          }}
          onCancel={() => setConfirming('none')}
        />
      ) : null}

      {confirming === 'delete' ? (
        <Dialog
          title={t('sync.deleteAllConfirmTitle')}
          message={t('sync.deleteAllConfirmMessage')}
          confirmLabel={t('sync.deleteAll')}
          cancelLabel={t('common.cancel')}
          destructive
          confirming={deleteAll.isPending}
          onConfirm={() => {
            setConfirming('none');
            // Nothing to navigate afterwards: with no knowledge rows left the
            // redirect chain's fifth condition answers false and the first-run
            // sync screen is where the shell sends everyone.
            deleteAll.mutate();
          }}
          onCancel={() => setConfirming('none')}
        />
      ) : null}
    </Screen>
  );
}

const styles = StyleSheet.create({
  body: { paddingHorizontal: Spacing.edge, paddingBottom: Spacing.loose, gap: Spacing.snug },
});
