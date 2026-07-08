import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../utils/_local_date.dart';
import '../utils/_string.dart';

extension ScheduledTransactionX on ScheduledTransaction {
  bool get isSplit => subTransactions.isNotEmpty;

  LocalDate get localDateFirst {
    return cachedLocalDates.putIfAbsent(dateFirst, dateFirst.yyyyMMddToLocalDate);
  }

  LocalDate get localDateNext {
    return cachedLocalDates.putIfAbsent(dateNext, dateNext.yyyyMMddToLocalDate);
  }

  List<String> get payeeIds {
    return <String?>{payeeId, ...subTransactions.map((e) => e.payeeId)}.nonNulls.toList();
  }

  String get frequencyDescription {
    return switch (frequency) {
      ScheduledTransactionFrequency.never => 'once',
      ScheduledTransactionFrequency.daily => 'daily',
      ScheduledTransactionFrequency.weekly => 'weekly',
      ScheduledTransactionFrequency.everyOtherWeek => 'every other week',
      ScheduledTransactionFrequency.twiceAMonth => 'twice a month',
      ScheduledTransactionFrequency.every4Weeks => 'every 4 weeks',
      ScheduledTransactionFrequency.monthly => 'monthly',
      ScheduledTransactionFrequency.everyOtherMonth => 'every other month',
      ScheduledTransactionFrequency.every3Months => 'every 3 months',
      ScheduledTransactionFrequency.every4Months => 'every 4 months',
      ScheduledTransactionFrequency.twiceAYear => 'twice a year',
      ScheduledTransactionFrequency.yearly => 'yearly',
      ScheduledTransactionFrequency.everyOtherYear => 'every other year',
    };
  }

  int get annualAmount {
    return switch (frequency) {
      ScheduledTransactionFrequency.never => amount,
      ScheduledTransactionFrequency.daily => amount * 365,
      ScheduledTransactionFrequency.weekly => amount * 52,
      ScheduledTransactionFrequency.everyOtherWeek => amount * 26,
      ScheduledTransactionFrequency.twiceAMonth => amount * 24,
      ScheduledTransactionFrequency.every4Weeks => amount * 13,
      ScheduledTransactionFrequency.monthly => amount * 12,
      ScheduledTransactionFrequency.everyOtherMonth => amount * 6,
      ScheduledTransactionFrequency.every3Months => amount * 4,
      ScheduledTransactionFrequency.every4Months => amount * 3,
      ScheduledTransactionFrequency.twiceAYear => amount * 2,
      ScheduledTransactionFrequency.yearly => amount,
      ScheduledTransactionFrequency.everyOtherYear => amount ~/ 2,
    };
  }
}
