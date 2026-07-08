import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/features/frugal_month/domain/models/frugal_month.dart';
import 'package:lumy/features/home_widgets/metrics/update_metrics_widget.dart';
import 'package:lumy/utils/_local_date.dart';
import 'package:oxidized/oxidized.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/category_factory.dart';
import '../../../factory/transaction_factory.dart';

void main() {
  const categoryId = 'category-id';
  const accountId = 'account-id';

  Category category({
    String id = categoryId,
    String name = 'Groceries',
    int activity = -3000,
    int balance = 10000,
  }) {
    return CategoryFactory.build(
      id: id,
      name: name,
      isHidden: false,
      isDeleted: false,
      activity: activity,
      budgeted: 0,
      balance: balance,
    );
  }

  Month month(LocalDate date, {int? ageOfMoney, int toBeBudgeted = 1000}) {
    return Month(
      month: date.toString('yyyy-MM-dd', null),
      note: null,
      income: 0,
      budgeted: 0,
      activity: 0,
      toBeBudgeted: toBeBudgeted,
      ageOfMoney: ageOfMoney,
      isDeleted: false,
    );
  }

  PastTransaction expense({
    required String id,
    required LocalDate date,
    required int amount,
    String categoryId = categoryId,
    String accountId = accountId,
  }) {
    return TransactionFactory.build(
      id: id,
      date: date.toString('yyyy-MM-dd', null),
      amount: amount,
      accountId: accountId,
      categoryId: categoryId,
      categoryName: 'Category',
      subTransactions: const [],
    );
  }

  MetricsWidgetCalculationInput input({
    bool useFrugalMonthLeftToSpend = false,
    Option<FrugalMonth> currentFrugalMonth = const None(),
    List<Category>? categories,
    List<PastTransaction>? currentTransactions,
    List<PastTransaction>? lastTransactions,
    LocalDate? today,
  }) {
    final currentToday = today ?? LocalDate(2026, 4, 3);
    final thisMonth = currentToday.firstDayOfMonth();
    final lastMonth = thisMonth.subtractMonths(1);
    return MetricsWidgetCalculationInput(
      currencyFormat: const None(),
      useFrugalMonthLeftToSpend: useFrugalMonthLeftToSpend,
      currentFrugalMonth: currentFrugalMonth,
      allMonths: [
        month(lastMonth, ageOfMoney: 12),
        month(thisMonth, ageOfMoney: 15),
        month(thisMonth.addMonths(1), ageOfMoney: 99),
      ],
      categoriesInView: categories ?? [category()],
      currentMonthExpenseTransactions:
          currentTransactions ??
          [
            expense(id: 'current-1', date: thisMonth, amount: -1000),
            expense(id: 'current-3', date: thisMonth.addDays(2), amount: -2000),
          ],
      lastMonthExpenseTransactions:
          lastTransactions ??
          [
            expense(id: 'last-1', date: lastMonth, amount: -500),
            expense(id: 'last-2', date: lastMonth.addDays(1), amount: -700),
          ],
      today: currentToday,
    );
  }

  group('calculateSpentThisMonthSync', () {
    test('fills month dates and nulls future accumulated values', () {
      final today = LocalDate(2026, 4, 3);
      final thisMonth = today.firstDayOfMonth();

      final data = calculateSpentThisMonthSync(
        transactions: [
          expense(id: 'day-1', date: thisMonth, amount: -1000),
          expense(id: 'day-3', date: thisMonth.addDays(2), amount: -2000),
        ],
        month: thisMonth,
        today: today,
      );

      expect(data[thisMonth], -1000);
      expect(data[thisMonth.addDays(1)], -1000);
      expect(data[thisMonth.addDays(2)], -3000);
      expect(data[thisMonth.addDays(3)], isNull);
      expect(data, hasLength(30));
    });
  });

  group('calculateMetricsWidgetDataSync', () {
    test('builds current month, last month, and age of money payloads', () {
      final today = LocalDate(2026, 4, 3);
      final data = calculateMetricsWidgetDataSync(input(today: today));

      expect(data.leftToSpend.statData.value, '11.00');
      expect(data.leftToSpend.chartData.single.points.take(3).map((p) => p.y), [
        12000,
        12000,
        10000,
      ]);

      expect(data.spentThisMonth.statData.value, '-3.00');
      expect(data.spentThisMonth.chartData.first.points.take(2).map((p) => p.y), [500, 1200]);
      expect(data.spentThisMonth.chartData.last.points.map((p) => p.y), [1000, 1000, 3000]);

      expect(data.ageOfMoney.statData.value, '15 days');
      expect(data.ageOfMoney.chartData.single.points.map((p) => p.y), [12, 15]);
    });

    test('uses frugal month categories for left-to-spend chart source', () {
      final today = LocalDate(2026, 4, 3);
      final thisMonth = today.firstDayOfMonth();
      final frugalMonth = FrugalMonth(
        id: 'frugal-month-id',
        budgetId: 'budget-id',
        month: thisMonth,
        targetAmount: 5000,
        categoryIds: const [categoryId],
        accountIds: const [accountId],
      );

      final data = calculateMetricsWidgetDataSync(
        input(
          today: today,
          useFrugalMonthLeftToSpend: true,
          currentFrugalMonth: Some(frugalMonth),
          currentTransactions: [
            expense(id: 'included', date: thisMonth, amount: -1000),
            expense(
              id: 'excluded',
              date: thisMonth.addDays(1),
              amount: -2000,
              categoryId: 'other-category-id',
            ),
          ],
        ),
      );

      expect(data.leftToSpend.statData.value, '4.00');
      expect(data.leftToSpend.chartData.single.points.take(3).map((p) => p.y), [4000, 4000, 4000]);
    });

    test('marks metric payloads as visible', () {
      final data = calculateMetricsWidgetDataSync(input());

      expect(data.leftToSpend.canBeShown, isTrue);
      expect(data.spentThisMonth.canBeShown, isTrue);
      expect(data.ageOfMoney.canBeShown, isTrue);
    });

    test('runs on the background worker', () async {
      final data = await calculateMetricsWidgetDataInWorker(
        worker: Worker.on(IsolateType.background),
        input: input(),
      );

      expect(data.spentThisMonth.chartData.last.points.map((p) => p.y), [1000, 1000, 3000]);
    });
  });
}
