import 'package:dart_foundation/dart_foundation.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../utils/_int.dart';
import '../../../../utils/_local_date.dart';
import '../../../../utils/sort.dart';
import '../../transactions/filters.dart';
import '../../worker/_base_transactions_async.dart';
import '../../worker/_transactions_async.dart';

Future<Map<LocalDate, int?>> calculateSpentThisMonth({
  required List<PastTransaction> transactions,
  required LocalDate month,
}) async {
  final grouped = await transactions.groupByDate(dateAsc);
  final amounts = await grouped.mapValuesAsync((value) async {
    return await value.sumAmountFiltered(isExpense);
  });
  final filledAmounts = amounts.fillWith(month.daysInMonth(), fill: (date) => 0);
  final values = filledAmounts.entries.map((e) => e.value);
  final accumulated = values.accumulate();
  return filledAmounts.mapIndexed((index, date, amount) {
    return MapEntry(date, date.isAfter(today) ? null : accumulated.elementAt(index));
  });
}
