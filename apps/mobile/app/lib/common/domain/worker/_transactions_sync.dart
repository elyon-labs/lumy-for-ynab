import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../utils/_T.dart';
import '../../../utils/_local_date.dart';
import '../../../ynab_api/_transaction.dart';

extension ListPastTransactionsSyncX on Iterable<PastTransaction> {
  Map<LocalDate, R> reduceSync<R>({
    required List<LocalDate> dates,
    required R initialValue,
    required R Function(Iterable<PastTransaction> transactions) transform,
  }) {
    // Initialize the storage with the dates and the initial value.
    // Initial value will be overwritten by transformed values.
    final storage = Map<LocalDate, R>.fromIterable(dates, value: (i) => initialValue);
    final groupedByDate = groupBy(this, (p0) => p0.localDate);
    for (var i = dates.length - 1; i >= 0; i--) {
      final current = dates.elementAt(i);
      final previous = dates.elementAtOrNull(i + 1);
      // Get the transactions that happened between the current
      // and previous date.
      final dateEntries = groupedByDate.entries.where((e) {
        return e.key.isBetween(current, previous, inclusiveEnd: false);
      });
      // Transform the transactions and store the result for the current date.
      final value = transform(dateEntries.map((e) => e.value).flattenSafe());
      storage[current] = value;
    }
    return storage;
  }

  Iterable<PastTransaction> sortByDateSync([int Function(LocalDate a, LocalDate b)? compare]) {
    return toList()..sortByCompare(
      (e) => e.localDate,
      // By default, sort in descending order.
      compare ?? (LocalDate a, LocalDate b) => b.compareTo(a),
    );
  }

  Map<LocalDate, List<PastTransaction>> groupByDateSync([
    int Function(LocalDate a, LocalDate b)? compare,
  ]) {
    return groupBy(this, (t) => t.localDate).sortByKeys(compare);
  }

  List<PastTransaction> whereHappenedBeforeSync(LocalDate date, {bool inclusive = true}) {
    return where((t) => t.happenedBefore(date, inclusive: inclusive)).toList();
  }

  List<PastTransaction> whereHappenedSinceSync(LocalDate date, {bool inclusive = true}) {
    return where((t) => t.happenedSince(date, inclusive: inclusive)).toList();
  }
}
