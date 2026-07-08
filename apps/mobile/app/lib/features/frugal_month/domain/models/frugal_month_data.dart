import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../utils/_T.dart';
import '../../../../utils/_local_date.dart';
import 'frugal_month.dart';
import 'frugal_month_status.dart';

class FrugalMonthData {
  FrugalMonthData({
    required this.month,
    required this.totalSpent,
    required this.leftToSpend,
    required this.netIncome,
    required this.status,
    required this.transactions,
    required this.cumulativeSpend,
    required this.projectedSpend,
  });

  final FrugalMonth month;
  final int totalSpent;
  final int leftToSpend;
  final int netIncome;
  final FrugalMonthStatus status;
  final Map<LocalDate, List<PastTransaction>> transactions;
  final Map<LocalDate, int> cumulativeSpend;
  final Map<LocalDate, int> projectedSpend;

  double get percentageSpent => (totalSpent.abs() / month.targetAmount) * 100;

  bool get hasTransactions => transactions.values.flattenSafe().isNotEmpty;

  double get percentOfMonthPassed {
    if (month.month.firstDayOfMonth().isSameOrAfterToday()) {
      // Not yet started
      return 0;
    } else if (month.month.lastDayOfMonth().isSameOrBeforeToday()) {
      // Already finished
      return 100;
    } else {
      final daysPassed = today.dayOfMonth;
      final totalDays = month.month.numDaysInMonth();
      return (daysPassed / totalDays) * 100;
    }
  }
}
