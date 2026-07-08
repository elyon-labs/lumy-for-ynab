import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../features/date_range/domain/models/date_range.dart';
import '../../../../utils/_local_date.dart';
import '../../../../ynab_api/_account.dart';
import '../../../../ynab_api/_transaction.dart';
import '../../transactions/filters.dart';
import '../../worker/_base_transactions_sync.dart';

Future<DaysBufferResult> calculateDaysBuffer({
  // All transactions (used for calculating account balances)
  required Iterable<PastTransaction> allTransactionsInDateRange,
  // Transactions used for calculating the daily outflow
  required Iterable<PastTransaction> expenseTransactionsInDateRange,
  // Accounts used for calculating current total balance
  required Iterable<Account> accounts,
  // Categories used for calculating the daily outflow
  required Iterable<Category> categories,
  // DateRange to be used for calculation
  required DateRange dateRange,
}) async {
  return calculateDaysBufferSync(
    allTransactionsInDateRange: allTransactionsInDateRange,
    expenseTransactionsInDateRange: expenseTransactionsInDateRange,
    accounts: accounts,
    categories: categories,
    dateRange: dateRange,
  );
}

DaysBufferResult calculateDaysBufferSync({
  // All transactions (used for calculating account balances)
  required Iterable<PastTransaction> allTransactionsInDateRange,
  // Transactions used for calculating the daily outflow
  required Iterable<PastTransaction> expenseTransactionsInDateRange,
  // Accounts used for calculating current total balance
  required Iterable<Account> accounts,
  // Categories used for calculating the daily outflow
  required Iterable<Category> categories,
  // DateRange to be used for calculation
  required DateRange dateRange,
}) {
  // Calculate the total spend for the selected date range and view.
  final totalSpend = expenseTransactionsInDateRange.sumAmountFilteredSync(isExpense);

  // Calculate the daily outflow for the selected date range.
  final duration = dateRange.duration();
  final dailyOutflow = totalSpend == 0 ? 0 : totalSpend ~/ duration.inDays;

  final dates = dateRange.monthsInRange(useTodayForCurrentMonth: true);

  // Calculate total account balance for each month in the selected date range.
  final currentTotalBalance = accounts.totalBalance();
  final balances = <LocalDate, int>{dates.last: currentTotalBalance};
  final grouped = groupBy(allTransactionsInDateRange, (t) => t.localDate);
  for (final month in dates.toList().reversed) {
    if (dates.first.isSameMonthAs(month)) break;
    final isLastMonth = dates.last.isSameMonthAs(month);
    final entries = grouped.entries.where((e) => e.key.isSameMonthAs(month));
    final transactions = entries.expand((e) => e.value).toList();
    final rollback = transactions.fold(0, (total, e) => total + e.amount * -1);
    final previousMonth = isLastMonth ? dates.last : month.firstDayOfMonth();
    final previousBalance = balances[previousMonth]!;
    final newBalance = previousBalance + rollback;
    balances[month.firstDayOfMonth().subtractMonths(1)] = newBalance;
  }
  final sortedBalances = balances.sortByKeys();

  // Calculate the buffer for each month in the selected date range.
  final buffers = sortedBalances.map((key, value) {
    return MapEntry(key, dailyOutflow == 0 ? null : value / dailyOutflow.abs().toDouble());
  });

  final currentBuffer = buffers.values.lastOrNull?.floor() ?? 0;

  return DaysBufferResult(
    balances: sortedBalances,
    buffers: buffers,
    currentBuffer: currentBuffer,
    dailyOutflow: dailyOutflow,
    totalSpend: totalSpend,
    totalBalance: currentTotalBalance,
  );
}

class DaysBufferResult extends Equatable {
  const DaysBufferResult({
    required this.balances,
    required this.buffers,
    required this.currentBuffer,
    required this.dailyOutflow,
    required this.totalSpend,
    required this.totalBalance,
  });

  factory DaysBufferResult.empty() {
    return const DaysBufferResult(
      balances: {},
      buffers: {},
      currentBuffer: 0,
      dailyOutflow: 0,
      totalSpend: 0,
      totalBalance: 0,
    );
  }

  final Map<LocalDate, int> balances;
  final Map<LocalDate, double?> buffers;
  final int? currentBuffer;
  final int totalSpend;
  final int dailyOutflow;
  final int totalBalance;

  @override
  List<Object?> get props => [
    balances,
    buffers,
    currentBuffer,
    dailyOutflow,
    totalSpend,
    totalBalance,
  ];
}
