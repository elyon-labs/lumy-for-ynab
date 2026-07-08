import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/features/month_in_review/widgets/expense_compare.dart';
import 'package:lumy/features/month_in_review/widgets/expense_title.dart';
import 'package:lumy/features/month_in_review/widgets/expense_trend.dart';
import 'package:lumy/features/month_in_review/widgets/income_compare.dart';
import 'package:lumy/features/month_in_review/widgets/income_title.dart';
import 'package:lumy/features/month_in_review/widgets/income_trend.dart';
import 'package:lumy/features/month_in_review/widgets/savings_rate.dart';
import 'package:lumy/features/month_in_review/widgets/top_movers.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/category_factory.dart';
import '../../../factory/transaction_factory.dart';

void main() {
  const categoryId = 'category-id';
  final category = CategoryFactory.build(id: categoryId, name: 'Groceries');

  PastTransaction expense({
    required String id,
    required LocalDate date,
    required int amount,
    String categoryId = categoryId,
    List<SubTransaction> subTransactions = const [],
  }) {
    return TransactionFactory.build(
      id: id,
      date: date.toString('yyyy-MM-dd', null),
      amount: amount,
      categoryId: categoryId,
      categoryName: 'Category',
      subTransactions: subTransactions,
    );
  }

  SubTransaction subExpense({required int amount, String categoryId = categoryId}) {
    return SubTransactionFactory.build(
      amount: amount,
      categoryId: categoryId,
      categoryName: 'Category',
    );
  }

  PastTransaction income({required String id, required LocalDate date, required int amount}) {
    return TransactionFactory.build(
      id: id,
      date: date.toString('yyyy-MM-dd', null),
      amount: amount,
      categoryId: 'ready-to-assign-id',
      categoryName: 'Inflow: Ready to Assign',
      payeeName: 'Employer',
      subTransactions: const [],
    );
  }

  group('month in review calculators', () {
    test('calculates title totals with split transaction semantics', () {
      final month = LocalDate(2026, 4, 1);
      final split = expense(
        id: 'split',
        date: month,
        amount: 0,
        categoryId: 'split-parent',
        subTransactions: [
          subExpense(amount: -1500),
          subExpense(amount: -500, categoryId: 'other-category'),
        ],
      );

      final expenseState = calculateExpenseTitleStateSync(
        ExpenseTitleInput(
          actual: [
            split,
            expense(id: 'expense', date: month, amount: -2500),
          ],
          comparison: [expense(id: 'comparison', date: month.subtractMonths(1), amount: -1000)],
        ),
      );
      final incomeState = calculateIncomeTitleStateSync(
        IncomeTitleInput(
          actual: [income(id: 'income', date: month, amount: 5000)],
          comparison: [
            income(id: 'comparison-income', date: month.subtractMonths(1), amount: 4000),
          ],
        ),
      );

      expect(expenseState.amount, -4500);
      expect(expenseState.comparisonAmount, -1000);
      expect(incomeState.amount, 5000);
      expect(incomeState.comparisonAmount, 4000);
    });

    test('calculates income and expense averages', () {
      final actualMonth = LocalDate(2026, 4, 1);
      final averageMonths = [LocalDate(2026, 1, 1), LocalDate(2026, 2, 1), LocalDate(2026, 3, 1)];

      final incomeState = calculateIncomeCompareStateSync(
        IncomeCompareInput(
          averageIncomeTransactions: [
            for (final month in averageMonths)
              income(id: 'income-$month', date: month, amount: 3000),
          ],
          actualIncomeTransactions: [income(id: 'actual-income', date: actualMonth, amount: 4500)],
        ),
      );
      final expenseState = calculateExpenseCompareStateSync(
        ExpenseCompareInput(
          averageExpenseTransactions: [
            for (final month in averageMonths)
              expense(id: 'expense-$month', date: month, amount: -2000),
          ],
          actualExpenseTransactions: [
            expense(id: 'actual-expense', date: actualMonth, amount: -3000),
          ],
        ),
      );

      expect(incomeState.averageIncome, 3000);
      expect(incomeState.actualIncome, 4500);
      expect(incomeState.incomeDifferencePercent, 50);
      expect(expenseState.averageExpenses, -2000);
      expect(expenseState.actualExpenses, -3000);
      expect(expenseState.expenseDifferencePercent, 50);
    });

    test('handles empty average windows for compare tiles', () {
      final actualMonth = LocalDate(2026, 4, 1);

      final incomeState = calculateIncomeCompareStateSync(
        IncomeCompareInput(
          averageIncomeTransactions: const [],
          actualIncomeTransactions: [income(id: 'actual-income', date: actualMonth, amount: 4500)],
        ),
      );
      final expenseState = calculateExpenseCompareStateSync(
        ExpenseCompareInput(
          averageExpenseTransactions: const [],
          actualExpenseTransactions: [
            expense(id: 'actual-expense', date: actualMonth, amount: -3000),
          ],
        ),
      );

      expect(incomeState.averageIncome, 0);
      expect(incomeState.actualIncome, 4500);
      expect(incomeState.incomeDifferencePercent, 0);
      expect(expenseState.averageExpenses, 0);
      expect(expenseState.actualExpenses, -3000);
      expect(expenseState.expenseDifferencePercent, 0);
    });

    test('calculates trends and excludes current and future months', () {
      final today = LocalDate(2026, 4, 15);

      final incomeState = calculateIncomeTrendStateSync(
        IncomeTrendInput(
          today: today,
          transactions: [
            income(id: 'feb-income', date: LocalDate(2026, 2, 1), amount: 2000),
            income(id: 'mar-income', date: LocalDate(2026, 3, 1), amount: 3000),
            income(id: 'apr-income', date: LocalDate(2026, 4, 1), amount: 4000),
            income(id: 'may-income', date: LocalDate(2026, 5, 1), amount: 5000),
          ],
        ),
      );
      final expenseState = calculateExpenseTrendStateSync(
        ExpenseTrendInput(
          today: today,
          transactions: [
            expense(id: 'feb-expense', date: LocalDate(2026, 2, 1), amount: -1200),
            expense(id: 'mar-expense', date: LocalDate(2026, 3, 1), amount: -1800),
            expense(id: 'apr-expense', date: LocalDate(2026, 4, 1), amount: -2400),
          ],
        ),
      );

      expect(incomeState.incomeByMonth.keys, [LocalDate(2026, 2, 1), LocalDate(2026, 3, 1)]);
      expect(incomeState.incomeByMonth.values, [2000, 3000]);
      expect(expenseState.expensesByMonth.keys, [LocalDate(2026, 2, 1), LocalDate(2026, 3, 1)]);
      expect(expenseState.expensesByMonth.values, [-1200, -1800]);
    });

    test('calculates savings rate edge cases', () {
      final month = LocalDate(2026, 4, 1);

      expect(
        calculateSavingsRateSync(
          SavingsRateInput(
            allTransactions: [income(id: 'income', date: month, amount: 10000)],
            expenseTransactions: [expense(id: 'expense', date: month, amount: -4000)],
          ),
        ),
        60,
      );
      expect(
        calculateSavingsRateSync(
          SavingsRateInput(
            allTransactions: const [],
            expenseTransactions: [expense(id: 'expense', date: month, amount: -4000)],
          ),
        ),
        0,
      );
      expect(
        calculateSavingsRateSync(
          SavingsRateInput(
            allTransactions: [income(id: 'refund-income', date: month, amount: 10000)],
            expenseTransactions: [expense(id: 'refund', date: month, amount: 500)],
          ),
        ),
        100,
      );
    });

    test('calculates top movers by category', () {
      final month = LocalDate(2026, 4, 1);

      final state = calculateTopMoversStateSync(
        TopMoversInput(
          month: month,
          categories: [category],
          actual: [expense(id: 'actual', date: month, amount: -5000)],
          average: [
            expense(id: 'jan', date: LocalDate(2026, 1, 1), amount: -2000),
            expense(id: 'feb', date: LocalDate(2026, 2, 1), amount: -4000),
          ],
        ),
      );

      final movement = state.movements[category]!;
      expect(movement.actualValue, -5000);
      expect(movement.comparisonMonth, month.subtractMonths(1));
      expect(movement.comparisonValue, -3000);
      expect(movement.difference, -2000);
    });

    test('runs calculators on the background worker', () async {
      final month = LocalDate(2026, 4, 1);
      final worker = Worker.on(IsolateType.background);
      final incomeTitle = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateIncomeTitleStateSync(
          IncomeTitleInput(
            actual: [income(id: 'income', date: month, amount: 4500)],
            comparison: const [],
          ),
        ),
      );
      final expenseTitle = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateExpenseTitleStateSync(
          ExpenseTitleInput(
            actual: [expense(id: 'expense', date: month, amount: -3000)],
            comparison: const [],
          ),
        ),
      );
      final incomeTrend = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateIncomeTrendStateSync(
          IncomeTrendInput(
            today: LocalDate(2026, 4, 15),
            transactions: [income(id: 'income', date: LocalDate(2026, 3, 1), amount: 3000)],
          ),
        ),
      );
      final expenseTrend = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateExpenseTrendStateSync(
          ExpenseTrendInput(
            today: LocalDate(2026, 4, 15),
            transactions: [expense(id: 'expense', date: LocalDate(2026, 3, 1), amount: -3000)],
          ),
        ),
      );
      final incomeCompare = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateIncomeCompareStateSync(
          IncomeCompareInput(
            averageIncomeTransactions: const [],
            actualIncomeTransactions: [income(id: 'actual-income', date: month, amount: 4500)],
          ),
        ),
      );
      final expenseCompare = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateExpenseCompareStateSync(
          ExpenseCompareInput(
            averageExpenseTransactions: const [],
            actualExpenseTransactions: [expense(id: 'actual-expense', date: month, amount: -3000)],
          ),
        ),
      );
      final savingsRate = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateSavingsRateSync(
          SavingsRateInput(
            allTransactions: [income(id: 'income', date: month, amount: 10000)],
            expenseTransactions: [expense(id: 'expense', date: month, amount: -4000)],
          ),
        ),
      );
      final topMovers = await runTransactionCalculation(
        worker: worker,
        calculate: () => calculateTopMoversStateSync(
          TopMoversInput(
            month: month,
            categories: [category],
            actual: [expense(id: 'actual', date: month, amount: -5000)],
            average: const [],
          ),
        ),
      );

      expect(incomeTitle.amount, 4500);
      expect(expenseTitle.amount, -3000);
      expect(incomeTrend.incomeByMonth, {LocalDate(2026, 3, 1): 3000});
      expect(expenseTrend.expensesByMonth, {LocalDate(2026, 3, 1): -3000});
      expect(incomeCompare.averageIncome, 0);
      expect(expenseCompare.averageExpenses, 0);
      expect(savingsRate, 60);
      expect(topMovers.movements[category]?.actualValue, -5000);
    });
  });
}
