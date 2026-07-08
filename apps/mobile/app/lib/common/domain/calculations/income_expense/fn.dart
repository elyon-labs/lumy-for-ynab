import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:oxidized/oxidized.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../features/date_range/domain/models/date_range.dart';
import '../../../../utils/_local_date.dart';
import '../../../../utils/sort.dart';
import '../../../../ynab_api/_transaction.dart';
import '../../transactions/filters.dart';
import '../../worker/_base_transactions_sync.dart';

Future<IncomeExpenseData> calculateIncomeExpense({
  required List<Category> categories,
  required List<Payee> payees,
  required List<PastTransaction> transactions,
  required DateRange dateRange,
}) async {
  return calculateIncomeExpenseSync(
    categories: categories,
    payees: payees,
    transactions: transactions,
    dateRange: dateRange,
  );
}

IncomeExpenseData calculateIncomeExpenseSync({
  required List<Category> categories,
  required List<Payee> payees,
  required List<PastTransaction> transactions,
  required DateRange dateRange,
}) {
  final monthsInRange = dateRange.monthsInRange().sorted(dateDesc);
  final transactionsByMonth = groupBy(
    transactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateDesc).fillWith(monthsInRange, fill: (_) => <PastTransaction>[]);
  final months = <IncomeExpenseMonthData>[];

  for (final entry in transactionsByMonth.entries) {
    final transactionsForMonth = entry.value;

    final incomeTransactions = transactionsForMonth.filterSync(isIncome);
    final expenseTransactions = transactionsForMonth.filterSync(isExpense);

    final payeesToTransactions = incomeTransactions.groupByPayeeSync(payees)
      ..removeWhere((_, value) => value.isEmpty);

    final payeesToIncome = <Option<Payee>, int>{};
    for (final entry in payeesToTransactions.entries) {
      payeesToIncome[entry.key] = entry.value.sumAmountFilteredSync(isIncomeFromPayee(entry.key));
    }

    final categoriesToTransactions = expenseTransactions.groupByCategorySync(categories.toList())
      ..removeWhere((_, value) => value.isEmpty);

    final categoriesToExpense = <Category, int>{};
    for (final entry in categoriesToTransactions.entries) {
      categoriesToExpense[entry.key] = entry.value.sumAmountFilteredSync(
        isExpenseInCategory(entry.key),
      );
    }

    final income = payeesToIncome.values.sum;
    final expense = categoriesToExpense.values.sum;
    final net = income + expense;
    final summary = (income: income, expense: expense, net: net);

    months.add(
      IncomeExpenseMonthData(
        month: entry.key,
        summary: summary,
        transactions: transactionsForMonth,
        payeesToTransactions: payeesToTransactions,
        payeesToIncome: payeesToIncome,
        categoriesToTransactions: categoriesToTransactions,
        categoriesToExpense: categoriesToExpense,
      ),
    );
  }
  return IncomeExpenseData(monthData: months);
}

class IncomeExpenseMonthData {
  IncomeExpenseMonthData({
    required this.month,
    required this.summary,
    required this.transactions,
    required this.payeesToTransactions,
    required this.payeesToIncome,
    required this.categoriesToTransactions,
    required this.categoriesToExpense,
  });

  final LocalDate month;
  final ({int income, int expense, int net}) summary;
  final List<PastTransaction> transactions;
  final Map<Option<Payee>, List<PastTransaction>> payeesToTransactions;
  final Map<Option<Payee>, int> payeesToIncome;
  final Map<Category, List<PastTransaction>> categoriesToTransactions;
  final Map<Category, int> categoriesToExpense;
}

class IncomeExpenseData extends Equatable {
  const IncomeExpenseData({required this.monthData});

  final List<IncomeExpenseMonthData> monthData;

  @override
  List<Object?> get props => [monthData];
}
