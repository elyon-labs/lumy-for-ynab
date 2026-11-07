import { Spacing } from '@lumy/theme';
import { Card, EmptyState, ListRow, Screen, SectionHeader, Skeleton, Text } from '@lumy/ui';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ScrollView, StyleSheet, View } from 'react-native';

import { ErrorScreen } from '@/navigation';
import { useSelectedBudget } from '@/settings';

import { byMostRecentlyUsed, useBudgets } from './queries';

/**
 * Choosing the budget everything else is about.
 *
 * The Flutter app put this inside the Budget tab, so the shell rendered with
 * no budget and every screen in it had to tolerate that. Here it is a step
 * before the shell, which is what lets `useBudgetId` throw instead of
 * returning null.
 */
export function SelectBudgetScreen() {
  const { t } = useTranslation();
  const budgets = useBudgets();
  const { selectBudget } = useSelectedBudget();
  const [choosing, setChoosing] = useState<string | null>(null);

  if (budgets.isError) {
    return (
      <ErrorScreen
        title={t('budgets.selectTitle')}
        message={t('budgets.loadFailed')}
        detail={budgets.error.message}
        onRetry={() => void budgets.refetch()}
      />
    );
  }

  return (
    <Screen title={t('budgets.selectTitle')}>
      <ScrollView contentContainerStyle={styles.body}>
        <Card>
          <Text tone="muted">{t('budgets.selectExplainer')}</Text>
        </Card>

        {budgets.isPending ? <LoadingRows /> : null}

        {budgets.data !== undefined && budgets.data.length === 0 ? (
          <EmptyState
            icon="wallet-outline"
            title={t('budgets.emptyTitle')}
            message={t('budgets.emptyMessage')}
            actionLabel={t('common.retry')}
            onAction={() => void budgets.refetch()}
          />
        ) : null}

        {budgets.data !== undefined && budgets.data.length > 0 ? (
          <>
            <SectionHeader title={t('budgets.selectTitle')} />
            <Card flush>
              {byMostRecentlyUsed(budgets.data).map((budget) => (
                <ListRow
                  key={budget.id}
                  title={budget.name}
                  subtitle={budget.currencyFormat?.isoCode}
                  chevron
                  // Writing the setting is what flips the redirect chain to the
                  // shell, so there is nothing to navigate to afterwards.
                  onPress={() => {
                    setChoosing(budget.id);
                    void selectBudget(budget.id).catch(() => setChoosing(null));
                  }}
                  disabled={choosing !== null}
                />
              ))}
            </Card>
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
