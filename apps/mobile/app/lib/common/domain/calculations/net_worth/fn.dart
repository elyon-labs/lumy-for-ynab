import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../features/date_range/domain/models/date_range.dart';
import '../../../../utils/_local_date.dart';
import '../../../../utils/sort.dart';
import '../../../../ynab_api/_transaction.dart';

typedef NetWorthSummary = ({int assets, int liabilities, int netWorth});

Map<LocalDate, NetWorthSummary> calculateNetWorthSync({
  required LocalDate startMonth,
  required LocalDate endMonth,
  required List<Account> accounts,
  required List<PastTransaction> transactions,
}) {
  final datesToTransactions = groupBy(
    transactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateAsc);

  final budgetDateRange = (from: startMonth, to: endMonth);
  final months = budgetDateRange.monthsInRange().toList();

  var accountBalances = {for (final e in accounts) e: e.balance};
  final debts = accountBalances.entries.where((e) => e.value.isNegative).toList();
  final assets = accountBalances.entries.where((e) => !e.value.isNegative).toList();
  final netWorths = <LocalDate, NetWorthSummary>{
    months.last: (
      assets: assets.map((e) => e.value).sum,
      liabilities: debts.map((e) => e.value).sum,
      netWorth: accountBalances.values.sum,
    ),
  };

  for (final month in months.reversed.toList()) {
    if (months.first.isSameMonthAs(month)) break;
    final entries = datesToTransactions.entries.where((e) => e.key.isSameMonthAs(month));
    final transactions = entries.expand((e) => e.value);
    for (final t in transactions) {
      accountBalances = _updateAccountBalances(accountBalances: accountBalances)(t);
    }
    var assets = 0;
    var debts = 0;
    for (final account in accountBalances.keys) {
      final balance = accountBalances[account]!;
      if (balance >= 0) {
        assets += balance;
      } else if (balance < 0) {
        debts += balance;
      }
    }
    final calculatedMonth = month.firstDayOfMonth().subtractMonths(1);
    netWorths[calculatedMonth] = (assets: assets, liabilities: debts, netWorth: assets + debts);
  }
  return netWorths;
}

Map<Account, int> Function(PastTransaction transaction) _updateAccountBalances({
  required Map<Account, int> accountBalances,
}) {
  return (transaction) {
    final account = accountBalances.keys.singleWhereOrNull((a) => a.id == transaction.accountId);
    if (account == null) return accountBalances;
    final balance = accountBalances[account] ?? account.balance;
    final rollbackAmount = transaction.amount * -1;
    return accountBalances..[account] = balance + rollbackAmount;
  };
}
