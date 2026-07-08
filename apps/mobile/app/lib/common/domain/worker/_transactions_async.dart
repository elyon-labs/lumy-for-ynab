import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_transaction.dart';
import '_transactions_sync.dart';

extension ListPastTransactionAsyncX on Iterable<PastTransaction> {
  Future<Map<LocalDate, List<PastTransaction>>> groupByDate([
    int Function(LocalDate a, LocalDate b)? compare,
  ]) async {
    return await $worker().run(() {
      return groupByDateSync(compare);
    });
  }

  Future<Map<LocalDate, List<PastTransaction>>> groupByMonth({
    int Function(LocalDate a, LocalDate b)? compare,
  }) async {
    return await $worker().run(() {
      return groupBy(this, (t) => t.localDate.firstDayOfMonth()).sortByKeys(compare ?? dateDesc);
    });
  }
}
