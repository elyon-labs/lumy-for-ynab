import 'package:collection/collection.dart';

import '../../../../common/presentation/_int.dart';
import '../../../../utils/_local_date.dart';
import 'frugal_month.dart';

enum FrugalMonthStatus {
  notStarted._('This month has not started yet.'),
  onTrack._('You are on track to meet your goal. Keep it up!'),
  inDanger._('Based on current spending, you may not meet your goal.'),
  overSpent._('Nice try! You have already spent more than your limit.'),
  completeSuccess._('Amazing! You met your goal and spent less than the limit.'),
  completeFailure._("Get 'em next time! You spent more than the limit.");

  const FrugalMonthStatus._(this.explainer);

  final String explainer;
}

extension FrugalMonthX on FrugalMonth {
  FrugalMonthStatus calculateStatus(int totalSpent, Map<int, double> averageSpendPerDay) {
    if (today.isBefore(month.firstDayOfMonth())) {
      return FrugalMonthStatus.notStarted;
    } else {
      final target = targetAmount;
      final hasOverspent = totalSpent.isNegative && totalSpent.abs() > target;
      // The remaining days in the month
      final remainingDays = averageSpendPerDay.entries.where((e) => e.key >= today.dayOfMonth);
      // The total expected spend for the remaining days
      final remainingSpendExpected = remainingDays.map((e) => e.value).sum.abs();
      // The total expected spend for the month
      final expectedSpend = totalSpent.abs() + remainingSpendExpected;

      if (today.isAfter(month.lastDayOfMonth())) {
        if (!hasOverspent) {
          return FrugalMonthStatus.completeSuccess;
        } else {
          return FrugalMonthStatus.completeFailure;
        }
      } else {
        if (totalSpent.isPositive) {
          return FrugalMonthStatus.onTrack;
        }
        if (hasOverspent) {
          return FrugalMonthStatus.overSpent;
        }
        if (expectedSpend < target) {
          return FrugalMonthStatus.onTrack;
        }
        return FrugalMonthStatus.inDanger;
      }
    }
  }
}

extension FrugalMonthStatusX on FrugalMonthStatus {
  bool get isComplete {
    return switch (this) {
      FrugalMonthStatus.completeSuccess => true,
      FrugalMonthStatus.completeFailure => true,
      _ => false,
    };
  }

  bool get hasStarted {
    return switch (this) {
      FrugalMonthStatus.notStarted => false,
      _ => true,
    };
  }

  bool get isInProgress {
    return hasStarted && !isComplete;
  }
}
