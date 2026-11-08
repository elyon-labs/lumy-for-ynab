import { Spacing } from '@lumy/theme';
import { Card, EmptyState, ListRow, Screen, SectionHeader, Skeleton, Text } from '@lumy/ui';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ScrollView, StyleSheet, View } from 'react-native';

import { ErrorScreen } from '@/navigation';
import { useSelectedBudget } from '@/settings';

import { budgetPickerState } from './pickerState';
import { useBudgets, useRefreshBudgets } from './queries';

/**
 * Choosing the budget everything else is about.
 *
 * The Flutter app put this inside the Budget tab, so the shell rendered with
 * no budget and every screen in it had to tolerate that. Here it is a step
 * before the shell, which is what lets `useBudgetId` throw instead of
 * returning null.
 *
 * The list comes from the `budgets` table and the refresh writes it, so a
 * second visit renders from what is stored while YNAB is being asked again.
 * Which of those to show is `budgetPickerState`.
 */
export function SelectBudgetScreen() {
  const { t } = useTranslation();
  const budgets = useBudgets();
  const refresh = useRefreshBudgets();
  // Destructured because it is the dependency: `mutate` is stable, where the
  // mutation object is a new one on every state change — depending on that
  // would re-fetch the list each time the fetch's own status moved.
  const { mutate: fetchBudgets } = refresh;
  const { selectBudget } = useSelectedBudget();
  const [choosing, setChoosing] = useState<string | null>(null);

  // Fetched on arrival rather than on a button, because the list is what the
  // screen is for. `mutate` is stable, so this runs once per visit.
  useEffect(() => {
    fetchBudgets();
  }, [fetchBudgets]);

  const state = budgetPickerState({
    stored: budgets.data,
    fetch: refresh.status,
    error: refresh.error,
  });

  if (state.kind === 'failed') {
    return (
      <ErrorScreen
        title={t('budgets.selectTitle')}
        message={t('budgets.loadFailed')}
        detail={state.error?.message}
        onRetry={() => fetchBudgets()}
      />
    );
  }

  return (
    <Screen title={t('budgets.selectTitle')}>
      <ScrollView contentContainerStyle={styles.body}>
        <Card>
          <Text tone="muted">{t('budgets.selectExplainer')}</Text>
        </Card>

        {state.kind === 'loading' ? <LoadingRows /> : null}

        {state.kind === 'empty' ? (
          <EmptyState
            icon="wallet-outline"
            title={t('budgets.emptyTitle')}
            message={t('budgets.emptyMessage')}
            actionLabel={t('common.retry')}
            onAction={() => fetchBudgets()}
          />
        ) : null}

        {state.kind === 'list' ? (
          <>
            <SectionHeader title={t('budgets.selectTitle')} />
            <Card flush>
              {state.budgets.map((budget) => (
                <ListRow
                  key={budget.id}
                  title={budget.name}
                  subtitle={budget.isoCode ?? undefined}
                  chevron
                  // Writing the setting is what flips the redirect chain to the
                  // first sync, so there is nothing to navigate to afterwards.
                  onPress={() => {
                    setChoosing(budget.id);
                    void selectBudget(budget.id).catch(() => setChoosing(null));
                  }}
                  disabled={choosing !== null}
                />
              ))}
            </Card>

            {state.refreshError !== null ? (
              <Text variant="caption" tone="negative">
                {t('budgets.refreshFailed')}
              </Text>
            ) : null}
          </>
        ) : null}
      </ScrollView>
    </Screen>
  );
}

function LoadingRows() {
  return (
    <View style={styles.loading}>
      <Skeleton height={56} />
      <Skeleton height={56} />
      <Skeleton height={56} />
    </View>
  );
}

const styles = StyleSheet.create({
  body: { paddingHorizontal: Spacing.edge, paddingBottom: Spacing.loose, gap: Spacing.snug },
  loading: { gap: Spacing.tight },
});
