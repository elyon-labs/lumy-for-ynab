import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../utils/_local_date.dart';
import '../utils/_string.dart';

extension TransactionX on PastTransaction {
  bool get isSplit => subTransactions.isNotEmpty;

  bool happenedSince(LocalDate date, {bool inclusive = true}) {
    final sameDayAs = inclusive && localDate.isSameDayAs(date);
    return localDate.isAfter(date) || sameDayAs;
  }

  bool happenedBefore(LocalDate date, {bool inclusive = true}) {
    final sameMomentAs = inclusive && localDate.isSameDayAs(date);
    return localDate.isBefore(date) || sameMomentAs;
  }

  LocalDate get localDate {
    return cachedLocalDates.putIfAbsent(date, date.yyyyMMddToLocalDate);
  }

  List<String> get payeeIds {
    return <String?>{payeeId, ...subTransactions.map((e) => e.payeeId)}.nonNulls.toList();
  }
}
