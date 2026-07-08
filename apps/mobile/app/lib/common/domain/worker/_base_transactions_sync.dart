import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../ynab_api/_base_transaction.dart';
import '../transactions/filters.dart';

extension ListBaseTransactionSyncX<T extends BaseTransaction> on Iterable<T> {
  /// Returns a list of [T] where [filter] returns `true`. Note that this means
  /// parent [BaseTransaction]s returned by this function will only contain
  /// [SubTransaction]s or [ScheduledSubTransaction]s that match the provided
  /// filter, and any other [SubTransaction]s or [ScheduledSubTransaction]s will
  /// be discarded.
  List<T> filterSync(TransactionFilter filter, {BaseTransaction? parent}) {
    final output = <T>[];
    for (final transaction in this) {
      switch (transaction) {
        case PastTransaction(subTransactions: final subTransactions):
          final filteredSubTransactions = subTransactions.filterSync(filter, parent: transaction);
          if (filter(transaction, null) || filteredSubTransactions.isNotEmpty) {
            output.add(transaction.copyWith(subTransactions: filteredSubTransactions) as T);
          }
        case SubTransaction():
          if (filter(transaction, parent)) {
            output.add(transaction);
          }
        case ScheduledTransaction(:final subTransactions):
          final filteredSubTransactions = subTransactions.filterSync(filter, parent: transaction);
          if (filter(transaction, null) || filteredSubTransactions.isNotEmpty) {
            output.add(transaction.copyWith(subTransactions: filteredSubTransactions) as T);
          }
        case ScheduledSubTransaction():
        // TODO: Handle this case.
      }
    }
    return output;
  }

  /// Applies the given [combine] function to [PastTransaction]s and [SubTransaction]s
  /// in the receiver [Iterable] based on a set of rules (described below).
  ///
  /// [combine] is called with the following arguments:
  /// - `prev`: The value returned by the previous call to [combine], or [initialValue] if this is the first call.
  /// - `element`: The result of calling [transform] on the current [BasePastTransaction] being processed.
  /// It must return a new value of type [R].
  ///
  /// [combine] is called on a [PastTransaction] when:
  /// - The [PastTransaction] matches the [filter]. In this case, the `isMatch`
  /// argument passed to [transform] will be `true`.
  /// - The [PastTransaction] does *not* match the [filter], but one or more of its [SubTransaction]s do.
  /// In this case, the `isMatch` argument passed to [transform] will be `false`.
  ///
  /// [combine] is called on a [SubTransaction] when:
  /// - The [SubTransaction] matches the [filter]. In this case, the `isMatch`
  /// argument passed to [transform] will be `true`.
  R foldFilteredSync<R extends Object>({
    required TransactionFilter filter,
    required R Function(BaseTransaction transaction, bool isMatch) transform,
    required R Function(R prev, R element) combine,
    required R initialValue,
    BaseTransaction? parent,
  }) {
    return fold<R>(initialValue, (prev, transaction) {
      switch (transaction) {
        case PastTransaction(:final subTransactions):
          return combine(
            subTransactions.foldFilteredSync(
              filter: filter,
              transform: transform,
              combine: combine,
              initialValue: prev,
              parent: transaction,
            ),
            transform(transaction, filter(transaction, null)),
          );
        case SubTransaction():
          return combine(prev, transform(transaction, filter(transaction, parent)));
        case ScheduledTransaction(:final subTransactions):
          return combine(
            subTransactions.foldFilteredSync(
              filter: filter,
              transform: transform,
              combine: combine,
              initialValue: prev,
              parent: transaction,
            ),
            transform(transaction, filter(transaction, null)),
          );
        case ScheduledSubTransaction():
          return combine(prev, transform(transaction, filter(transaction, parent)));
      }
    });
  }

  int sumAmountFilteredSync(TransactionFilter filter) {
    return foldFilteredSync<int>(
      filter: filter,
      transform: (t, isMatch) => isMatch ? t.amount : 0,
      combine: (prev, current) => prev + current,
      initialValue: 0,
    );
  }

  int countFilteredSync(TransactionFilter filter) {
    return foldFilteredSync<int>(
      filter: filter,
      transform: (_, isMatch) => isMatch ? 1 : 0,
      combine: (prev, current) => prev + current,
      initialValue: 0,
    );
  }

  /// Groups the receiver [BaseTransaction]s by category. This preserves
  /// [filterSync] split transaction semantics for each category value.
  Map<Category, List<T>> groupByCategorySync(List<Category> categories) {
    return {
      for (final category in categories)
        category: filterSync((t, _) => t.categoryId == category.id),
    };
  }

  /// Groups the receiver [BaseTransaction]s by payee. This preserves
  /// [filterSync] split transaction semantics for each payee value.
  Map<Option<Payee>, List<T>> groupByPayeeSync(List<Payee> payees) {
    final output = <String, List<T>>{};
    final presentPayeeIds = expand((t) => t.payeeIds).toSet();

    for (final payeeId in presentPayeeIds) {
      output[payeeId] = filterSync((t, p) => t.hasPayeeId(Some(payeeId), parent: p));
    }

    final transactionsWithoutPayee = filterSync((t, _) => t.payeeId == null);

    final Map<Option<Payee>, List<T>> mapped = output.mapNotNull((key, value) {
      final payee = payees.firstWhereOrNull((p) => p.id == key);
      if (payee == null) return null;
      return MapEntry(Some(payee), value);
    });

    if (transactionsWithoutPayee.isNotEmpty) {
      mapped[const None()] = transactionsWithoutPayee;
    }

    return mapped;
  }
}
