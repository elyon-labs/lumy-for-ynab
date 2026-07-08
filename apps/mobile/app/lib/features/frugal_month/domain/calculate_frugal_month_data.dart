import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../common/domain/transactions/filters.dart';
import '../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../common/domain/worker/_transactions_sync.dart';
import '../../../utils/_T.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_base_transaction.dart';
import '../../../ynab_api/_transaction.dart';
import 'models/frugal_month.dart';
import 'models/frugal_month_data.dart';
import 'models/frugal_month_status.dart';

Future<FrugalMonthData> calculateFrugalMonthData(
  FrugalMonth month, {

  /// Transactions that are on-budget from *all time*. This function
  /// has a default look back period of 12 months.
  required List<PastTransaction> onBudgetTransactions,
}) async {
  return calculateFrugalMonthDataSync(month, onBudgetTransactions: onBudgetTransactions);
}

FrugalMonthData calculateFrugalMonthDataSync(
  FrugalMonth month, {

  /// Transactions that are on-budget from *all time*. This function
  /// has a default look back period of 12 months.
  required List<PastTransaction> onBudgetTransactions,
}) {
  final categoryIds = month.categoryIds;
  final accountIds = month.accountIds;
  final expenseFilter = _expenseFilter(categoryIds, accountIds);
  final incomeFilter = _incomeFilter(accountIds);

  // All on budget transactions grouped by month
  final byMonth = groupBy(
    onBudgetTransactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateAsc);

  // Just the transactions for the month of the frugal month.
  final transactionsForMonth =
      byMonth.entries.firstWhereOrNull((e) => e.key.isSameMonthAs(month.month))?.value ??
      <PastTransaction>[];

  // Expenses in the selected categories for the selected accounts.
  final expenseTransactions = transactionsForMonth.filterSync(expenseFilter);
  final totalSpent = expenseTransactions.sumAmountFilteredSync(expenseFilter);
  final leftToSpend = month.targetAmount + totalSpent;

  // Income for the selected accounts.
  final incomeTransactions = transactionsForMonth.filterSync(incomeFilter);
  final income = incomeTransactions.sumAmountFilteredSync(incomeFilter);
  final netIncome = income + totalSpent;

  // Expense transactions grouped by date.
  final expensesByDateDesc = expenseTransactions.groupByDateSync(dateDesc);
  final expensesByDateAsc = expensesByDateDesc.sortByKeys(dateAsc);

  // All transactions grouped by date.
  final allTransactionsByDateDesc = [
    ...expenseTransactions,
    ...incomeTransactions,
  ].groupByDateSync(dateDesc);

  // Create a Map of all days in the month to the total amount spent on that day.
  Map<LocalDate, int> calculateSpend() {
    return expensesByDateAsc.mapValues((transactions) {
      return transactions.sumAmountFilteredSync(expenseFilter);
    });
  }

  final spendPerDay = calculateSpend().fillWith(month.month.daysInMonth(), fill: (_) => 0);

  // Calculate the cumulative spending for each day in the frugal month.
  final cumulativeSpend = spendPerDay.entries.foldIndexed<Map<LocalDate, int>>(
    spendPerDay.map((k, _) => MapEntry(k, 0)),
    (index, cumulative, entry) {
      final date = entry.key;
      final amount = entry.value;
      final previous = index == 0 ? 0 : cumulative.values.elementAt(index - 1);
      return cumulative..[date] = previous + amount;
    },
  );

  // Calculate the projected spending, by finding the average spend for *each day of the month* over the last 12 months.
  const numberOfMonthsInLookBack = 12;
  final last12Months = Map.fromEntries(byMonth.entries.takeLast(numberOfMonthsInLookBack));
  final Map<int, List<PastTransaction>> groupedByDayOfMonth = groupBy(
    last12Months.values.flattenSafe(),
    (t) => t.localDate.dayOfMonth,
  ).sortByKeys(intAsc);

  final averageSpendByDay = groupedByDayOfMonth.map((dayOfMonth, transactions) {
    final sumForDay = transactions.sumAmountFilteredSync(expenseFilter);
    final averageSpendOfDay = sumForDay / numberOfMonthsInLookBack;
    return MapEntry(dayOfMonth, averageSpendOfDay);
  });

  final projectedSpend = spendPerDay.entries.fold(<LocalDate, int>{}, (p, c) {
    // For each date in the spend per day, grab the corresponding
    // average spend for that day of the month.
    //
    // Add that amount to the amount from the previous day, round it, and
    // place it in the output map with the same date
    final date = c.key;
    final dayOfMonth = date.dayOfMonth;
    final averageSpend = averageSpendByDay[dayOfMonth] ?? 0;
    final projected = (p.isEmpty ? 0 : p.values.last) + averageSpend;
    return p..[date] = projected.round();
  });

  final status = month.calculateStatus(totalSpent, averageSpendByDay);

  return FrugalMonthData(
    month: month,
    totalSpent: totalSpent,
    leftToSpend: leftToSpend.isNegative ? 0 : leftToSpend,
    netIncome: netIncome,
    status: status,
    transactions: allTransactionsByDateDesc,
    cumulativeSpend: cumulativeSpend,
    projectedSpend: projectedSpend,
  );
}

TransactionFilter _expenseFilter(List<String> categoryIds, List<String> accountIds) {
  return (t, parent) =>
      t.isExpense &&
      categoryIds.contains(t.categoryId) && //
      accountIds.any((id) => t.hasAccountId(id, parent: parent));
}

TransactionFilter _incomeFilter(List<String> accountIds) {
  return (t, parent) => t.isIncome && accountIds.any((id) => t.hasAccountId(id, parent: parent));
}
