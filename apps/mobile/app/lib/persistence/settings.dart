import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:disposebag/disposebag.dart' show DisposeBagConfigs;
import 'package:flutter/material.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';

import '../features/charts/all_charts.dart';
import '../features/charts/models/chart.dart';
import '../features/charts/models/chart_type.dart';
import '../features/date_range/domain/models/chosen_period.dart';
import '../features/date_range/domain/models/date_range.dart';
import '../features/recurring_transactions/recurring_transactions_screen/widgets/recurring_transactions_options_sheet.dart';
import '../features/spend_tracker/domain/models/spend_tracker_order.dart';
import '../features/templates/domain/models/legacy_transaction_template.dart';
import '../features/templates/domain/models/transaction_template.dart';
import '../utils/_date_time.dart';
import '../utils/_local_date.dart';

class Settings {
  Settings(SharedPreferences preferences) : _prefs = RxSharedPreferences(preferences) {
    DisposeBagConfigs.logger = null;
  }

  final RxSharedPreferences _prefs;

  Stream<Map<String, Object?>> watchAll() => _prefs.observeAll().shareValue();

  ValueStream<ThemeMode> watchThemeMode() {
    return _prefs.getStringStream('theme_mode').map((mode) {
      return mode == null
          ? ThemeMode
                .dark //
          : ThemeMode.values.byName(mode);
    }).shareValue();
  }

  void setThemeMode(ThemeMode mode) {
    unawaited(_prefs.setString('theme_mode', mode.name));
  }

  ValueStream<String?> watchLastWhatsNewVersion() {
    return _prefs.getStringStream('last_whats_new_version').shareValue();
  }

  void setLastWhatsNewVersion(String? version) {
    unawaited(_prefs.setString('last_whats_new_version', version));
  }

  ValueStream<Option<DateTime>> watchLastAppReviewRequest() {
    return _prefs.getIntStream('last_app_review_request').map((value) {
      return value == null
          ? const None<DateTime>()
          : Some(DateTime.fromMillisecondsSinceEpoch(value));
    }).shareValue();
  }

  void setLastAppReviewRequest(DateTime? value) {
    unawaited(_prefs.setInt('last_app_review_request', value?.millisecondsSinceEpoch));
  }

  ValueStream<DateTime> watchLastFetch() {
    return _prefs.getIntStream('last_fetch').map((value) {
      return value == null ? nowLocal : DateTime.fromMillisecondsSinceEpoch(value);
    }).shareValue();
  }

  void setLastFetch(DateTime value) {
    unawaited(_prefs.setInt('last_fetch', value.millisecondsSinceEpoch));
  }

  Future<bool> hasForcedFullTransactionRefetchForYnabSinceDateChange() async {
    return await _prefs
            .getBoolStream('forced_full_transaction_refetch_for_ynab_since_date_change')
            .first ??
        false;
  }

  Future<void> setHasForcedFullTransactionRefetchForYnabSinceDateChange() async {
    await _prefs.setBool('forced_full_transaction_refetch_for_ynab_since_date_change', true);
  }

  ValueStream<int> watchAppReviewEvents() {
    return _prefs.getIntStream('app_review_events').map((value) => value ?? 0).shareValue();
  }

  ValueStream<bool> watchHasOnboarded() {
    return _prefs.getBoolStream('has_onboarded').map((value) => value ?? false).shareValue();
  }

  void setHasOnboarded(bool value) {
    unawaited(_prefs.setBool('has_onboarded', value));
  }

  ValueStream<bool> watchHasEnabledSync() {
    return _prefs.getBoolStream('has_enabled_sync').map((value) => value ?? false).shareValue();
  }

  void setHasEnabledSync(bool value) {
    unawaited(_prefs.setBool('has_enabled_sync', value));
  }

  ValueStream<String?> watchYnabUserId() {
    return _prefs.getStringStream('user_id').shareValue();
  }

  Future<void> setYnabUserId(String id) async {
    await _prefs.setString('user_id', id);
  }

  ValueStream<String?> watchUserEmail() {
    return _prefs.getStringStream('user_email').shareValue();
  }

  void setUserEmail(String email) {
    unawaited(_prefs.setString('user_email', email));
  }

  // Budget specific settings
  ValueStream<Option<String>> watchSelectedBudgetId() {
    return _prefs.getStringStream('selected_budget_id').map(Option.from).shareValue();
  }

  void setSelectedBudgetId(String budgetId) {
    unawaited(_prefs.setString('selected_budget_id', budgetId));
  }

  ValueStream<Option<String>> watchReportsTabCategoryView() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs.getStringStream('reports_tab_category_view_2_$some').map(Option.from),
            None<String>() => Stream.value(const None<String>()),
          },
        )
        .shareValue();
  }

  Future<void> setReportsCategoryView(Option<String> view) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setString('reports_tab_category_view_2_$budgetId', view.mapOr((p0) => p0, null));
    });
  }

  ValueStream<bool> watchUseFrugalMonthLeftToSpend() {
    return _prefs
        .getBoolStream('use_frugal_month_left_to_spend')
        .map((value) => value ?? true)
        .shareValue();
  }

  void setUseFrugalMonthLeftToSpend(bool value) {
    unawaited(_prefs.setBool('use_frugal_month_left_to_spend', value));
  }

  ValueStream<Option<String>> watchBudgetTabCategoryView() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs.getStringStream('budget_tab_category_view_2_$some').map(Option.from),
            None<String>() => Stream.value(const None<String>()),
          },
        )
        .shareValue();
  }

  Future<void> setBudgetTabCategoryView(Option<String> view) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setString('budget_tab_category_view_2_$budgetId', view.mapOr((p0) => p0, null));
    });
  }

  // Chart & Report Settings
  Future<void> setSelectedDateRange(DateRange range) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setString('selected_date_range_$budgetId', range.toPreferencesString());
    });
  }

  ValueStream<List<Chart>> watchHiddenCharts() {
    return _prefs
        .getStringListStream('hidden_charts')
        .map((value) => value == null ? <Chart>[] : value.toCharts(allCharts))
        .shareValue();
  }

  void setHiddenCharts(List<Chart> charts) {
    unawaited(_prefs.setStringList('hidden_charts', charts.map((e) => e.id).toList()));
  }

  ValueStream<List<Chart>> watchSelectedCharts() {
    return Rx.combineLatest2(watchHiddenCharts(), _prefs.getStringListStream('selected_charts'), (
      hiddenIds,
      selectedIds,
    ) {
      final ids = selectedIds?.toList() ?? <String>[];
      final selected = allCharts.toSet().difference(hiddenIds.toSet()).toList();
      return selected.orderedWithPriority(ids).toList();
    }).shareValue();
  }

  void setSelectedCharts(List<Chart> charts) {
    unawaited(_prefs.setStringList('selected_charts', charts.toSet().map((e) => e.id).toList()));
  }

  Stream<Option<List<String>>> watchChartAccounts(Chart chart) {
    return watchSelectedBudgetId().switchMap((budgetId) async* {
      yield* switch (budgetId) {
        Some<String>(:final some) =>
          _prefs
              .getStringListStream('chart_accounts_${chart.id}_$some')
              .map((value) => value == null ? const None<List<String>>() : Some(value)),
        None<String>() => Stream.value(const None<List<String>>()),
      };
    }).shareValue();
  }

  Future<void> setChartAccounts(Chart chart, List<String> accounts) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setStringList('chart_accounts_${chart.id}_$budgetId', accounts);
    });
  }

  ValueStream<Option<ChartType>> watchSelectedChartType(Chart chart) {
    return _prefs
        .getStringStream('${chart.id}_chart_type')
        .map(
          (value) => value == null ? const None<ChartType>() : Some(ChartType.values.byName(value)),
        )
        .shareValue();
  }

  void setSelectedChartType(Chart chart, ChartType type) {
    unawaited(_prefs.setString('${chart.id}_chart_type', type.name));
  }

  ValueStream<Option<List<String>>> watchIncomeExpenseAccounts() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs
                  .getStringListStream('income_expense_accounts_$some')
                  .map((value) => value == null ? const None<List<String>>() : Some(value)),
            None<String>() => Stream.value(const None<List<String>>()),
          },
        )
        .shareValue();
  }

  Future<void> setIncomeExpenseAccounts(Option<List<String>> accounts) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setStringList('income_expense_accounts_$budgetId', switch (accounts) {
        Some<List<String>>(:final some) => some,
        None<List<String>>() => null,
      });
    });
  }

  ValueStream<Option<String>> watchIncomeExpenseCategoryView() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs.getStringStream('income_expense_category_view_2_$some').map(Option.from),
            None<String>() => Stream.value(const None<String>()),
          },
        )
        .shareValue();
  }

  Future<void> setIncomeExpenseCategoryView(Option<String> view) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setString(
        'income_expense_category_view_2_$budgetId',
        view.mapOr((p0) => p0, null),
      );
    });
  }

  ValueStream<Option<String>> watchMonthInReviewCategoryViewStream() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs.getStringStream('month_in_review_category_view_2_$some').map(Option.from),
            None<String>() => Stream.value(const None<String>()),
          },
        )
        .shareValue();
  }

  Future<void> setMonthInReviewCategoryView(Option<String> view) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setString(
        'month_in_review_category_view_2_$budgetId',
        view.mapOr((p0) => p0, null),
      );
    });
  }

  ValueStream<bool> watchShowTrendlines() {
    return _prefs.getBoolStream('show_trendlines').map((value) => value ?? true).shareValue();
  }

  void setShowTrendlines(bool value) {
    unawaited(_prefs.setBool('show_trendlines', value));
  }

  ValueStream<SpendTrackerOrderStrategy> watchSpendTrackersOrderStrategy() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs
                  .getStringStream('spend_tracker_order_strategy_$some')
                  .map(
                    (value) => value == null
                        ? SpendTrackerOrderStrategy
                              .manual //
                        : SpendTrackerOrderStrategy.values.byName(value),
                  ),
            None<String>() => Stream.value(SpendTrackerOrderStrategy.manual),
          },
        )
        .shareValue();
  }

  Future<void> setSpendTrackerOrderStrategy(SpendTrackerOrderStrategy strategy) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setString('spend_tracker_order_strategy_$budgetId', strategy.name);
    });
  }

  ValueStream<List<String>> watchSpendTrackersOrder() {
    return watchSelectedBudgetId()
        .switchMap(
          (value) => switch (value) {
            Some<String>(:final some) =>
              _prefs
                  .getStringListStream('spend_tracker_order_2_$some')
                  .map((value) => value ?? List<String>.empty()),
            None<String>() => Stream.value(List<String>.empty()),
          },
        )
        .shareValue();
  }

  Future<void> setSpendTrackerOrder(List<String> order) async {
    await runIfBudgetIsSelected((budgetId) async {
      await _prefs.setStringList('spend_tracker_order_2_$budgetId', order.toList());
    });
  }

  ValueStream<bool> watchHasSeenFrugalMonthsSplash() {
    return _prefs
        .getBoolStream('has_seen_frugal_splash')
        .map((value) => value ?? false)
        .shareValue();
  }

  void setHasSeenFrugalMonthsSplash(bool value) {
    unawaited(_prefs.setBool('has_seen_frugal_splash', value));
  }

  ValueStream<bool> watchFrugalMonthNotificationsEnabled() {
    return _prefs
        .getBoolStream('frugal_month_notifications_enabled')
        .map((value) => value ?? true)
        .shareValue();
  }

  Future<void> setFrugalMonthNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('frugal_month_notifications_enabled', enabled);
  }

  ValueStream<RecurringTransactionsSortType> watchRecurringTransactionsSortType() {
    return _prefs
        .getStringStream('recurring_transactions_sort_type')
        .map(
          (value) => value == null
              ? RecurringTransactionsSortType.amountDesc
              : RecurringTransactionsSortType.values.byName(value),
        )
        .shareValue();
  }

  void setRecurringTransactionsSortType(RecurringTransactionsSortType type) {
    unawaited(_prefs.setString('recurring_transactions_sort_type', type.name));
  }

  /// Streams the current [ChosenPeriod]. This is the period that all reporting conforms to.
  ///
  /// If you're only interested in the [DateRange] that the chosen period represents, use [watchSelectedDateRange].
  ValueStream<ChosenPeriod> watchChosenPeriod() {
    final periodTypeStream = _prefs.getStringStream('chosen_period_type');
    final dateRangeStream = _watchCustomPeriodDateRange();
    // Because we want to update the chosen period every minute, trigger a stream event every minute
    final pulseStream = Stream.periodic(const Duration(minutes: 1), (_) => null).startWith(null);

    return Rx.combineLatest3(periodTypeStream, dateRangeStream, pulseStream, (
      periodType,
      dateRange,
      _,
    ) {
      final parsed = ChosenPeriodType.values.byName(periodType ?? ChosenPeriodType.thisMonth.name);

      ChosenPeriod createChosenPeriod(ChosenPeriodType parsed) {
        final (start, end) = switch (parsed) {
          ChosenPeriodType.thisMonth => (today.firstDayOfMonth(), today),
          ChosenPeriodType.lastMonth => (lastMonth.firstDayOfMonth(), lastMonth.lastDayOfMonth()),
          ChosenPeriodType.thisYear => (LocalDate(today.year, 1, 1), today),
          ChosenPeriodType.lastYear => (
            LocalDate(today.year - 1, 1, 1),
            LocalDate(today.year - 1, 12, 31),
          ),
          ChosenPeriodType.last3Months => (today.firstDayOfMonth().subtractMonths(2), today),
          ChosenPeriodType.last6Months => (today.firstDayOfMonth().subtractMonths(5), today),
          ChosenPeriodType.last12Months => (today.firstDayOfMonth().subtractMonths(11), today),
          ChosenPeriodType.custom => (dateRange.from, dateRange.to),
        };

        return ChosenPeriod(type: parsed, startDate: start, endDate: end);
      }

      return createChosenPeriod(parsed);
    }).shareValue();
  }

  /// Streams the currently chosen [DateRange] for the last [ChosenPeriodType.custom] period. Not intended to be used publicly.
  ValueStream<DateRange> _watchCustomPeriodDateRange() {
    return watchSelectedBudgetId()
        .switchMap((value) {
          return switch (value) {
            Some<String>(:final some) => _prefs.getStringStream('selected_date_range_$some'),
            None<String>() => Stream.value(null),
          };
        })
        .map((event) {
          /// Ensure that the [DateRange] exposed  is valid.
          /// Specifically, that it starts on the first day of the chosen month and
          /// ends either on the last day of the chosen month (in the event the chosen)
          /// month is not the current month or today (in the event the chosen month
          /// is the current month).
          DateRange constrain(DateRange original) {
            final from = original.from.firstDayOfMonth();
            final to = original.to.lastDayOfMonth();
            if (to.isSameMonthAs(today) && to.isAfter(today)) {
              return (from: from, to: today);
            }
            return (from: from, to: to);
          }

          final range = event == null
              ? (from: today.firstDayOfMonth(), to: today)
              : event.toDateRange();
          return constrain(range);
        })
        .shareValue();
  }

  /// Streams the [DateRange] associated with the current [ChosenPeriod]. If you need the
  /// [ChosenPeriod] itself, use [watchChosenPeriod].
  ValueStream<DateRange> watchSelectedDateRange() {
    return watchChosenPeriod()
        .map((event) => (from: event.startDate, to: event.endDate))
        .shareValue();
  }

  Future<void> setChosenPeriodType(ChosenPeriodType chosenPeriod) async {
    await _prefs.setString('chosen_period_type', chosenPeriod.name);
  }

  Future<void> setCustomPeriod({DateRange? dateRange}) async {
    if (dateRange != null) {
      await setSelectedDateRange(dateRange);
    }
    await _prefs.setString('chosen_period_type', ChosenPeriodType.custom.name);
  }

  Future<void> deleteTransactionTemplate(String templateId) {
    return runIfBudgetIsSelected((budgetId) async {
      final current = await fetchAllTransactionTemplates();
      final updated = current.where((t) => t.id != templateId).toList();
      await _prefs.setStringList(
        'transaction_templates_$budgetId',
        updated.map((t) => t.toJson()).toList(),
      );
    });
  }

  Future<List<TransactionTemplate>> fetchAllTransactionTemplates() async {
    final allPreferences = await _prefs.readAll();
    const legacyTransactionTemplatesPrefix = 'transaction_templates_';
    final legacyTemplates = <MapEntry<String, List<LegacyTransactionTemplate>>>[];

    for (final entry in allPreferences.entries) {
      // The old templates were stored with the key `transaction_templates_<budgetId>`.
      if (!entry.key.startsWith(legacyTransactionTemplatesPrefix)) continue;

      final jsonList = entry.value;
      if (jsonList is! List<String>) continue;

      // Extract the budget ID from the key.
      final budgetId = entry.key.substring(legacyTransactionTemplatesPrefix.length);
      final parsed = <LegacyTransactionTemplate>[];
      final validJson = <String>[];

      for (final json in jsonList) {
        try {
          parsed.add(LegacyTransactionTemplateMapper.fromJson(json));
          validJson.add(json);
        } catch (_) {
          // Invalid legacy templates cannot be migrated to the backend. Drop
          // them so future sync attempts are not blocked by the same bad row.
        }
      }

      if (validJson.length != jsonList.length) {
        await _prefs.setStringList(entry.key, validJson);
      }

      legacyTemplates.add(MapEntry(budgetId, parsed));
    }

    return legacyTemplates.expand((entry) {
      return entry.value.map((template) {
        return TransactionTemplate(
          id: template.id,
          name: template.name,
          budgetId: entry.key,
          amount: template.amount,
          isInflow: template.isInflow,
          accountId: template.accountId,
          payeeId: template.payeeId,
          categoryId: template.categoryId,
          memo: template.memo,
          flag: template.flag,
          subTransactions: template.subTransactions,
          fireImmediately: template.fireImmediately,
        );
      });
    }).toList();
  }

  Future<bool> hasAnyTransactionTemplates() async {
    final allPreferences = await _prefs.readAll();
    return _hasAnyTransactionTemplates(allPreferences);
  }

  ValueStream<bool> watchHasAnyTransactionTemplates() {
    return watchAll().map(_hasAnyTransactionTemplates).distinct().shareValue();
  }

  bool _hasAnyTransactionTemplates(Map<String, Object?> allPreferences) {
    const legacyTransactionTemplatesPrefix = 'transaction_templates_';

    for (final entry in allPreferences.entries) {
      if (!entry.key.startsWith(legacyTransactionTemplatesPrefix)) continue;

      final jsonList = entry.value;
      if (jsonList is List<String> && jsonList.isNotEmpty) return true;
    }

    return false;
  }

  Stream<DateTime> watchMagicLinkSentTimestamp() {
    return _prefs.getIntStream('magic_link_sent_timestamp').map((value) {
      return value == null
          ? DateTime.fromMicrosecondsSinceEpoch(0)
          : DateTime.fromMillisecondsSinceEpoch(value);
    }).shareValue();
  }

  Future<void> setMagicLinkSentTimestamp() {
    return _prefs.setInt('magic_link_sent_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> clear() {
    return _prefs.clear();
  }
}

extension AppSettingsX on Settings {
  Future<void> unhideChart(Chart chart) async {
    final current = await watchHiddenCharts().nextValue();
    setHiddenCharts(current.toSet().difference({chart}).toList());
  }

  Future<void> hideChart(Chart chart) async {
    final current = await watchHiddenCharts().nextValue();
    setHiddenCharts([...current, chart]);
  }

  Future<void> resetIncomeExpenseFilters() async {
    await setIncomeExpenseAccounts(const None());
    await setIncomeExpenseCategoryView(const None());
  }

  Future<int> incrementAppReviewEvents() async {
    final current = await watchAppReviewEvents().nextValue();
    final updated = current + 1;
    await _prefs.setInt('app_review_events', updated);
    return updated;
  }

  Future<void> resetAppReviewEvents() async {
    return _prefs.setInt('app_review_events', 0);
  }

  /// Runs the provided [op] if a budget is selected.
  ///
  /// Otherwise, it no-ops. This is a convenience function to avoid
  /// having to check for `Some` in the calling code, since technically
  /// a user can be in a state where they haven't selected a budget yet.
  Future<Result<T, Exception>> runIfBudgetIsSelected<T>(
    FutureOr<T> Function(String budgetId) op,
  ) async {
    final budgetId = await watchSelectedBudgetId().nextValue();
    return budgetId.whenSome(op);
  }
}
