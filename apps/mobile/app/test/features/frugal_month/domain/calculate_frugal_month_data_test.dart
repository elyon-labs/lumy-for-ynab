import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/features/frugal_month/domain/calculate_frugal_month_data.dart';
import 'package:lumy/features/frugal_month/domain/models/frugal_month.dart';
import 'package:lumy/features/frugal_month/domain/models/frugal_month_status.dart';
import 'package:lumy/features/frugal_month/domain/use_cases/calculate_frugal_month_data.dart';
import 'package:lumy/utils/_local_date.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/transaction_factory.dart';

void main() {
  group('calculateFrugalMonthDataSync', () {
    const accountId = 'account-id';
    const categoryId = 'category-id';

    FrugalMonth month({LocalDate? date, int targetAmount = 10000}) {
      return FrugalMonth(
        id: 'frugal-month-id',
        month: date ?? today.firstDayOfMonth(),
        budgetId: 'budget-id',
        targetAmount: targetAmount,
        categoryIds: const [categoryId],
        accountIds: const [accountId],
      );
    }

    PastTransaction expense({
      required String id,
      required LocalDate date,
      required int amount,
      String account = accountId,
      String category = categoryId,
      List<SubTransaction> subTransactions = const [],
    }) {
      return TransactionFactory.build(
        id: id,
        accountId: account,
        categoryId: category,
        amount: amount,
        date: date.toString('yyyy-MM-dd', null),
        subTransactions: subTransactions,
      );
    }

    PastTransaction income({
      required String id,
      required LocalDate date,
      required int amount,
      String account = accountId,
    }) {
      return TransactionFactory.build(
        id: id,
        accountId: account,
        categoryId: 'ready-to-assign-id',
        categoryName: 'Inflow: Ready to Assign',
        payeeName: 'Employer',
        amount: amount,
        date: date.toString('yyyy-MM-dd', null),
        subTransactions: const [],
      );
    }

    test('calculates current-month spend, income, and transactions', () {
      final currentMonth = today.firstDayOfMonth();
      final data = calculateFrugalMonthDataSync(
        month(date: currentMonth),
        onBudgetTransactions: [
          expense(id: 'expense', date: currentMonth.addDays(1), amount: -2500),
          income(id: 'income', date: currentMonth.addDays(2), amount: 6000),
          expense(
            id: 'wrong-category',
            date: currentMonth.addDays(3),
            amount: -9000,
            category: 'other-category-id',
          ),
          expense(
            id: 'wrong-month',
            date: currentMonth.subtractMonths(1).addDays(1),
            amount: -7000,
          ),
        ],
      );

      expect(data.totalSpent, -2500);
      expect(data.leftToSpend, 7500);
      expect(data.netIncome, 3500);
      expect(data.transactions.values.expand((t) => t).map((t) => t.id), ['income', 'expense']);
    });

    test('builds cumulative spend for every day in the frugal month', () {
      final currentMonth = today.firstDayOfMonth();
      final data = calculateFrugalMonthDataSync(
        month(date: currentMonth),
        onBudgetTransactions: [
          expense(id: 'day-1', date: currentMonth, amount: -1000),
          expense(id: 'day-3', date: currentMonth.addDays(2), amount: -2000),
        ],
      );

      expect(data.cumulativeSpend[currentMonth], -1000);
      expect(data.cumulativeSpend[currentMonth.addDays(1)], -1000);
      expect(data.cumulativeSpend[currentMonth.addDays(2)], -3000);
      expect(data.cumulativeSpend, hasLength(currentMonth.numDaysInMonth()));
    });

    test('projects spend from the last twelve months by day of month', () {
      final targetMonth = LocalDate(2099, 1, 1);
      final lookbackTransactions = [
        for (var i = 1; i <= 12; i++)
          expense(id: 'lookback-$i', date: targetMonth.subtractMonths(i), amount: -1200),
      ];

      final data = calculateFrugalMonthDataSync(
        month(date: targetMonth),
        onBudgetTransactions: lookbackTransactions,
      );

      expect(data.projectedSpend[targetMonth], -1200);
      expect(data.projectedSpend[targetMonth.addDays(1)], -1200);
      expect(data.status, FrugalMonthStatus.notStarted);
    });

    test('runs through the background worker use case', () async {
      final currentMonth = today.firstDayOfMonth();
      final useCase = CalculateFrugalMonthData(worker: Worker.on(IsolateType.background));

      final data = await useCase(
        month(date: currentMonth),
        onBudgetTransactions: [expense(id: 'expense', date: currentMonth, amount: -1000)],
      );

      expect(data.totalSpent, -1000);
      expect(data.leftToSpend, 9000);
    });
  });
}
