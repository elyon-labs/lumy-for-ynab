import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:oxidized/oxidized.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../common/domain/transactions/filters.dart';
import '../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../common/domain/worker/_transactions_sync.dart';
import '../../../common/domain/worker/worker.dart';
import '../../../common/presentation/_color.dart';
import '../../../common/presentation/currency.dart';
import '../../../theme/color_palette.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_category.dart';
import '../../../ynab_api/_month.dart';
import '../../frugal_month/domain/calculate_frugal_month_data.dart';
import '../../frugal_month/domain/models/frugal_month.dart';
import 'metrics.dart';

const String _iOSWidgetProviderName = 'Provider';
const String _iOSWidgetName = 'MetricsWidget';
const String _androidWidgetName = 'MetricsWidget';

const String _leftToSpendKey = 'left_to_spend';
const String _spentThisMonthKey = 'spent_this_month';
const String _ageOfMoneyKey = 'age_of_money';

const String _noBudgetReason = 'No budget';

/// Updates the data for the MetricsWidget and triggers an update
/// of the Widget so the latest data is displayed.
Future<void> updateMetricWidget({
  required Worker worker,
  required Option<String> selectedBudgetId,
  required Option<CurrencyFormat> currencyFormat,
  required bool useFrugalMonthLeftToSpend,
  required Option<FrugalMonth> currentFrugalMonth,
  required List<Month> allMonths,
  required List<Category> categoriesInView,
  required List<PastTransaction> currentMonthExpenseTransactions,
  required List<PastTransaction> lastMonthExpenseTransactions,
}) async {
  Future<void> forceUpdateWidget() async {
    await HomeWidget.updateWidget(
      name: _iOSWidgetProviderName,
      iOSName: _iOSWidgetName,
      androidName: _androidWidgetName,
    );
  }

  if (selectedBudgetId.isNone()) {
    for (final widget in [_leftToSpendKey, _spentThisMonthKey, _ageOfMoneyKey]) {
      await HomeWidget.saveWidgetData<String>(
        widget,
        jsonEncode(MetricPayload.empty(reason: _noBudgetReason, palette: lightPalette).toJson()),
      );
    }
    await forceUpdateWidget();
    return;
  }

  final data = await calculateMetricsWidgetDataInWorker(
    worker: worker,
    input: MetricsWidgetCalculationInput(
      currencyFormat: currencyFormat,
      useFrugalMonthLeftToSpend: useFrugalMonthLeftToSpend,
      currentFrugalMonth: currentFrugalMonth,
      allMonths: allMonths,
      categoriesInView: categoriesInView,
      currentMonthExpenseTransactions: currentMonthExpenseTransactions,
      lastMonthExpenseTransactions: lastMonthExpenseTransactions,
      today: today,
    ),
  );

  await HomeWidget.saveWidgetData<String>(_leftToSpendKey, jsonEncode(data.leftToSpend.toMap()));
  await HomeWidget.saveWidgetData<String>(
    _spentThisMonthKey,
    jsonEncode(data.spentThisMonth.toMap()),
  );
  await HomeWidget.saveWidgetData<String>(_ageOfMoneyKey, jsonEncode(data.ageOfMoney.toMap()));

  await forceUpdateWidget();
}

class MetricsWidgetData {
  const MetricsWidgetData({
    required this.leftToSpend,
    required this.spentThisMonth,
    required this.ageOfMoney,
  });

  final MetricPayload leftToSpend;
  final MetricPayload spentThisMonth;
  final MetricPayload ageOfMoney;
}

class MetricsWidgetCalculationInput {
  const MetricsWidgetCalculationInput({
    required this.currencyFormat,
    required this.useFrugalMonthLeftToSpend,
    required this.currentFrugalMonth,
    required this.allMonths,
    required this.categoriesInView,
    required this.currentMonthExpenseTransactions,
    required this.lastMonthExpenseTransactions,
    required this.today,
  });

  final Option<CurrencyFormat> currencyFormat;
  final bool useFrugalMonthLeftToSpend;
  final Option<FrugalMonth> currentFrugalMonth;
  final List<Month> allMonths;
  final List<Category> categoriesInView;
  final List<PastTransaction> currentMonthExpenseTransactions;
  final List<PastTransaction> lastMonthExpenseTransactions;
  final LocalDate today;
}

Future<MetricsWidgetData> calculateMetricsWidgetDataInWorker({
  required Worker worker,
  required MetricsWidgetCalculationInput input,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateMetricsWidgetDataSync(input),
  );
}

MetricsWidgetData calculateMetricsWidgetDataSync(MetricsWidgetCalculationInput input) {
  final today = input.today;
  final thisMonth = today.firstDayOfMonth();
  final lastMonth = thisMonth.subtractMonths(1);

  final currentMonth = input.allMonths.singleWhereOrNull(
    (m) => m.localDate.isSameMonthAs(thisMonth),
  );

  final leftToSpend = calculateLeftToSpendSync(
    categories: input.categoriesInView,
    onBudgetTransactions: input.currentMonthExpenseTransactions,
    currentMonth: currentMonth,
    currentFrugalMonth: input.currentFrugalMonth,
    useFrugalMonthLeftToSpend: input.useFrugalMonthLeftToSpend,
  );

  final spendData = calculateSpentThisMonthSync(
    transactions: input.currentMonthExpenseTransactions,
    month: thisMonth,
    today: today,
  );

  final currentFrugalMonthTransactions = input.currentFrugalMonth.mapOr((frugalMonth) {
    return input.currentMonthExpenseTransactions.filterSync((t, parent) {
      return isExpense(t, parent) && frugalMonth.categoryIds.any((id) => t.categoryId == id);
    });
  }, <PastTransaction>[]);

  final thisMonthGrouped = input.currentMonthExpenseTransactions.groupByDateSync().fillWith(
    today.daysInMonth(),
    fill: (date) => [],
  );

  final lastMonthGrouped = input.lastMonthExpenseTransactions.groupByDateSync().fillWith(
    lastMonth.daysInMonth(),
    fill: (date) => [],
  );

  final frugalMonthGrouped = input.currentFrugalMonth.mapOr((frugalMonth) {
    final grouped = currentFrugalMonthTransactions.groupByDateSync();
    return grouped.fillWith(today.daysInMonth(), fill: (date) => []);
  }, thisMonthGrouped);

  final thisMonthDailySums = thisMonthGrouped.map((date, transactions) {
    return MapEntry(date, transactions.sumAmountFilteredSync(isExpense));
  });

  final lastMonthDailySums = lastMonthGrouped.map((date, transactions) {
    return MapEntry(date, transactions.sumAmountFilteredSync(isExpense));
  });

  final frugalMonthDailySums = input.currentFrugalMonth.mapOr((frugalMonth) {
    return frugalMonthGrouped.map((date, transactions) {
      return MapEntry(date, transactions.sumAmountFilteredSync(isExpense));
    });
  }, thisMonthDailySums);

  final ageOfMoneys = input.allMonths
      // The YNAB API returns the next month before it starts
      .whereNot((m) => m.localDate.isAfter(today.firstDayOfMonth())) //
      .map((e) => MapEntry(e.localDate, e.ageOfMoney ?? 0));

  final categoriesInViewInitialBalanceSum = input.categoriesInView.map((e) => e.initialBalance).sum;

  final startingBalance = input.currentFrugalMonth.mapOr((frugalMonth) {
    return input.useFrugalMonthLeftToSpend
        ? frugalMonth.targetAmount
        : categoriesInViewInitialBalanceSum;
  }, categoriesInViewInitialBalanceSum);

  final leftToSpendSource = input.currentFrugalMonth.mapOr((frugalMonth) {
    return input.useFrugalMonthLeftToSpend ? frugalMonthDailySums : thisMonthDailySums;
  }, thisMonthDailySums);

  final dailyLeftToSpend = leftToSpendSource.entries.fold<Map<LocalDate, int>>(
    {today.firstDayOfMonth(): startingBalance},
    (previousValue, element) {
      final previousBalance = previousValue.entries.last.value;
      final newBalance = previousBalance + element.value;
      return {...previousValue, element.key: newBalance > 0 ? newBalance : 0};
    },
  );

  final dailySpentLastMonth = lastMonthDailySums.entries.fold<Map<LocalDate, int>>(
    {lastMonth.firstDayOfMonth(): 0},
    (previousValue, element) {
      final previousBalance = previousValue.entries.last.value;
      final newBalance = previousBalance + element.value * -1;
      return {...previousValue, element.key: newBalance};
    },
  );

  final spentThisMonthValue = spendData.entries.singleWhereOrNull((e) => e.key.isSameDayAs(today));
  final dailySpentThisMonth = thisMonthDailySums.entries
      .where((e) => e.key.isBefore(today) || e.key.isSameDayAs(today)) //
      .fold<Map<LocalDate, int>>({today.firstDayOfMonth(): 0}, (previousValue, element) {
        final previousBalance = previousValue.entries.last.value;
        final newBalance = previousBalance + element.value * -1;
        return {...previousValue, element.key: newBalance};
      });

  final leftToSpendPayload = MetricPayload(
    canBeShown: true,
    chartData: [
      ChartData(
        colorLight: lightPalette.primary.toHex(),
        colorDark: darkPalette.primary.toHex(),
        points: dailyLeftToSpend.entries.map((e) => ChartPoint(e.key.dayOfMonth, e.value)).toList(),
        isDashed: false,
      ),
    ],
    statData: StatData(
      title: 'LTS',
      value: leftToSpend.format(input.currencyFormat),
      textColor: lightPalette.onGood.toHex(),
      backgroundColor: lightPalette.good.toHex(),
    ),
  );

  final spentThisMonthPayload = MetricPayload(
    canBeShown: true,
    chartData: [
      ChartData(
        colorLight: lightBespokePalette.chartCompare.toHex(),
        colorDark: darkBespokePalette.chartCompare.toHex(),
        points: dailySpentLastMonth.entries
            .map((e) => ChartPoint(e.key.dayOfMonth, e.value))
            .toList(),
        isDashed: true,
      ),
      ChartData(
        colorLight: lightPalette.primary.toHex(),
        colorDark: darkPalette.primary.toHex(),
        points: dailySpentThisMonth.entries
            .map((e) => ChartPoint(e.key.dayOfMonth, e.value))
            .toList(),
        isDashed: false,
      ),
    ],
    statData: StatData(
      title: 'STM',
      value: (spentThisMonthValue?.value ?? 0).format(input.currencyFormat),
      textColor: lightPalette.onGood.toHex(),
      backgroundColor: lightPalette.good.toHex(),
    ),
  );

  final ageOfMoneyPayload = MetricPayload(
    canBeShown: true,
    chartData: [
      ChartData(
        colorLight: lightPalette.primary.toHex(),
        colorDark: darkPalette.primary.toHex(),
        points: ageOfMoneys.mapIndexed((i, e) => ChartPoint(i, e.value)).toList(),
        isDashed: false,
      ),
    ],
    statData: StatData(
      title: 'AOM',
      value: '${ageOfMoneys.lastOrNull?.value ?? 0} days',
      textColor: lightPalette.onGood.toHex(),
      backgroundColor: lightPalette.good.toHex(),
    ),
  );

  return MetricsWidgetData(
    leftToSpend: leftToSpendPayload,
    spentThisMonth: spentThisMonthPayload,
    ageOfMoney: ageOfMoneyPayload,
  );
}

int calculateLeftToSpendSync({
  required List<Category> categories,
  required List<PastTransaction> onBudgetTransactions,
  required Month? currentMonth,
  required Option<FrugalMonth> currentFrugalMonth,
  required bool useFrugalMonthLeftToSpend,
}) {
  final categoryBalance = categories
      .where((c) => !c.isReadyToAssign)
      .map((p0) => p0.balance)
      .where((b) => b > 0)
      .sum;
  final overspending = categories.where((b) => b.isOverspent).map((e) => e.balance).sum.abs();
  final amount = (currentMonth?.toBeBudgeted ?? 0) + categoryBalance - overspending;
  final frugalMonthLeftToSpend = currentFrugalMonth.mapOr((frugalMonth) {
    if (!useFrugalMonthLeftToSpend) return amount;
    final frugalMonthData = calculateFrugalMonthDataSync(
      frugalMonth,
      onBudgetTransactions: onBudgetTransactions,
    );
    return frugalMonthData.leftToSpend;
  }, amount);

  return [frugalMonthLeftToSpend, amount].min;
}

Map<LocalDate, int?> calculateSpentThisMonthSync({
  required List<PastTransaction> transactions,
  required LocalDate month,
  required LocalDate today,
}) {
  final grouped = transactions.groupByDateSync(dateAsc);
  final amounts = grouped.map((date, value) {
    return MapEntry(date, value.sumAmountFilteredSync(isExpense));
  });
  final filledAmounts = amounts.fillWith(month.daysInMonth(), fill: (date) => 0);
  final accumulated = <int>[];
  for (final amount in filledAmounts.values) {
    accumulated.add((accumulated.lastOrNull ?? 0) + amount);
  }
  return filledAmounts.mapIndexed((index, date, amount) {
    return MapEntry(date, date.isAfter(today) ? null : accumulated.elementAt(index));
  });
}
