import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../transactions/filters.dart';
import '_base_transactions_sync.dart';

extension ListBaseTransactionAsyncX<T extends BaseTransaction> on Iterable<T> {
  /// Runs `filter` async with the given adhoc [filter].
  Future<List<T>> filter(TransactionFilter filter) async {
    return await $worker().run(() {
      return filterSync(filter);
    });
  }

  /// Groups the receiver [BaseTransaction]s by category. Note that
  /// this uses [filterSync] under the hood, so in the case of split transactions,
  /// only those [SubTransaction]s that match the [Category] that is the key
  /// will be included in the value's list.
  Future<Map<Category, List<T>>> groupByCategory(List<Category> categories) async {
    return await $worker().run(() {
      return groupByCategorySync(categories);
    });
  }

  /// Groups the receiver [BaseTransaction]s by payee. Note that this uses
  /// [filterSync] under the hood, so in the case of split transactions, only those
  /// [SubTransaction]s that match the [Payee] that is the key will be included
  /// in the value's list.
  ///
  /// Payees are represented by an [Option] because some transactions do not have a
  /// payee (`payeeId` and `payeeName` are null). All of those transactions will be
  /// placed in the value list of the key `None()`.
  Future<Map<Option<Payee>, List<T>>> groupByPayee(List<Payee> payees) async {
    return await $worker().run(() {
      return groupByPayeeSync(payees);
    });
  }

  /// Sums the `amount` of [BaseTransaction]s in the receiver
  /// using the provided [TransactionFilter]
  Future<int> sumAmountFiltered(TransactionFilter filter) async {
    return await $worker().run(() {
      return sumAmountFilteredSync(filter);
    });
  }
}
