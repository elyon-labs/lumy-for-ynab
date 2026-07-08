import 'package:equatable/equatable.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'spend_tracker.dart';

typedef SpendForMonth = ({LocalDate month, int spend});

class SpendTrackerData extends Equatable {
  const SpendTrackerData({
    required this.spendTracker,
    required this.description,
    required this.netTotal,
    required this.transactionsCount,
    required this.transactionsPerWeek,
    required this.averageWeeklySpend,
    required this.transactionsPerMonth,
    required this.averageMonthlySpend,
    required this.monthsToTransactions,
    required this.monthsToSpend,
    required this.percentIncome,
    required this.minSpendForMonth,
    required this.maxSpendForMonth,
  });

  final SpendTracker spendTracker;
  final String? description;
  final int netTotal;
  final int transactionsCount;
  final double transactionsPerWeek;
  final int averageWeeklySpend;
  final double transactionsPerMonth;
  final int averageMonthlySpend;
  final Map<LocalDate, List<PastTransaction>> monthsToTransactions;
  final Map<LocalDate, int> monthsToSpend;
  final double percentIncome;
  final SpendForMonth? minSpendForMonth;
  final SpendForMonth? maxSpendForMonth;

  @override
  List<Object?> get props => [
    spendTracker,
    description,
    netTotal,
    transactionsCount,
    transactionsPerWeek,
    averageWeeklySpend,
    transactionsPerMonth,
    averageMonthlySpend,
    monthsToTransactions,
    monthsToSpend,
    percentIncome,
    minSpendForMonth,
    maxSpendForMonth,
  ];
}
